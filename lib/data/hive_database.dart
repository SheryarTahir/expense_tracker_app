import 'package:hive/hive.dart';
import '../model/expense_items.dart';

class HiveDataBase {
  // reference our box
  final _myBox = Hive.box("expense_database2");

  // write data
  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpenseFormatted = [];

    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpenseFormatted.add(expenseFormatted);
    }

    // finally store data in our database
    _myBox.put("All_Expenses", allExpenseFormatted);
  }

  // read data
  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get("All_Expenses") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // expense Item
      ExpenseItem expense =
          ExpenseItem(
              name: name,
              amount: amount,
              dateTime: dateTime
          );

      // add expenses to overall list of expenses
      allExpenses.add(expense);
    }

    return allExpenses;
  }
}
