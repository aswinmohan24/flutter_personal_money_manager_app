import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager_flutter/Model/transactions/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transactions-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getTransactions();
  Future<void> deleteTransactions(String transactionsID);
}

class TransactionDb extends ChangeNotifier implements TransactionDbFunctions {
  TransactionDb._internal();
  static TransactionDb instance = TransactionDb._internal();

  factory TransactionDb() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionModelNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    final _allTransactions = await getTransactions();
    _allTransactions.sort((first, second) => second.date.compareTo(first.date));
    transactionModelNotifier.value.clear();
    transactionModelNotifier.value.addAll(_allTransactions);
    transactionModelNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransactions(String transactionsID) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(transactionsID);
    refresh();
  }
}
