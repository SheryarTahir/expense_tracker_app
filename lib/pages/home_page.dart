import 'package:expense_tracker_app/components/expense_summary.dart';
import 'package:expense_tracker_app/components/expense_tile.dart';
import 'package:expense_tracker_app/data/expense_data.dart';
import 'package:expense_tracker_app/model/expense_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpensedollarController = TextEditingController();
  final newExpensecentsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new expense
  void addNewExpense() {
    showDialog(
      context: (context),
      builder: (context) => AlertDialog(
        title: const Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense Name",
              ),
            ),

            // expense amount
            Row(
              children: [
                // dollars
                Expanded(
                  child: TextField(
                    controller: newExpensedollarController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Dollars",
                    ),
                  ),
                ),
                // cents
                Expanded(
                  child: TextField(
                    controller: newExpensecentsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Cents",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // delete the expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // save
  void save() {
    // only save when all fields are filled
    if (newExpenseNameController.text.isNotEmpty &&
        newExpensedollarController.text.isNotEmpty &&
        newExpensecentsController.text.isNotEmpty) {
      // put dollars and cents together
      String amount =
          '${newExpensedollarController.text}.${newExpensecentsController.text}';

      // create expense item
      ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: amount,
          dateTime: DateTime.now());
      // add new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

// cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear controller
  void clear() {
    newExpenseNameController.clear();
    newExpensedollarController.clear();
    newExpensecentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: ListView(
            children: [
              // weekly summary
              ExpenseSummary(startOfWeek: value.startofWeekDay()),

              const SizedBox(
                height: 20,
              ),

              // expense list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped: (p0) =>
                      deleteExpense(value.getAllExpenseList()[index]),
                ),
              ),
            ],
          )),
    );
  }
}
