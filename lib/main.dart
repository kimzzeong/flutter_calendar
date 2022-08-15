import 'package:flutter/material.dart';
import 'package:calendar_flutter/calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "체크리스트",
      home: Calendar(),
    );
  }
}