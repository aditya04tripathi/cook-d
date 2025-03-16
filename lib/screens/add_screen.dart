import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_d/screens/home_screen.dart';
import 'package:cook_d/widgets/custom_button.dart';
import 'package:cook_d/widgets/custom_text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _dishNameController = TextEditingController(
    text: "Scrabbled Eggs",
  );
  File _selectedImage = File('');
  String _imageName = '';
  bool _isUploading = false;
  String _uploadedImageUrl = '';

  TextEditingController timeTextController = TextEditingController(
    text: "30 minutes",
  );
  TextEditingController locationTextController = TextEditingController(
    text: "LTB",
  );
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var recipeData = {};

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      setState(() {
        _selectedImage = File(pickedFile!.path);
      });
      Get.back();
    } catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  Future<void> handleAddDish() async {
    debugPrint('Starting handleAddDish function');
    if (_selectedImage.path.isEmpty) {
      Get.snackbar("Error", "Please select an image");
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String finalName =
        "${DateTime.now().millisecondsSinceEpoch}_${FirebaseAuth.instance.currentUser?.displayName ?? "atri0048"}";

    try {
      final String destination = 'dishes/$finalName';

      final Reference ref = _storage.ref().child(destination);
      final UploadTask uploadTask = ref.putFile(
        _selectedImage,
        SettableMetadata(contentType: 'image/png'),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String uploadedImageUrl = await snapshot.ref.getDownloadURL();

      debugPrint('Image uploaded to: $uploadedImageUrl');

      // Add dish to Firestore
      debugPrint('Creating document with ID: $finalName');

      final dishData = {
        "createdBy":
            FirebaseAuth.instance.currentUser?.email ??
            "atri0048@student.monash.edu",
        "allergy": recipeData['data']['allergens'],
        "description": recipeData['data']['description'],
        "image": uploadedImageUrl,
        "location": locationTextController.text,
        "macros": (recipeData['data']['nutrition']).map((e) {
          return "${e[0]}: ${e[1]}";
        }),
        "name": _dishNameController.text,
        "prep_time": recipeData['data']['prep_time'],
        "spots": recipeData["data"]["servings"],
        "time": timeTextController.text,
      };

      debugPrint(
        {
          "createdBy":
              FirebaseAuth.instance.currentUser?.email ??
              "atri0048@student.monash.edu",
          "allergy": recipeData['data']['allergens'],
          "description": recipeData['data']['description'],
          "image": "uploadedImageUrl",
          "location": locationTextController.text,
          "macros": (recipeData['data']['nutrition']).map((e) {
            return "${e[0]}: ${e[1]}";
          }),
          "name": _dishNameController.text,
          "prep_time": recipeData['data']['prep_time'],
          "spots": recipeData["data"]["servings"],
          "time": timeTextController.text,
        }.toString(),
      );

      await FirebaseFirestore.instance.collection('dishes').add(dishData);

      debugPrint('Dish added successfully to Firestore');
      Get.snackbar("Success", "Dish added successfully");
      Get.to(() => HomePage());
    } catch (e) {
      debugPrint('Exception in handleAddDish: $e');
      Get.snackbar("Error", "Failed to add dish: ${e.toString()}");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> getRecipeAPI() async {
    final Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        validateStatus: (status) {
          return status! <= 500;
        },
      ),
    );

    try {
      setState(() {
        recipeData = {};
      });

      final response = await dio.get(
        "https://cookd.menmattertoo.space/api/recipe?query=${Uri.encodeComponent(_dishNameController.text)}",
      );

      debugPrint("");
      debugPrint(
        "Response URL      : https://cookd.menmattertoo.space/api/recipe?query=${Uri.encodeComponent(_dishNameController.text)}",
      );
      debugPrint('Recipe status code: ${response.statusCode}');
      debugPrint('Recipe status code: ${response.statusMessage}');
      debugPrint('Recipe response   : ${response.data}');
      debugPrint("");

      setState(() {
        recipeData = response.data;
      });
    } catch (e) {
      debugPrint('Error generating recipe: $e');
      Get.snackbar("Error", "Failed to generate recipe");
    }
  }

  @override
  void dispose() {
    _dishNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Add a dish', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Wrap(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              child: const Text(
                                "Choose an image",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Photo Library'),
                              onTap: () => _pickImage(ImageSource.gallery),
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text('Camera'),
                              onTap: () => _pickImage(ImageSource.camera),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(150),
                    image:
                        _selectedImage.path.isNotEmpty
                            ? DecorationImage(
                              image: FileImage(_selectedImage),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      _selectedImage.path.isEmpty
                          ? const Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.grey,
                          )
                          : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextInput(
              hintText: "Dish name",
              prefixIcon: Icons.restaurant,
              obscureText: false,
              controller: _dishNameController,
            ),
            const SizedBox(height: 8),
            CustomButton(title: "Generate", onPressed: getRecipeAPI),
            const SizedBox(height: 16),
            CustomTextInput(
              hintText: "30 minutes, 45 minutes, 1 hour, etc.",
              prefixIcon: Icons.access_time,
              obscureText: false,
              controller: timeTextController,
            ),
            const SizedBox(height: 8),
            CustomTextInput(
              hintText: "LTB, Lemon Scented Lawn, etc.",
              prefixIcon: Icons.location_on,
              obscureText: false,
              controller: locationTextController,
            ),
            const SizedBox(height: 16),
            RecipeInformation(recipe: recipeData),
          ],
        ),
      ),
    );
  }

  Widget RecipeInformation({required recipe}) {
    if (recipe.isEmpty ||
        !recipe.containsKey('data') ||
        recipe['data'] == null) {
      return SizedBox();
    }

    return Column(
      children: [
        Text(
          recipeData['data']['title'],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildInfoCard(
              icon: Icons.access_time,
              title: "Cook Time",
              value: "${recipeData['data']['cook_time']} min",
            ),
            _buildInfoCard(
              icon: Icons.local_dining,
              title: "Servings",
              value: "${recipeData['data']['servings']}",
            ),
            _buildInfoCard(
              icon: Icons.favorite,
              title: "Health Score",
              value:
                  recipeData["data"]["health_score"] != null
                      ? "${recipeData['data']['health_score']}"
                      : "N/A",
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "Ingredients",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(recipeData['data']['ingredients'].length, (index) {
          final ingredient = recipeData['data']['ingredients'][index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${ingredient['quantity']} ${ingredient['name']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 20),
        Text(
          "Nutrition Facts",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recipeData['data']['nutrition'].length,
            itemBuilder: (context, index) {
              final nutrient = recipeData['data']['nutrition'][index];
              if (nutrient.length >= 2) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: _buildNutritionItem(nutrient[0], nutrient[1]),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        const SizedBox(height: 20),
        if (recipeData['data']['allergens'].isNotEmpty) ...[
          Text(
            "Allergens",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 8);
              },
              itemBuilder: (context, index) {
                final allergen = recipeData['data']['allergens'][index];

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        allergen,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              },
              itemCount: recipeData['data']['allergens'].length,
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(title: "Add Dish", onPressed: () => handleAddDish()),
        ],
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          "$title: $value",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
