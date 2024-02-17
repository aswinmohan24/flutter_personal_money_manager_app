import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager_flutter/Model/category/category_model.dart';
import 'package:money_manager_flutter/Model/transactions/transaction_model.dart';
import 'package:money_manager_flutter/screens/add_transactions/screen_add_transactions.dart';

import 'package:money_manager_flutter/screens/home/screen_splash.dart';

Future<void> main() async {
  // final obj1 = CategoryDB();
  // final obj2 = CategoryDB();
  // print(obj1 == obj2);

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.green));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.green),
      home: const SplashScreen(),
      routes: {
        ScreenAddTransactions.routeName: (ctx) => const ScreenAddTransactions()
      },
    );
  }
}
