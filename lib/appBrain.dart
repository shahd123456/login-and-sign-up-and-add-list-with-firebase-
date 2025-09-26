import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro4/TaskModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppBrain {
  final ValueNotifier<List<TaskModel>> tasks = ValueNotifier([]);

  final userId = FirebaseAuth.instance.currentUser!.uid;
  late final CollectionReference<Map<String, dynamic>> tasksRef;

  AppBrain() {
    tasksRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("tasks");

    _loadTasks();
  }


  Future<void> _loadTasks() async {
    final snapshot = await tasksRef.get();
    final list = snapshot.docs.map((doc) {
      return TaskModel(
        id: doc.id,
        title: doc["title"],
        description: doc["description"],
        isfinsh: doc["isfinsh"],
      );
    }).toList();

    tasks.value = list;
  }

  Future<void> addtask(TaskModel task) async {
    final docRef = await tasksRef.add({
      "title": task.title,
      "description": task.description,
      "isfinsh": task.isfinsh,
    });

    tasks.value = [
      ...tasks.value,
      TaskModel(
        id: docRef.id,
        title: task.title,
        description: task.description,
        isfinsh: task.isfinsh,
      )
    ];
  }

  Future<void> delettask(int index) async {
    final task = tasks.value[index];
    await tasksRef.doc(task.id).delete();

    final newlist = List<TaskModel>.from(tasks.value)..removeAt(index);
    tasks.value = newlist;
  }

  Future<void> deleteAllTasks(String userId) async {
    final tasksRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("tasks");

    final snapshot = await tasksRef.get();
    for (var doc in snapshot.docs) {
      await tasksRef.doc(doc.id).delete();
    }

    tasks.value = [];
  }



  Future<void> comp(int index) async {
    final task = tasks.value[index];
    final updated = !task.isfinsh;

    await tasksRef.doc(task.id).update({"isfinsh": updated});

    final newlist = List<TaskModel>.from(tasks.value);
    newlist[index].isfinsh = updated;
    tasks.value = newlist;
  }

  void gettask() async {
    final snapshot = await FirebaseFirestore.instance.collection("user").doc(
        userId).collection("tasks").get();
    final fetchedTasks = snapshot.docs.map((document) {
      final data = document.data();
      return TaskModel(
          id: data["id"],
          title: data["title"],
          description: data["description"],
          isfinsh: data["isfinsh"]
      );
    }
    ).toList();


    tasks.value = fetchedTasks;
  }
}
