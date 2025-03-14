import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Dishs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[500]!),
      ),
      home: const DishScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DishScreen extends StatefulWidget {
  const DishScreen({super.key});

  @override
  State<DishScreen> createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen>
    with AutomaticKeepAliveClientMixin {
  final PageController _horizontalController = PageController(
    initialPage: 1,
    keepPage: true,
  );
  late PageController _verticalController;
  int _currentVerticalIndex = 0;
  int _currentHorizontalIndex = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _verticalController = PageController(
      initialPage: _currentVerticalIndex,
      keepPage: true,
    );

    _verticalController.addListener(() {
      debugPrint("Vertical Page: ${_verticalController.page}");
      if (_verticalController.page != null) {
        _currentVerticalIndex = _verticalController.page!.round();
      }
    });

    _horizontalController.addListener(() {
      if (_horizontalController.page != null) {
        _currentHorizontalIndex = _horizontalController.page!.round();
        if (_currentHorizontalIndex == 1) {
          if (_verticalController.page?.round() != _currentVerticalIndex) {
            _verticalController.jumpToPage(_currentVerticalIndex);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                color: Colors.white,
                child: Stack(children: [Center(child: Text("Sidebar"))]),
              ),
              KeepAliveWrapper(
                child: Stack(
                  children: [
                    PageView(
                      controller: _verticalController,
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        DishCard(index: 0, color: Colors.blue),
                        DishCard(index: 1, color: Colors.red),
                        DishCard(index: 2, color: Colors.green),
                        DishCard(index: 3, color: Colors.yellow),
                        DishCard(index: 4, color: Colors.purple),
                      ],
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: SafeArea(
                        child: IconButton.filled(
                          color: Colors.black,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            _horizontalController.animateToPage(
                              0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: Icon(Icons.menu),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              DraggableHome(
                appBarColor: Colors.blue,
                title: Text("Tandoori Chicken"),
                headerWidget: ColoredBox(color: Colors.blue),
                body: [Center(child: Text("Hello"))],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

class DishCard extends StatelessWidget {
  const DishCard({super.key, required this.index, required this.color});
  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: color),
          child: Center(
            child: Text(
              "Dish ${index + 1}",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Positioned(
          right: 16,
          top: 16,
          child: SafeArea(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  "40.3km away",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 32,
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tandoori Chicken".length >= 20
                        ? "${"Tandoori Chicken".substring(0, 20)}..."
                        : "Tandoori Chicken",
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Vishrut Aggarwal".length >= 20
                        ? "${"Vishrut Aggarwal".substring(0, 20)}..."
                        : "Vishrut Aggarwal",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
