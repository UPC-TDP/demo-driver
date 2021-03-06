import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/providers/driver_provider.dart';
import 'package:maps/providers/map_provider.dart';
import 'package:provider/provider.dart';

class MapsWidget extends StatelessWidget {
  MapsWidget({Key? key}) : super(key: key);

  late GoogleMapController googleMapController;

  late String _mapStyle;

  void _loadDriver(BuildContext context) {
    Provider.of<DriverProvider>(context, listen: false)
        .drive(context, this.googleMapController);
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> polylines = Provider.of<MapProvider>(context).polylines;
    Set<Marker> markers = Provider.of<MapProvider>(context).markers;
    Provider.of<DriverProvider>(context).markers = markers;

    return Scaffold(
      body: GoogleMap(
          initialCameraPosition:
              Provider.of<MapProvider>(context, listen: true).position,
          zoomControlsEnabled: false,
          onMapCreated: onMapCreatedEvent,
          markers: markers,
          polylines: {
            if (polylines.length > 0)
              Polyline(
                polylineId: const PolylineId('overview_polyline'),
                color: Colors.red,
                width: 5,
                points: polylines,
              ),
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.green,
        onPressed: () {
          _loadDriver(context);
        },
      ),
    );
  }

  void onMapCreatedEvent(controller) {
    googleMapController = controller;
    _loadMapStyle(googleMapController);
  }

  void _loadMapStyle(GoogleMapController googleMapController) {
    rootBundle.loadString('assets/map-style.json').then((mapStyle) {
      _mapStyle = mapStyle;
      googleMapController.setMapStyle(_mapStyle);
    });
  }
}
