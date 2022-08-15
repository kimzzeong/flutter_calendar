import 'package:flutter/foundation.dart';

class Event {
  final String title;
  bool ischecked;
  Event(
      {
        required this.title,
        required this.ischecked,
      }
      );

  @override
  String toString() => this.title;
}