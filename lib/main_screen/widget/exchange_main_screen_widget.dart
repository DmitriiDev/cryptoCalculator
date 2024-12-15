import 'package:cryptocalc/main_screen/widget/exchange_list_widget.dart';
import 'package:flutter/material.dart';

class ExchangFullScreenWidget extends StatefulWidget {
  const ExchangFullScreenWidget({super.key});

  @override
  ExchangFullScreenWidgetState createState() => ExchangFullScreenWidgetState();
}

class ExchangFullScreenWidgetState extends State<ExchangFullScreenWidget>
    with SingleTickerProviderStateMixin {
  late void Function(BuildContext context) showFullWidthMenu;

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagesTitle = ["Watch", "Convert"];

    final List<Widget> pages = [
      ExchaneListWidget(
        isConvertor: false,
        navigateToCurrencyListCallback: (callback) {
          showFullWidthMenu = callback;
        },
      ),
      ExchaneListWidget(
        isConvertor: true,
        navigateToCurrencyListCallback: (callback) {
          showFullWidthMenu = callback;
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pagesTitle[_currentIndex]),
      ),
      body: pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFullWidthMenu(context);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: pagesTitle.first,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.currency_exchange),
            label: pagesTitle.last,
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: onTabTapped,
      ),
    );
  }
}
