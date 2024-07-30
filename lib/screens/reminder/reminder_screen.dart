import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planlistapp/controller/todo_controller.dart';
import 'package:planlistapp/models/todo.dart';
import 'package:planlistapp/screens/reminder/new_reminder_screen.dart';
import 'package:planlistapp/screens/reminder/reminder_search.dart';

class ReminderScreen extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plantist',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(controller: controller),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                var filteredTodos = controller.todos.where((todo) {
                  return todo.title
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase());
                }).toList();
                return ListView.builder(
                  itemCount: filteredTodos.length,
                  itemBuilder: (context, index) {
                    Todo todo = filteredTodos[index];
                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            todo.priority == 1
                                ? Icons.circle
                                : Icons.circle_outlined,
                            color: todo.priority == 1
                                ? Colors.red
                                : todo.priority == 2
                                    ? Colors.orange
                                    : Colors.blue,
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 4),
                              Text(
                                todo.note,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month,
                                      size: 15,
                                      color: Colors.grey), // Updated icon
                                  SizedBox(width: 4),
                                  Text(
                                    todo.dueDate.year.toString() +
                                        "/" +
                                        todo.dueDate.month.toString() +
                                        "/" +
                                        todo.dueDate.day.toString(),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  SizedBox(width: 10),
                                  if (todo.dueDate != null)
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 15,
                                            color: Colors.red), // Updated icon
                                        SizedBox(
                                            width:
                                                4), // Add some spacing between icon and text
                                        Text(
                                          "${todo.dueDate!.hour.toString().padLeft(2, '0')} : ${todo.dueDate!.minute.toString().padLeft(2, '0')}",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.red),
                                        ),
                                      ],
                                    ),
                                ],
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
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.to(() => NewReminderScreen());
                },
                child: Text(
                  '+ New Reminder',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
