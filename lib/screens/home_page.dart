import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_d/screens/add_screen.dart';
import 'package:cook_d/screens/recipe_details.dart';
import 'package:cook_d/screens/profile_page.dart';
import 'package:cook_d/widgets/dish_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';

// Global index controller to share state
class IndexController {
  static final IndexController _instance = IndexController._internal();

  factory IndexController() => _instance;

  IndexController._internal();

  int currentDishIndex = 0;
  int currentPageIndex = 0;

  final ValueNotifier<int> dishIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);

  void updateDishIndex(int index) {
    currentDishIndex = index;
    dishIndexNotifier.value = index;
  }

  void updatePageIndex(int index) {
    currentPageIndex = index;
    pageIndexNotifier.value = index;
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final indexController = IndexController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.primary,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddScreen());
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Icon(Icons.add_rounded),
      ),
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

class HorizontalPagesWidget extends StatefulWidget {
  final QuerySnapshot dishes;
  const HorizontalPagesWidget({super.key, required this.dishes});

  @override
  State<HorizontalPagesWidget> createState() => _HorizontalPagesWidgetState();
}

class _HorizontalPagesWidgetState extends State<HorizontalPagesWidget> {
  late PageController _pageController;
  late PageController _verticalController;
  final indexController = IndexController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: indexController.currentPageIndex,
    );
    _verticalController = PageController(
      initialPage: indexController.currentDishIndex,
    );

    // Listen for changes in page index
    indexController.pageIndexNotifier.addListener(() {
      if (_pageController.page?.round() != indexController.currentPageIndex) {
        _pageController.animateToPage(
          indexController.currentPageIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    // Listen for changes in dish index
    indexController.dishIndexNotifier.addListener(() {
      if (_verticalController.page?.round() !=
          indexController.currentDishIndex) {
        _verticalController.animateToPage(
          indexController.currentDishIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) {
        indexController.updatePageIndex(index);
      },
      children: [
        PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.dishes.docs.length,
          controller: _verticalController,
          itemBuilder: (context, index) {
            final dish = widget.dishes.docs[index];
            return DishCard(context, data: dish);
          },
          onPageChanged: (index) {
            indexController.updateDishIndex(index);
          },
        ),
        ValueListenableBuilder<int>(
          valueListenable: indexController.dishIndexNotifier,
          builder: (context, currentIndex, _) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  Expanded(
                    child: RecipeDetailPage(
                      dish: widget.dishes.docs[currentIndex],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
