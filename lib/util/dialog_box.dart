import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final onExpenseNameController;
  final onExpenseDollerController;
  final onExpenseCentsController;

  // method for buttons
  VoidCallback onSave;
  VoidCallback onCancel;
  DialogBox(
      {super.key,
      required this.onExpenseNameController,
      required this.onExpenseDollerController,
      required this.onExpenseCentsController,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Expense name
          TextField(
            controller: onExpenseNameController,
            decoration: const InputDecoration(hintText: "Expense name"),
          ),

          // Expense amount
          Row(
            children: [
              // dollers
              Expanded(
                child: TextField(
                  controller: onExpenseDollerController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Dollers"),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              //cents
              Expanded(
                child: TextField(
                  controller: onExpenseCentsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Cents"),
                ),
              ),
            ],
          )
        ],
      ),
      actions: [
        // Save button
        MaterialButton(
          onPressed: onSave,
          child: Text('Save'),
        ),

        // Cancel buton
        MaterialButton(
          onPressed: onCancel,
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
