import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:planlistapp/controller/todo_controller.dart';
import 'package:planlistapp/models/todo.dart';
import 'package:planlistapp/screens/reminder/new_reminder_screen.dart';


class CustomSearchDelegate extends SearchDelegate {
  final TodoController controller;

  CustomSearchDelegate({required this.controller});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredTodos = controller.todos.where((todo) {
      return todo.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return ListView.builder(
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        Todo todo = filteredTodos[index];
        return ListTile(
          leading: Icon(
            todo.priority == 'high' ? Icons.circle : Icons.circle_outlined,
            color: todo.priority == 'high'
                ? Colors.red
                : todo.priority == 'medium'
                    ? Colors.orange
                    : Colors.blue,
          ),
          title: Text(todo.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.dueDate.toString(), 
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (todo.dueDate.hour != null)
                Text(
                  todo.dueDate.hour.toString() +
                      " : " +
                      todo.dueDate.minute.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
            ],
          ),
          trailing: Wrap(
            spacing: 12, 
            children: <Widget>[
              if (todo.attachmentUrl != null)
                Icon(Icons.attachment, color: Colors.grey),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.grey),
                onPressed: () {
                  controller.deleteTodo(todo.id);
                },
              ),
            ],
          ),
          onTap: () {
            Get.to(() => NewReminderScreen(todo: todo));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var filteredTodos = controller.todos.where((todo) {
      return todo.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return ListView.builder(
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        Todo todo = filteredTodos[index];
        return ListTile(
          leading: Icon(
            todo.priority == 'high' ? Icons.circle : Icons.circle_outlined,
            color: todo.priority == 'high'
                ? Colors.red
                : todo.priority == 'medium'
                    ? Colors.orange
                    : Colors.blue,
          ),
          title: Text(todo.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.dueDate.toString(), 
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (todo.dueDate.hour != null)
                Text(
                  todo.dueDate.hour.toString() +
                      " : " +
                      todo.dueDate.minute.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
            ],
          ),
          trailing: Wrap(
            spacing: 12, 
            children: <Widget>[
              if (todo.attachmentUrl != null)
                Icon(Icons.attachment, color: Colors.grey),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.grey),
                onPressed: () {
                  controller.deleteTodo(todo.id);
                },
              ),
            ],
          ),
          onTap: () {
            Get.to(() => NewReminderScreen(todo: todo));
          },
        );
      },
    );
  }
}
