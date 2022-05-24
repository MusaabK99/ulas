import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ULAŞ',
            style: TextStyle(fontSize: 25),
          ),
          elevation: 10,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                "Home page",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ));
  }
}
