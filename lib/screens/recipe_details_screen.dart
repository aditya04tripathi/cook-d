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
                dish["image"] != null
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
                dish["description"] != null
                    ? Text(
                      dish["description"],
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    )
                    : SizedBox(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined),
                    Text(dish["location"] ?? "Unknown", style: TextStyle()),
                    const SizedBox(width: 16),
                    Icon(Icons.timer_outlined),
                    Text(dish["time"] ?? "Unknown", style: TextStyle()),
                    const SizedBox(width: 16),
                    Icon(Icons.local_fire_department_outlined),
                    Text(
                      "${dish["macros"] != null ? dish["macros"]["Energy"].split(' ')[0] : "Unknown"} kJ",
                      style: TextStyle(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group_outlined),
                    Text("${dish["spots"] ?? 0} spots", style: TextStyle()),
                  ],
                ),
                const SizedBox(height: 24),
                _buildMacroNutrients(context, dish["macros"]),
                const SizedBox(height: 24),
                dish["allergy"] != null && (dish["allergy"] as List).isNotEmpty
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
                          '${(dish["allergy"] as List).length} item(s)',
                          style: TextStyle(),
                        ),
                      ],
                    )
                    : SizedBox(),
                dish["allergy"] != null && (dish["allergy"] as List).isNotEmpty
                    ? const SizedBox(height: 16)
                    : SizedBox(),
                dish["allergy"] != null && (dish["allergy"] as List).isNotEmpty
                    ? SizedBox(
                      height: 40,
                      child: ListView.separated(
                        itemCount: (dish["allergy"] as List).length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final allergen = dish["allergy"][index];
                          return _buildAllergenItem(context, allergen);
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

  Widget _buildMacroNutrients(
    BuildContext context,
    Map<String, dynamic>? macros,
  ) {
    if (macros == null) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutritional Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              macros.entries.map((entry) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${entry.key}: ${entry.value}",
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
        ),
      ],
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
