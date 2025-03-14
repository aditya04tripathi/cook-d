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
      home: const DishsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DishsScreen extends StatefulWidget {
  const DishsScreen({super.key});

  @override
  State<DishsScreen> createState() => _DishsScreenState();
}

class _DishsScreenState extends State<DishsScreen>
    with AutomaticKeepAliveClientMixin {
  final PageController _horizontalController = PageController(
    initialPage: 1,
    keepPage: true,
  );
  late PageController _verticalController;
  int _currentVerticalIndex = 1;
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
              Center(
                child: Text(
                  "Sidebar",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              KeepAliveWrapper(
                child: PageView(
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
              ),
              Center(
                child: Text(
                  "Details",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
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
  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

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
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: Center(
        child: Text(
          "Dish $index",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
