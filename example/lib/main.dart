import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import 'config.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocationData _startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _location = new Location();
  bool _permission = false;
  bool _locationService = false;
  String error;

  bool currentWidget = true;

  Image image1;

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _permission = await _location.requestPermission();
      print("Permission: $_permission");
      location = await _location.getLocation();
      print("Location: $location");

      if (_permission) {
        _locationSubscription = _location.onLocationChanged().listen((LocationData result) {
          setState(() {
            _currentLocation = result;
          });
        });
      }

    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } 
      location = null;
    }

    setState(() {
        _startLocation = location;
    });

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;

    if (_currentLocation == null) {
      widgets = new List();
    } else {
      widgets = [
        new Image.network(
            "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation.latitude},${_currentLocation.longitude}&zoom=18&size=640x400&key=$API_KEY")
      ];
    }

    widgets.add(new Center(
        child: new Text(_startLocation != null
            ? 'Start location: ${_startLocation.latitude} & ${_startLocation.longitude}\n'
            : 'Error: $error\n')));

    widgets.add(new Center(
        child: new Text(_currentLocation != null
            ? 'Continuous location: ${_currentLocation.latitude} & ${_currentLocation.longitude} & ${_currentLocation.heading}\n'
            : 'Error: $error\n')));

    widgets.add(new Center(
      child: new Text(_permission 
            ? 'Has permission : Yes' 
            : "Has permission : No")));

    widgets.add(new Center(
        child: new Text(_locationService
            ? 'Has enabled gps : Yes'
            : "Has enabled gps: No")));

    widgets.add(
      FloatingActionButton(
        onPressed: () async {
          _locationService = await _location?.enableGPS();
          setState((){});
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );

    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Location plugin example app'),
            ),
            body: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: widgets,
            )));
  }
}
