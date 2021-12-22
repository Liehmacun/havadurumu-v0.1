import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Locaton extends StatefulWidget {
  final double lat;
  final double long;

  const Locaton({Key? key, required this.lat, required this.long})
      : super(key: key);
  @override
  _LocationState createState() => _LocationState();
}

/* 
location API key as been removed for safety purpose
so map wont work 
*/
class _LocationState extends State<Locaton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat, widget.long), zoom: 12.0)),
    );
  }
}
