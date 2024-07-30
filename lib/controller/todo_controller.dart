import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planlistapp/controller/notification_controller.dart';
import 'package:planlistapp/models/todo.dart';
import 'dart:io';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;
  final NotificationController notificationController =
      NotificationController();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  void fetchTodos() {
    FirebaseFirestore.instance.collection('todos').snapshots().listen(
      (QuerySnapshot query) {
        List<Todo> newTodos = [];
        query.docs.forEach((element) {
          try {
            newTodos.add(Todo.fromJson(element.data() as Map<String, dynamic>));
          } catch (e) {
            print('Error parsing document ${element.id}: $e');
          }
        });
        todos.value = newTodos;
      },
      onError: (error) {
        print('Error getting todos: ${error.toString()}');
        Get.snackbar("Error", "Failed to fetch todos. ${error.toString()}",
            snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
      },
    );
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(todo.id)
          .set(todo.toJson())
          .then((_) {
        Get.snackbar("Success", "Todo added.",
            snackPosition: SnackPosition.BOTTOM, colorText: Colors.green);
      });
      notificationController.scheduleNotification(todo);
    } catch (e) {
      print("Error adding todo: $e");
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('todos')
          .doc(todo.id)
          .get();

      if (doc.exists) {
        await FirebaseFirestore.instance
            .collection('todos')
            .doc(todo.id)
            .update(todo.toJson())
            .then((_) {
          Get.snackbar("Success", "Todo updated.",
              snackPosition: SnackPosition.BOTTOM, colorText: Colors.green);
        });
      } else {
        Get.snackbar("Error", "Todo not found.",
            snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
      }
    } catch (e) {
      print("Error updating todo: $e");
      Get.snackbar("Error", "Failed to update todo.",
          snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('Todo ID is missing');
      }
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(id)
          .delete()
          .then((_) {
        Get.snackbar("Success", "Todo deleted.",
            snackPosition: SnackPosition.BOTTOM, colorText: Colors.green);
        fetchTodos();
      });
    } catch (e, stacktrace) {
      print("Error deleting todo: $e");
      print("Stacktrace: $stacktrace");
      Get.snackbar("Error", "Failed to delete todo. ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
    }
  }

  Future<void> pickAndUploadImage(Todo todo) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = 'attachments/${todo.id}/${pickedFile.name}';
      try {
        await _storage.ref(fileName).putFile(file);
        String downloadURL = await _storage.ref(fileName).getDownloadURL();

        todo.attachmentUrl = downloadURL;

        await updateTodo(todo);
      } catch (e) {
        print("Error uploading image: $e");
        Get.snackbar("Error", "Failed to upload image.",
            snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
      }
    }
  }
  // void updateTodoAttachment(String id, String attachmentUrl) {
  //   int index = todos.indexWhere((todo) => todo.id == id);
  //   if (index != -1) {
  //     todos[index].attachmentUrl = attachmentUrl;
  //     todos.refresh();
  //   }
  // }
}
