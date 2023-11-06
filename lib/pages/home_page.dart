import 'package:expense_tracker/bar%20graph/my_bar_graph.dart';
import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:expense_tracker/util/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // Save and Cancel Buttons
  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseDollerController.text.isNotEmpty) {
      setState(() {
        // Put the Doller & Cents togther
        String amount =
            '${newExpenseDollerController.text}.${newExpenseCentsController.text}';

        // Create expense item
        ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: amount,
          dateTime: DateTime.now(),
        );
        // add the new expense
        Provider.of<ExpenseData>(context, listen: false)
            .addNewExpense(newExpense);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unabel to add expense!',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    Navigator.pop(context);
    clear();
  }

// Cancel button
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // Delete Button
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // To clear the textField
  void clear() {
    newExpenseNameController.clear();
    newExpenseDollerController.clear();
    newExpenseCentsController.clear();
  }

  // 2 Text Controller
  final newExpenseNameController = TextEditingController();
  final newExpenseDollerController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  // Add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        onExpenseNameController: newExpenseNameController,
        onExpenseDollerController: newExpenseDollerController,
        onExpenseCentsController: newExpenseCentsController,
        onSave: save,
        onCancel: cancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            // Weekly Summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            //
            const SizedBox(
              height: 20,
            ),

            // Expense List
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
        ),
      ),
    );
  }
}
