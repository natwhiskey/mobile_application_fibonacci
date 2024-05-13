import 'package:flutter/material.dart';
import '../../models/fibonacci_model.dart';

class MyHomeScreenController extends ChangeNotifier {
  MyHomeScreenController(this.context);
  BuildContext context;

  int count = 41;
  List<Fibonacci> bottomSheetList = [];
  List<Fibonacci> listFibonacci = [];
  int? highlightedIndex;
  ScrollController scrollController = ScrollController();
  ScrollController bottomSheetScrollController = ScrollController();

  int fibonacci(int n) {
    if (n <= 1) return n;
    int a = 0, b = 1;
    for (int i = 2; i <= n; i++) {
      int temp = a + b;
      a = b;
      b = temp;
    }
    return b;
  }

  String getSymbol(int index) {
    switch (index % 8) {
      case 0:
      case 4:
        return 'Circle';
      case 1:
      case 2:
      case 7:
        return 'Square';
      case 3:
      case 5:
      case 6:
        return 'Close';
      default:
        return 'Circle';
    }
  }

  void addFibonacciList() {
    for (var i = 0; i < count; i++) {
      String symbol = getSymbol(i);
      listFibonacci.add(Fibonacci(
        index: i,
        number: fibonacci(i),
        symbol: symbol,
      ));
    }
    sortListFibonacci();
    notifyListeners();
  }

  void sortListFibonacci() {
    listFibonacci.sort((a, b) => a.number.compareTo(b.number));
  }

  void addToBottomSheetList(int index) {
    bottomSheetList.add(Fibonacci(
      index: listFibonacci[index].index,
      number: listFibonacci[index].number,
      symbol: listFibonacci[index].symbol,
    ));
    sortListFibonacci();
    notifyListeners();
  }

  void removeFibonacci(int index) {
    listFibonacci.removeAt(index);
    sortListFibonacci();
    notifyListeners();
  }

  void scrollToHighlightedIndex() {
    if (highlightedIndex != null && listFibonacci.length >= 7) {
      scrollController.animateTo(
        highlightedIndex! * 50.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void handleItemTap(Fibonacci tappedItem) {
    bottomSheetList.remove(tappedItem);
    listFibonacci.add(tappedItem);
    highlightedIndex = listFibonacci.length - 1;
    sortListFibonacci();
    notifyListeners();
    Navigator.pop(context, tappedItem);
  }

  void showBottomSheet(BuildContext context, int index, String? clickedSymbol) {
    List<Fibonacci> displayList =
        bottomSheetList.where((item) => item.symbol == clickedSymbol).toList();
    displayList.sort((a, b) => a.index.compareTo(b.index));

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              int latestItemIndex = displayList.indexOf(bottomSheetList.last);
              double itemHeight = 50.0; 
              double viewHeight = MediaQuery.of(context).size.height * 0.5; 
              double spaceHightLight =  100.0; 

              if (latestItemIndex * itemHeight > viewHeight - spaceHightLight) {
                double scrollOffset =(latestItemIndex - (viewHeight ~/ itemHeight) + 2) * itemHeight;
                bottomSheetScrollController.animateTo(
                  scrollOffset,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            });

            return ListView.builder(
              controller: bottomSheetScrollController,
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                IconData iconData =
                    getIconFromSymbol(displayList[index].symbol);
                bool isLatestValue = displayList[index] == bottomSheetList.last;

                return ListTile(
                  tileColor: isLatestValue ? Colors.green : null,
                  title: Text(
                    'Index: ${displayList[index].index}, Number: ${displayList[index].number}',
                  ),
                  trailing: Icon(iconData),
                  onTap: () => handleItemTap(displayList[index]),
                );
              },
            );
          },
        );
      },
    ).then((tappedItem) {
      if (tappedItem != null) {
        int addedIndex = listFibonacci.indexOf(tappedItem);
        if (addedIndex != -1) {
          highlightedIndex = addedIndex;
          notifyListeners();
          scrollToHighlightedIndex();
        }
      }
    });
  }
}

IconData getIconFromSymbol(String symbol) {
  switch (symbol) {
    case 'Circle':
      return Icons.circle;
    case 'Square':
      return Icons.square_outlined;
    case 'Close':
      return Icons.close;
    default:
      return Icons.circle;
  }
}