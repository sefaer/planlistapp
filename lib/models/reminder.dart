import 'package:flutter/material.dart';

class Reminder {
  final String title;
  final String date;
  final String? time;
  final bool hasAttachment;
  final Color? color;

  Reminder({
    required this.title,
    required this.date,
    this.time,
    this.hasAttachment = false,
    this.color,
  });
}