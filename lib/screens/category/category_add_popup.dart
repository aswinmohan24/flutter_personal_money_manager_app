import 'package:flutter/material.dart';
import 'package:money_manager_flutter/Model/category/category_model.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> categoryAddShowPopup(BuildContext context) async {
  final nameEditingController = TextEditingController();

  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text(
            'Add Category',
            textAlign: TextAlign.center,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: nameEditingController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: ' Category Name'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RadioButton(title: 'Income', type: CategoryType.income),
                  RadioButton(title: 'Expense', type: CategoryType.expense),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        const MaterialStatePropertyAll(Colors.white)),
                onPressed: () {
                  final _name = nameEditingController.text;
                  if (_name.isEmpty) {
                    return;
                  }
                  final _type = selectedCategoryNotifier.value;
                  final _category = CategoryModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _name,
                      type: _type);
                  CategoryDB.instance.insertCategories(_category);
                  Navigator.of(ctx).pop();
                },
                child: const Text('Add'),
              ),
            )
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
                value: type,
                groupValue: newCategory,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategoryNotifier.value = value;
                  selectedCategoryNotifier.notifyListeners();
                });
          },
        ),
        Text(title),
      ],
    );
  }
}
