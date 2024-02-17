import 'package:flutter/material.dart';
import 'package:money_manager_flutter/screens/add_transactions/screen_add_transactions.dart';
import 'package:money_manager_flutter/screens/category/category_add_popup.dart';
import 'package:money_manager_flutter/screens/category/screen_category.dart';
import 'package:money_manager_flutter/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager_flutter/screens/transactions/screen_transactions.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});

  final _pages = [const ScreenTransactions(), const ScreenCategory()];

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: const Text(
          'Money Manager',
          strutStyle: StrutStyle(fontSize: 40),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (BuildContext context, int updatedIndex, _) {
                return _pages[updatedIndex];
              })),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(ScreenAddTransactions.routeName);
          } else {
            categoryAddShowPopup(context);
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
