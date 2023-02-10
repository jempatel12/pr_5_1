import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pr_5_1/screens/global.dart';
import 'package:pr_5_1/screens/map.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'weather',
      routes: {
        '/': (context) => home(),
        'map': (context) => map(),
      },
    ),
  );
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

Placemark? current;

class _homeState extends State<home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _widht = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("API"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  openAppSettings();
                },
                icon: Icon(Icons.settings))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${Global.lat}\n${Global.long}\n$current"),
              ElevatedButton(
                  onPressed: () async {
                    Geolocator.getPositionStream()
                        .listen((Position position) async {
                      setState(() {
                        Global.lat = position.latitude;
                        Global.long = position.longitude;
                      });
                      List<Placemark> placemark =
                      await placemarkFromCoordinates(
                          Global.lat, Global.long);
                      setState(() {
                        current = placemark[0];
                      });
                    });
                    setState(() {
                      Navigator.of(context).pushNamed('map');
                    });
                  },
                  child: Text("get loction"))
            ],
          ),
        ));
  }
}