import 'package:flutter/material.dart';
import 'package:money_manager_flutter/Model/category/category_model.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';

class CategoryExpenseList extends StatelessWidget {
  const CategoryExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().expenseCategoryListNotifier,
        builder: (
          BuildContext context,
          List<CategoryModel> newList,
          Widget? _,
        ) {
          return ListView.separated(
              itemBuilder: (ctx, index) {
                final category = newList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: const EdgeInsetsDirectional.symmetric(vertical: .5),
                    elevation: 3,
                    child: ListTile(
                        title: Text(category.name),
                        trailing: IconButton(
                            onPressed: () {
                              CategoryDB.instance.deleteCategory(category.id);
                            },
                            icon: const Icon(Icons.delete))),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 1,
                );
              },
              itemCount: newList.length);
        });
  }
}
