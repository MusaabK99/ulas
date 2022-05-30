import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'bus.dart';
import 'station.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ULAŞIM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int selectedPage = 1;
  final _pageOption = [BusPage(), HomePage(), StationPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOption[selectedPage],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.textIn,
        items: [
          TabItem(icon: Icons.directions_bus, title: 'Bus'),
          TabItem(icon: Icons.place, title: 'location'),
          TabItem(
              icon: Text(
                "D",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
                textAlign: TextAlign.center,
              ),
              title: 'Station'),
        ],
        backgroundColor: Colors.red,
        initialActiveIndex: selectedPage,
        onTap: (int index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}
