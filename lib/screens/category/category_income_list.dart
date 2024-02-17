import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Model/category/category_model.dart';
import '../../db/category/category_db.dart';

class CategoryIncomeList extends StatelessWidget {
  const CategoryIncomeList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().incomeCategoryListNotifier,
        builder: (
          BuildContext context,
          List<CategoryModel> newList,
          Widget? _,
        ) {
          return AnimationLimiter(
            child: ListView.separated(
                itemBuilder: (ctx, index) {
                  final category = newList[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 200),
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          margin: const EdgeInsetsDirectional.symmetric(
                              vertical: .5),
                          elevation: 3,
                          child: ListTile(
                              title: Text(category.name),
                              trailing: IconButton(
                                  onPressed: () {
                                    CategoryDB.instance
                                        .deleteCategory(category.id);
                                  },
                                  icon: const Icon(Icons.delete))),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 2,
                  );
                },
                itemCount: newList.length),
          );
        });
  }
}
