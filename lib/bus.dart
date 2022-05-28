import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BusPage extends StatelessWidget {
  const BusPage({Key? key}) : super(key: key);

  Future<List<Buses>> _getBuses() async {
    var data =
        await http.get(Uri.parse("https://musaabdata.herokuapp.com/api/buses"));
    var jsonData = json.decode(data.body);
    List<Buses> buses = [];
    for (var b in jsonData) {
      Buses bus = Buses(
          b['name'], b['speed'], b['latitude'], b['longitude'], b['timestamp']);
      buses.add(bus);
    }
    return buses;
  }

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
      body: Container(
        child: FutureBuilder(
          future: _getBuses(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.directions_bus),
                    title: Text(snapshot.data[index].name),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(snapshot.data[index])));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Buses bus;
  DetailsPage(this.bus);

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
      body: Container(
        child: Center(
          child: Text(
            '${bus.name}',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}

class Buses {
  final String name;
  final String latitude;
  final String longitude;
  final String speed;
  final String timestamp;

  Buses(this.name, this.latitude, this.longitude, this.speed, this.timestamp);
}
