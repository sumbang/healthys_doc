import 'package:flutter/material.dart';
import 'package:healthys_medecin/lock/my_homepage.dart';

class MyApp extends StatelessWidget {
  final String data;

  const MyApp({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healht\'hys',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Healht\'hys Doc Apps'),
    );
  }
}