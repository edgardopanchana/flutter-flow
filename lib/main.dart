import 'package:flutter/material.dart';

const double sizeButton = 100;

void main() => runApp(FlowApp());

class FlowApp extends StatefulWidget {
  FlowApp({Key? key}) : super(key: key);

  @override
  State<FlowApp> createState() => _FlowAppState();
}

class _FlowAppState extends State<FlowApp> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flow Example'),
        ),
        body: Flow(
          delegate: FlowItemDelegate(controller: controller),
          children: <IconData>[
            Icons.house,
            Icons.person,
            Icons.pets,
          ].map<Widget>(iconItem).toList(),
        ),
      ),
    );
  }

  Widget iconItem(IconData icon) => SizedBox(
        width: sizeButton,
        height: sizeButton,
        child: FloatingActionButton(
            elevation: 0,
            splashColor: Colors.grey,
            child: Icon(
              icon,
              color: Colors.white,
              size: 45,
            ),
            onPressed: () {
              if (controller.status == AnimationStatus.completed) {
                controller.reverse();
              } else {
                controller.forward();
              }
            }),
      );
}

class FlowItemDelegate extends FlowDelegate {
  final Animation<double> controller;
  const FlowItemDelegate({required this.controller})
      : super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    const xStart = 10.0;
    const yStart = 10.0;

    for (var i = context.childCount - 1; i >= 0; i--) {
      final sizeChild = context.getChildSize(i)!.width;
      final dx = sizeChild * i;
      const x = xStart;
      final y = yStart + dx * controller.value;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(x, y, 0),
      );
    }
  }

  @override
  bool shouldRepaint(FlowItemDelegate oldDelegate) => false;
}
