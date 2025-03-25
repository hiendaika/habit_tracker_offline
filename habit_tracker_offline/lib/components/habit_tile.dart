import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? onPressedEdit;
  final void Function(BuildContext)? onPressedDelete;
  const HabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.onChanged,
    required this.onPressedEdit,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          //Edit option
          SlidableAction(
            onPressed: onPressedEdit,
            icon: Icons.edit,
            backgroundColor: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),

          // Delete option
          SlidableAction(
            onPressed: onPressedDelete,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) {
            // toggle completion status
            onChanged!(!isCompleted);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color:
                isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: ListTile(
            title: Text(
              text,
              style: TextStyle(
                color:
                    isCompleted
                        ? Colors.white
                        : Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            leading: Checkbox(
              value: isCompleted,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
