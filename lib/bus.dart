import 'package:flutter/material.dart';

class busPage extends StatelessWidget {
  const busPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ULAŞ'),
        elevation: 10,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Colors.blue,
              child: SizedBox(height: 50),
            )
          ],
        ),
      ),
    );
  }
}
