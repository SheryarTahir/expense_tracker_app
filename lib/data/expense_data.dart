import 'package:expense_tracker_app/data/hive_database.dart';
import 'package:expense_tracker_app/dateTime/date_time_helper.dart';
import 'package:flutter/material.dart';

import '../model/expense_items.dart';

class ExpenseData extends ChangeNotifier{

  // List of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data to display
  final db = HiveDataBase();
  void prepareData() {
    // if there exists data, get it
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }  
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // get weekday (mon, tue, etc) from a dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';

      default:
        return '';
    }
      
  }

  // get the date of the start of the week ( sunday )
  DateTime startofWeekDay() {
    DateTime? startofWeek;

    //get todays date
    DateTime today = DateTime.now();

    //go backwards from today to find sunday
    for (int i = 0; i < 7; i++){
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startofWeek = today.subtract(Duration(days: i));
      }
    }
  return startofWeek!;
  }

  /*

  convert overall list of expenses into a daily expense summary

  e.g.

  overallExpenseList =
  [

  [food , 2024/21/7, Rs10 ],
  [hat , 2024/21/7, Rs15 ],
  [drinks , 2024/21/7, Rs1 ],
  [food , 2024/1/7, Rs5 ],
  [food , 2024/3/7, Rs6 ],
  [food , 2024/4/7, Rs7 ],
  [food , 2024/5/7, Rs10 ],
  [food , 2024/5/7, Rs11 ],

  ->
  DailyExpenseSummary =

  [

  [ 2024/21/7: Rs25 ]
  [ 2024/30/7, Rs1 ],
  [ 2024/31/7, Rs11 ],
  [ 2024/3/7, Rs7 ],
  [ 2024/5/7, Rs21 ],

  ]

  ]

   */

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yymmdd) : amount Total for Day
    };
    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      
      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      }  else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}