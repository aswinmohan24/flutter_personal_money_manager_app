import 'package:flutter/material.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/screens/category/category_expense_list.dart';
import 'package:money_manager_flutter/screens/category/category_income_list.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.green,
          child: TabBar(
              //indicator: const BoxDecoration(color: Colors.green),
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(
                  text: 'INCOME',
                ),
                Tab(
                  text: 'EXPENSE',
                )
              ]),
        ),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: const [CategoryIncomeList(), CategoryExpenseList()]),
        )
      ],
    );
  }
}
