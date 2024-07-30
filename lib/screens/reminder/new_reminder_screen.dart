import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planlistapp/controller/todo_controller.dart';
import 'package:planlistapp/models/todo.dart';

class NewReminderScreen extends StatelessWidget {
  final TodoController controller = Get.find();
  final Todo? todo;

  NewReminderScreen({this.todo});

  final titleController = TextEditingController();
  final noteController = TextEditingController();
  final priorityController = TextEditingController();
  final categoryController = TextEditingController();
  final tagsController = TextEditingController();
  final dueDateController = TextEditingController();
  DateTime? dueDate;

  bool get _areFieldsFilled {
    return titleController.text.isNotEmpty &&
        priorityController.text.isNotEmpty &&
        categoryController.text.isNotEmpty &&
        tagsController.text.isNotEmpty &&
        dueDateController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (todo != null) {
      titleController.text = todo!.title;
      noteController.text = todo!.note ?? '';
      priorityController.text = todo!.priority.toString();
      categoryController.text = todo!.category;
      tagsController.text = todo!.tags.join(', ');
      dueDate = todo!.dueDate;
      dueDateController.text =
          todo!.dueDate.toLocal().toString(); // tarih ve zaman göster
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(todo == null ? 'New TODO' : 'Edit TODO'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: noteController,
                decoration: InputDecoration(labelText: 'Note'),
              ),
              TextField(
                controller: priorityController,
                decoration: InputDecoration(labelText: 'Priority'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: tagsController,
                decoration:
                    InputDecoration(labelText: 'Tags (comma separated)'),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  DateTime initialDate = dueDate ?? DateTime.now();

                  // Show date picker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null && pickedDate != initialDate) {
                    // Show time picker
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(initialDate),
                    );

                    if (pickedTime != null) {
                    
                      DateTime combinedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      dueDate = combinedDateTime;
                      String formattedDateTime =
                          combinedDateTime.toIso8601String();
                      dueDateController.text =
                          formattedDateTime; 
                    }
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: dueDateController,
                    decoration: InputDecoration(
                      labelText: 'Due Date (YYYY-MM-DD HH:MM)',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (todo?.attachmentUrl != null && _areFieldsFilled)
                Image.network(todo!
                    .attachmentUrl!), 

              if (_areFieldsFilled)
                ElevatedButton(
                  onPressed: () {
                    if (todo != null) {
                      controller.pickAndUploadImage(todo!);
                    } else {
                     
                    }
                  },
                  child: Text('Add Attachment'),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    print('Button pressed'); // Button press kontrolü
                    if (todo == null) {
                      
                      await controller.addTodo(Todo(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        note: noteController.text,
                        priority: int.parse(priorityController.text),
                        dueDate: dueDate ?? DateTime.now(),
                        category: categoryController.text,
                        tags: tagsController.text.split(', '),
                      ));
                    } else {
                      // Update existing TODO
                      await controller.updateTodo(Todo(
                        id: todo!.id,
                        title: titleController.text,
                        note: noteController.text,
                        priority: int.parse(priorityController.text),
                        dueDate: dueDate ?? DateTime.now(),
                        category: categoryController.text,
                        tags: tagsController.text.split(', '),
                      ));
                    }
                    Get.offAllNamed('/reminder');
                  } catch (e) {
                    print('Error: $e');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred: $e')),
                    );
                  }
                },
                child: Text(todo == null ? 'Add TODO' : 'Update TODO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
