import 'package:cook_d/screens/recipe_details.dart';
import 'package:cook_d/widgets/dish_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: HorizontalPagesWidget(
          child: PageView(
            scrollDirection: Axis.vertical,
            children: [DishCard(context), DishCard(context), DishCard(context)],
          ),
        ),
      ),
    );
  }
}

class HorizontalPagesWidget extends StatefulWidget {
  final Widget child;
  const HorizontalPagesWidget({Key? key, required this.child})
    : super(key: key);

  @override
  State<HorizontalPagesWidget> createState() => _HorizontalPagesWidgetState();
}

class _HorizontalPagesWidgetState extends State<HorizontalPagesWidget> {
  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageIndex.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) => _pageIndex.value = index,
      children: [
        widget.child,
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(children: [Expanded(child: RecipeDetailPage())]),
        ),
      ],
    );
  }
}
