import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense_item.dart';

class HiveDatabase {
  // Reference our box
  final _myBox = Hive.box("expense_database2");

  // Write data (save the data)
  void saveData(List<ExpenseItem> allExpense) {
    /*

    Hive can only store string and dateTime, and not custom objects like ExpenseItem.
    so let convert Expenseitem object into types that can be stored in our db

    allExpense
    [

      ExpenseItem( name / amount / datetime)
    ]
->
  [
    [ name, amount, datetime]
  ]


    */

    List<List<dynamic>> allExpenseFormated = [];

    for (var expense in allExpense) {
      // Convert each expense into a list of storable types (strings, dateTime)
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpenseFormated.add(expenseFormatted);
    }

    // finaly lets store in our database!
    _myBox.put("ALL_EXPENSES", allExpenseFormated);
  }

// Read data
  List<ExpenseItem> readData() {
    /*

  Data is stored in Hive as a list of String + datetime 
  so lets convert our saved data into ExpenseItem Object

  saveData = [

    [ name, amount, dateTime], the i is a perticular list
    ...
  ]

-> 
[

  Expense (name / amount / dateTime),
  ..
]
  */

    List savedExpenses =
        _myBox.get("ALL_EXPENSES") ?? []; // If its null return a empty list

    List<ExpenseItem> allExepenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // Collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // Create the expenseItem
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      // Add expense to overall list of expense
      allExepenses.add(expense);
    }
    return allExepenses;
  }
}
