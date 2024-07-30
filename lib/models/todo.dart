import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String title;
  String note;
  int priority;
  DateTime dueDate;
  String category;
  List<String> tags;
  String? attachmentUrl;

  Todo({
    required this.id,
    required this.title,
    required this.note,
    required this.priority,
    required this.dueDate,
    required this.category,
    required this.tags,
    this.attachmentUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'category': category,
      'tags': tags,
      'attachmentUrl': attachmentUrl,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      priority: json['priority'],
      dueDate: DateTime.parse(json['dueDate']),
      category: json['category'],
      tags: List<String>.from(json['tags']),
      attachmentUrl: json['attachmentUrl'],
    );
  }
}
