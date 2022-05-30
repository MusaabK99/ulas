import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class StationPage extends StatelessWidget {
  const StationPage({Key? key}) : super(key: key);

  Future<List<Stops>> _getStops() async {
    var data =
        await http.get(Uri.parse("https://musaabdata.herokuapp.com/api/stops"));
    var jsonData = json.decode(data.body);
    List<Stops> stops = [];
    for (var s in jsonData) {
      Stops stop = Stops(s['name'], s['latitude'], s['longitude']);
      for (var i = 0; i < s['buses'].length; i++) {
        stop.buses.add(s['buses'][i]);
      }
      stops.add(stop);
    }
    return stops;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ULAŞIM',
          style: TextStyle(fontSize: 25),
        ),
        elevation: 10,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getStops(),
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
                    leading: Icon(Icons.location_on),
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
  final Stops stop;

  DetailsPage(this.stop);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ULAŞIM',
            style: TextStyle(fontSize: 25),
          ),
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
                      '${stop.name}',
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Busler :\n 1 - ${stop.buses[0]} \n 2 - ${stop.buses[1]}',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ))
        ]));
  }
}

class Stops {
  final String name;
  final String latitude;
  final String longitude;
  List<String> buses = [];
  Stops(this.name, this.latitude, this.longitude);

  void addBuses(String buses) {
    this.buses.add(buses);
  }
}
