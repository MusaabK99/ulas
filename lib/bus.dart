// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, unnecessary_new, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_string_interpolations
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ulas/noficationservice.dart';

class BusPage extends StatefulWidget {
  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  Future<List<Buses>> getBuses() async {
    var data =
        await http.get(Uri.parse("https://musaabdata.herokuapp.com/api/buses"));
    var jsonData = json.decode(data.body);
    List<Buses> buses = [];
    for (var b in jsonData) {
      Buses bus = Buses(
          b['id'], b['name'], b['latitude'], b['longitude'], b['distance']);
      for (var i = 0; i < b['stops'].length; i++) {
        bus.stops.add(b['stops'][i]);
      }
      buses.add(bus);
    }
    return buses;
  }

  Position? _currentUserPosition;

  double? distanceImMeter = 0.0;

  Future _getTheDistance() async {
    _currentUserPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var data = await getBuses();
    for (var i = 0; i < data.length; i++) {
      var bus = data[i];
      double buslat = double.parse(bus.latitude);
      double buslng = double.parse(bus.longitude);
      distanceImMeter = await Geolocator.distanceBetween(
          _currentUserPosition!.latitude,
          _currentUserPosition!.longitude,
          buslat,
          buslng);

      var distance = distanceImMeter?.round().toInt();
      distance?.round();
      setState(() {});
    }
  }

  @override
  void initState() {
    _getTheDistance();
    super.initState();
  }

  // distanceImMeter = await Geolocator.distanceBetween(
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
                    subtitle: _getTheDistance() == null
                        ? Text('Distance: ' + snapshot.data[index].distance)
                        : Text('Distance: ' + distanceImMeter.toString()),
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

class DetailsPage extends StatefulWidget {
  final Buses bus;

  DetailsPage(this.bus);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotification();
  }

  void listenNotification() {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => busNafPage(widget.bus)));
  }

  bool clicked = false;
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
              icon: Icon((clicked = false)
                  ? Icons.notifications
                  : Icons.notifications_active),
              onPressed: () {
                (clicked = true)
                    ? NotificationApi.showNotification(
                        int.parse(widget.bus.id),
                        "${widget.bus.name} Yakın !",
                        "Acelet et !",
                        "${widget.bus.name}")
                    : NotificationApi.cancelAllNotifications(widget.bus.id);
                setState(() {
                  clicked = !clicked;
                });
              },
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
                      '${widget.bus.name}',
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Duraklar :  \n 1 - ${widget.bus.stops[0]} \n 2 - ${widget.bus.stops[1]}',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ))
        ]));
  }
}

class busNafPage extends StatefulWidget {
  final Buses bus;
  busNafPage(this.bus);

  @override
  State<busNafPage> createState() => _busNafPageState();
}

class _busNafPageState extends State<busNafPage> {
  late GoogleMapController googleMapController;

  blackTheme() {
    googleMapController.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
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
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(widget.bus.latitude),
                  double.parse(widget.bus.longitude)),
              zoom: 17,
            ),
            markers: Set.from(
              <Marker>[
                Marker(
                  markerId: MarkerId(widget.bus.name),
                  position: LatLng(double.parse(widget.bus.latitude),
                      double.parse(widget.bus.longitude)),
                  infoWindow: InfoWindow(title: widget.bus.name, onTap: () {}),
                ),
                // Marker(
                //     markerId: MarkerId('myMarker'),
                //     position: LatLng(
                //         currentPosition.latitude, currentPosition.longitude),
                //     infoWindow: InfoWindow(title: 'My Location')),
              ],
            ),
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
              blackTheme();
            },
          ),
        ],
      ),
    );
  }
}

class Buses {
  final String id;
  final String name;
  final String latitude;
  final String longitude;
  late final String distance;
  List<String> stops = [];
  Buses(this.id, this.name, this.latitude, this.longitude, this.distance);
  void addStops(String stop) {
    stops.add(stop);
  }
}
