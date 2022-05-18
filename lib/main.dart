import 'package:flutter/material.dart';
import 'package:ulas/bus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ulaş',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: busPage(),
    );
  }
}

class mainPage extends StatelessWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ULAŞ'),
        elevation: 10,
      ),
    );
  }
}
