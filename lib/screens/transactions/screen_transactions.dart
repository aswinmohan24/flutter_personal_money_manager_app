import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_flutter/Model/category/category_model.dart';
import 'package:money_manager_flutter/Model/transactions/transaction_model.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/db/transaction/transaction_db.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refresh();
    CategoryDB.instance.refreshUI();

    return ValueListenableBuilder(
      valueListenable: TransactionDb().transactionModelNotifier,
      builder: (BuildContext context, List<TransactionModel> trasactionList,
          Widget? _) {
        return AnimationLimiter(
          child: ListView.separated(
              padding: const EdgeInsets.all(5.0),
              itemBuilder: (ctx, index) {
                final newList = trasactionList[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 200),
                  child: FadeInAnimation(
                    child: Slidable(
                      key: Key(newList.id!),
                      startActionPane:
                          ActionPane(motion: const DrawerMotion(), children: [
                        SlidableAction(
                          onPressed: (ctx) {
                            TransactionDb.instance
                                .deleteTransactions(newList.id!);
                          },
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        // SlidableAction(
                        //   onPressed: (ctx) {},
                        //   label: 'Update',
                        //   icon: Icons.update,
                        // )
                      ]),
                      child: Card(
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: newList.type == CategoryType.income
                                ? Colors.green
                                : Colors.red,
                            radius: 30,
                            child: Text(
                              parseDate(newList.date),
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // trailing: IconButton(
                          //     onPressed: () {
                          //       TransactionDb.instance
                          //           .deleteTransactions(newList.id!);
                          //     },
                          //     icon: const Icon(Icons.delete_rounded)),
                          title: Text('RS ${newList.amount}'),
                          subtitle: Text(
                              '${newList.purpose}\nCategory: ${newList.category.name}'),
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 8,
                );
              },
              itemCount: trasactionList.length),
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final splittedDate = _date.split(' ');
    return '${splittedDate.last} \n ${splittedDate.first}';

    // return '${date.day}\n ${date.month}';
  }
}
