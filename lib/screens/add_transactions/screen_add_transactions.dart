import 'package:flutter/material.dart';
import 'package:money_manager_flutter/Model/category/category_model.dart';
import 'package:money_manager_flutter/Model/transactions/transaction_model.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/db/transaction/transaction_db.dart';

class ScreenAddTransactions extends StatefulWidget {
  const ScreenAddTransactions({super.key});

  static const routeName = 'add-transactions';

  @override
  State<ScreenAddTransactions> createState() => _ScreenAddTransactionsState();
}

class _ScreenAddTransactionsState extends State<ScreenAddTransactions> {
  DateTime? _selectDate;
  CategoryType? _selectCategoryType;

  CategoryModel? _selectCategoryModel;
  String? _categoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _selectCategoryType = CategoryType.income;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text(
              'Add Transactions',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter purpose';
                        } else {
                          return null;
                        }
                      },
                      controller: _purposeTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: 'Enter Purpose',
                        labelText: 'Purpose',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Amount';
                        }
                        return null;
                      },
                      controller: _amountTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        hintText: ' Enter Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextButton.icon(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.green)),
                      onPressed: () async {
                        final selectedDateTemp = await showDatePicker(
                          context: context,
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now(),
                        );

                        if (selectedDateTemp == null) {
                          return;
                        } else {
                          setState(() {
                            _selectDate = selectedDateTemp;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: Text(_selectDate == null
                          ? 'Select Date'
                          : _selectDate.toString()),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Radio(
                                value: CategoryType.income,
                                groupValue: _selectCategoryType,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectCategoryType = CategoryType.income;
                                    _categoryID = null;
                                  });
                                }),
                            const Text('Income')
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                                value: CategoryType.expense,
                                groupValue: _selectCategoryType,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectCategoryType = CategoryType.expense;
                                    _categoryID = null;
                                  });
                                }),
                            const Text('Expense')
                          ],
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                        value: _categoryID,
                        hint: const Text('Select Category'),
                        items: (_selectCategoryType == CategoryType.income
                                ? CategoryDB().incomeCategoryListNotifier
                                : CategoryDB().expenseCategoryListNotifier)
                            .value
                            .map((e) {
                          return DropdownMenuItem(
                              onTap: () {
                                _selectCategoryModel = e;
                              },
                              value: e.id,
                              child: Text(e.name));
                        }).toList(),
                        onChanged: (selectedCategory) {
                          setState(() {
                            _categoryID = selectedCategory;
                          });
                        }),
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_selectDate == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(),
                              content: Text(
                                'Please Choose Date',
                                style: TextStyle(color: Colors.black),
                              ),
                              // behavior: SnackBarBehavior.floating,
                            ));
                          } else if (_categoryID == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(),
                              content: Text(
                                'Please Choose Category',
                                style: TextStyle(color: Colors.black),
                              ),
                              // behavior: SnackBarBehavior.floating,
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(),
                              content: Text(
                                'Transaction Added Successfully',
                                style: TextStyle(color: Colors.black),
                              ),
                              // behavior: SnackBarBehavior.floating,
                            ));
                          }
                        }
                        addTransactions();
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Future<void> addTransactions() async {
    final purposeText = _purposeTextEditingController.text;
    final amountText = _amountTextEditingController.text;
    if (purposeText.isEmpty) {
      return;
    }
    if (amountText.isEmpty) {
      return;
    }
    if (_selectDate == null) {
      return;
    }

    final parsedAmount = double.tryParse(amountText);
    if (parsedAmount == null) {
      return;
    }
    if (_selectCategoryModel == null) {
      return;
    }

    final _model = TransactionModel(
        purpose: purposeText,
        amount: parsedAmount,
        date: _selectDate!,
        type: _selectCategoryType!,
        category: _selectCategoryModel!);
    TransactionDb.instance.addTransaction(_model);
    TransactionDb.instance.refresh();

    Navigator.of(context).pop();

    // Navigator.of(context).pop();
  }
}
