import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_d/screens/recipe_details.dart';
import 'package:cook_d/screens/profile_page.dart';
import 'package:cook_d/widgets/dish_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_rounded),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Text(
          'Cook\'d',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: () async {
              Get.to(() => ProfilePage());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection("dishes").get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final dishes = snapshot.data as QuerySnapshot;
              if (dishes.docs.isNotEmpty) {
                return HorizontalPagesWidget(dishes: dishes);
              }
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class _buildListTileWidget extends StatelessWidget {
  const _buildListTileWidget({
    required this.title,
    required this.onTap,
    required this.icon,
  });

  final String title;
  final Function onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(64),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          color: Theme.of(context).colorScheme.primary.withAlpha(192),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalPagesWidget extends StatefulWidget {
  final QuerySnapshot dishes;
  const HorizontalPagesWidget({Key? key, required this.dishes})
    : super(key: key);

  @override
  State<HorizontalPagesWidget> createState() => _HorizontalPagesWidgetState();
}

class _HorizontalPagesWidgetState extends State<HorizontalPagesWidget> {
  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);
  final PageController _pageController = PageController(initialPage: 0);
  final ValueNotifier<int> _dishIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageIndex.dispose();
    _pageController.dispose();
    _dishIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) => _pageIndex.value = index,
      children: [
        // First page - Dish cards
        PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.dishes.docs.length,
          itemBuilder: (context, index) {
            final dish = widget.dishes.docs[index];
            _dishIndex.value = index; // Update current dish index
            return DishCard(context, data: dish);
          },
          onPageChanged: (index) {
            _dishIndex.value = index;
          },
        ),
        // Second page - Recipe details
        ValueListenableBuilder<int>(
          valueListenable: _dishIndex,
          builder: (context, index, _) {
            final dish = widget.dishes.docs[index];
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [Expanded(child: RecipeDetailPage(dish: dish))],
              ),
            );
          },
        ),
      ],
    );
  }
}
