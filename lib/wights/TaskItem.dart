import 'package:flutter/material.dart';
import 'package:pro4/TaskModel.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.model,
    this.onDelete,
    this.onToggle,
  });

  final TaskModel model;
  final VoidCallback? onDelete;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: onToggle, //
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: model.isfinsh ? Colors.deepPurple : null,
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: model.isfinsh
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        ),
        title: Text(
          model.title,
          style: TextStyle(
            decoration: model.isfinsh ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(model.description),
        trailing: IconButton(
          icon: const Icon(Icons.remove, color: Colors.red),
          onPressed: onDelete,
          //
        ),
      ),

    );

  }
}
