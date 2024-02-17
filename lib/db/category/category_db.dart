import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager_flutter/Model/category/category_model.dart';

const CATEGORY_DB_NAME = 'category_base';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategories(CategoryModel values);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDB extends ChangeNotifier implements CategoryDbFunctions {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryListNotifier =
      ValueNotifier([]);

  ValueNotifier<List<CategoryModel>> expenseCategoryListNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertCategories(CategoryModel value) async {
    try {
      final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
      await _categoryDB.put(value.id, value);
      refreshUI();
    } catch (e) {
      print('Error inserting category: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final allCategories = await getCategories();
    incomeCategoryListNotifier.value.clear();
    expenseCategoryListNotifier.value.clear();
    Future.forEach(allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryListNotifier.value.add(category);
      } else {
        expenseCategoryListNotifier.value.add(category);
      }
    });
    incomeCategoryListNotifier.notifyListeners();
    expenseCategoryListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryID);
    refreshUI();
  }
}
