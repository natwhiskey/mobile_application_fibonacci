import 'package:flutter/material.dart';
import '../controller/home_screen_controller.dart';

class MyHomeScreenPage extends StatefulWidget {
  const MyHomeScreenPage({super.key});

  @override
  State<MyHomeScreenPage> createState() => _MyHomeScreenPageState();
}

class _MyHomeScreenPageState extends State<MyHomeScreenPage> {
  MyHomeScreenController? controller;

  @override
  void initState() {
    super.initState();
    controller = MyHomeScreenController(context);
    controller?.addFibonacciList();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example')),
      body: AnimatedBuilder(
        animation: controller!,
        builder: (context, child) {
          return ListView.builder(
            controller: controller?.scrollController,
            itemCount: controller?.listFibonacci.length,
            itemBuilder: (context, index) {
              final fibonacciItem = controller?.listFibonacci[index];
              final symbol = fibonacciItem?.symbol;
              final icon = getIconFromSymbol(symbol ?? '');

              return InkWell(
                onTap: () {
                      controller?.addToBottomSheetList(index);
                      controller?.showBottomSheet(context, index, symbol);
                      controller?.removeFibonacci(index);
                    },
                child: ListTile(
                  tileColor:
                      controller?.highlightedIndex == index ? Colors.red : null,
                  title: Text(
                    'Index: ${fibonacciItem?.index}, Number: ${fibonacciItem?.number}',
                  ),
                  trailing: Icon(icon),
                ),
              );
            },
          );
        },
      ),
    );
  }
}