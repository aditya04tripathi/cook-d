from flask import Flask, request, jsonify
import os
import pandas as pd
from typing import List, Dict, Any
import tempfile
import logging

from components import (
    FileComponent, 
    DataToDataFrameComponent, 
    ParseDataFrameComponent, 
    AgentComponent,
    TextInputComponent
)
from langflow.schema import Data, DataFrame
from langflow.schema.message import Message
from langflow.base.agents.events import ExceptionWithMessageError
from langflow.field_typing import Tool

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Cache for dataframes to avoid reloading files
csv_dataframes = {}
parsed_data = None

async def load_and_process_csv_files(csv_paths: List[str]):
    """Load CSV files, convert to dataframes, and parse them."""
    global csv_dataframes, parsed_data
    
    logger.info(f"Loading CSV files: {csv_paths}")
    
    # Step 1: Load CSV files using FileComponent
    data_objects = []
    for csv_path in csv_paths:
        try:
            file_comp = FileComponent()
            file_comp.set(file_path=csv_path, use_multithreading=True, concurrency_multithreading=3, silent_errors=False)
            processed_files = file_comp.load_from_file()
            
            if processed_files:
                for file in processed_files:
                    if file.data is not None:
                        data_objects.append(file.data)
            else:
                logger.warning(f"No data found in {csv_path}")
        except Exception as e:
            logger.error(f"Error loading file {csv_path}: {e}")
            continue
    
    if not data_objects:
        raise ValueError("No data could be loaded from CSV files")
    
    # Step 2: Convert Data objects to DataFrame
    try:
        df_comp = DataToDataFrameComponent()
        df_comp.set(data_list=data_objects)
        dataframe = df_comp.build_dataframe()
        
        # Cache the dataframe
        csv_dataframes = dataframe
        
        # Step 3: Parse the DataFrame into text
        parse_comp = ParseDataFrameComponent()
        template = "{text}"
        parse_comp.set(df=dataframe, template=template, sep="\n")
        parsed_text = parse_comp.parse_data()
        parsed_data = parsed_text
        
        logger.info("CSV files loaded and processed successfully")
        return parsed_text
    except Exception as e:
        logger.error(f"Error processing data: {e}")
        raise

async def get_agent_recommendation(user_input: str, csv_data_message: Message):
    """Use the agent to generate recommendations based on user input and CSV data."""
    try:
        # Create text input component for user input
        text_comp = TextInputComponent()
        text_comp.set(input_value=user_input)
        user_message = text_comp.text_response()
        
        # Combine user input with CSV data context
        combined_input = f"""
Context information from database:
{options_list}

User information:
{user_name}
        """
        
        # Configure and run the agent
        agent = AgentComponent()
        agent.set(
            agent_llm="Groq",
            model_name="mixtral-8x7b-32768",
            api_key=os.environ.get("GROQ_API_KEY"),
            temperature=0.2,
            system_prompt="""
You are a recommendation agent that analyzes data and makes prioritized recommendations.
Given the context information from the database and the user's request:
1. Analyze the data provided in the context.
2. Consider the user's specific requirements in their request.
3. Create a prioritized list of recommendations based on the data and user needs.
4. Return the recommendations as a numbered list in order of priority.
5. Explain your reasoning briefly for each recommendation.

Take some inspiration from this priority order:

Priority 1: Dietary and Allergen Preferences.
Priority 2: Ingredient similarity between past orders.
Priority 3: Order history.

You are expected to give just the names of the dishes from the given available dishes in a priority list in the format:

[Dish1, Dish2, Dish3, Dish4]
            """,
            input_value=combined_input,
            add_current_date_tool=True,
            max_iterations=10,
            tools=[],
        )
        
        # Run the agent
        response = await agent.message_response()
        return response
    except ExceptionWithMessageError as e:
        logger.error(f"Agent error: {e}")
        return Message(text=f"Error generating recommendations: {str(e)}")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return Message(text=f"Unexpected error: {str(e)}")

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint."""
    return jsonify({"status": "healthy", "message": "Recommendation agent is running"}), 200

@app.route('/setup', methods=['POST'])
async def setup_system():
    """Load CSV files into memory."""
    if not request.is_json:
        return jsonify({"error": "Request must be JSON"}), 400
    
    data = request.json
    csv_paths = data.get('csv_paths', ["./user.csv", "./cook.csv", "./dish.csv"])
    
    if not csv_paths or not isinstance(csv_paths, list):
        return jsonify({"error": "csv_paths must be a non-empty list of file paths"}), 400
    
    try:
        # Check if all files exist
        for path in csv_paths:
            if not os.path.exists(path):
                return jsonify({"error": f"File not found: {path}"}), 404
        
        # Load and process CSV files
        await load_and_process_csv_files(csv_paths)
        
        return jsonify({
            "status": "success",
            "message": f"Successfully loaded {len(csv_paths)} CSV files",
        })
    except Exception as e:
        logger.error(f"Setup error: {e}")
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/upload', methods=['POST'])
async def upload_csv():
    """Upload CSV files and load them into memory."""
    if 'files' not in request.files:
        return jsonify({"error": "No files part in the request"}), 400
    
    files = request.files.getlist('files')
    if not files or files[0].filename == '':
        return jsonify({"error": "No files selected"}), 400
    
    try:
        # Save uploaded files to temporary location
        temp_paths = []
        for file in files:
            if file and file.filename.endswith('.csv'):
                fd, path = tempfile.mkstemp(suffix='.csv')
                os.close(fd)
                file.save(path)
                temp_paths.append(path)
        
        if not temp_paths:
            return jsonify({"error": "No valid CSV files uploaded"}), 400
        
        # Load and process CSV files
        await load_and_process_csv_files(temp_paths)
        
        return jsonify({
            "status": "success",
            "message": f"Successfully loaded {len(temp_paths)} CSV files",
            "temp_paths": temp_paths
        })
    except Exception as e:
        logger.error(f"Upload error: {e}")
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/recommend', methods=['POST'])
async def recommend():
    """Get recommendations based on user input and cached CSV data."""
    if not request.is_json:
        return jsonify({"error": "Request must be JSON"}), 400
    
    data = request.json
    user_input = data.get('input')
    
    if not user_input:
        return jsonify({"error": "Input field is required"}), 400
    
    # Check if CSV data is loaded
    if not parsed_data:
        return jsonify({
            "error": "No CSV data loaded. Please call /setup or /upload endpoint first"
        }), 400
    
    try:
        # Get recommendations from agent
        response = await get_agent_recommendation(user_input, parsed_data)
        
        return jsonify({
            "status": "success",
            "recommendations": response.text,
        })
    except Exception as e:
        logger.error(f"Recommendation error: {e}")
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))