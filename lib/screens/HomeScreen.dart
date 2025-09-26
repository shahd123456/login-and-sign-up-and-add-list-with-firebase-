import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro4/main.dart';
import 'package:pro4/TaskModel.dart';
import 'package:pro4/wights/TaskItem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  @override
  void initState() {
    appbrain.gettask();
    super.initState();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final task = TaskModel(
                id: "",
                title: _titleController.text,
                description: _subtitleController.text,
                isfinsh: false,
              );
              appbrain.addtask(task);

              _titleController.clear();
              _subtitleController.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Delete All Tasks"),
          content: const Text("Are you sure you want to delete all tasks?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await appbrain.deleteAllTasks(user.uid);
                }
                Navigator.pop(context);
              },
              child: const Text("Delete All"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        shape: const CircleBorder(),
        elevation: 1,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 30),
      ),
      appBar: AppBar(
        title: const Text("Todo Screen", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _showDeleteAllDialog,
          ),
        ],
      ),
      body: ValueListenableBuilder<List<TaskModel>>(
        valueListenable: appbrain.tasks,
        builder: (context, taskList, child) {
          if (taskList.isEmpty) {
            return const Center(child: Text("No tasks yet"));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              return TaskItem(
                model: taskList[index],
                onDelete: () => appbrain.delettask(index),
                onToggle: () => appbrain.comp(index),
              );
            },
          );
        },
      ),
    );
  }
}
