// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, unnecessary_new, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BusPage extends StatelessWidget {
  const BusPage({Key? key}) : super(key: key);

  Future<List<Buses>> getBuses() async {
    var data =
        await http.get(Uri.parse("https://musaabdata.herokuapp.com/api/buses"));
    var jsonData = json.decode(data.body);
    List<Buses> buses = [];
    for (var b in jsonData) {
      Buses bus = Buses(b['name'], b['latitude'], b['longitude']);
      for (var i = 0; i < b['stops'].length; i++) {
        bus.stops.add(b['stops'][i]);
      }
      buses.add(bus);
    }

    return buses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // ignore: prefer_const_constructors
        title: Text(
          'ULAŞIM',
          style: TextStyle(fontSize: 25),
        ),
        elevation: 10,
      ),
      body: Container(
        child: FutureBuilder(
          future: getBuses(),
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
            'ULAŞIM',
            style: TextStyle(fontSize: 25),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          elevation: 10,
        ),
        body: ListView(children: [
          Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                      '${bus.name}',
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Duraklar :  \n 1 - ${bus.stops[0]} \n 2 - ${bus.stops[1]}',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ))
        ]));
  }
}

class Buses {
  final String name;
  final String latitude;
  final String longitude;
  List<String> stops = [];
  Buses(this.name, this.latitude, this.longitude);
  //add array of stops
  void addStops(String stop) {
    stops.add(stop);
  }
}
