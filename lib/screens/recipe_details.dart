import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({Key? key, required this.dish}) : super(key: key);

  final QueryDocumentSnapshot<Object?> dish;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child:
                dish["image"].isNotEmpty
                    ? Image(
                      image: CachedNetworkImageProvider(dish["image"]),
                      fit: BoxFit.cover,
                      width: 250,
                      height: 250,
                    )
                    : Image.asset(
                      'assets/images/can_tower.jpg',
                      fit: BoxFit.cover,
                      width: 250,
                      height: 250,
                    ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dish["name"],
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  dish["desc"],
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star),
                    Text(dish["rating"].toString(), style: TextStyle()),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time),
                    Text("${dish["prep_time"]}m", style: TextStyle()),
                    const SizedBox(width: 16),
                    Icon(Icons.local_fire_department_outlined),
                    Text("${dish["energy"]}kcal", style: TextStyle()),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${dish["ingredients"].length} item(s)',
                      style: TextStyle(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    itemCount: dish["ingredients"].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final ingredient = dish["ingredients"][index];
                      return _buildIngredientItem(context, ingredient);
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 8),
                  ),
                ),
                const SizedBox(height: 24),
                dish["allergy"].isNotEmpty
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'May contain',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${dish["allergy"].length} item(s)',
                          style: TextStyle(),
                        ),
                      ],
                    )
                    : SizedBox(),
                dish['allergy'].isNotEmpty
                    ? const SizedBox(height: 16)
                    : SizedBox(),
                dish["allergy"].isNotEmpty
                    ? SizedBox(
                      height: 40,
                      child: ListView.separated(
                        itemCount: dish["allergy"].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final ingredient = dish["allergy"][index];
                          return _buildAllergenItem(context, ingredient);
                        },
                        separatorBuilder:
                            (context, index) => SizedBox(width: 8),
                      ),
                    )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(BuildContext context, String name) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: BoxConstraints(minWidth: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAllergenItem(BuildContext context, String name) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: BoxConstraints(minWidth: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
