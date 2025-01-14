import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zkp_app/config/location.dart';
import 'package:zkp_app/config/response_model.dart';
import 'package:zkp_app/widgets/verification_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const LatLng _initialPosition = LatLng(12.9716, 77.5946);

  late GoogleMapController _mapController;
  Marker? _marker;
  Position? _currentLocation;
  bool servicePermission = false;
  LocationPermission? permission;

  // State variable for storing the last verification time
  String? time;
  final dio = Dio();

  Future<Position> _getCurrentPosition() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      // Handle location services disabled
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateMarker(LatLng pos) {
    setState(() {
      _marker = Marker(
        markerId: const MarkerId('selected_location'),
        position: pos,
        draggable: true,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: 'Selected Location',
        ),
      );
    });
  }

  Future<ResponseModel> _getResponse() async {
    _currentLocation = await _getCurrentPosition();
    String time = DateTime.now().toString();

    Location markerLocation = Location(
      lat: _marker != null ? _marker!.position.latitude : 0.0,
      long: _marker != null ? _marker!.position.longitude : 0.0,
    );
    Location actualLocation = Location(
      lat: _currentLocation != null ? _currentLocation!.latitude : 0.0,
      long: _currentLocation != null ? _currentLocation!.longitude : 0.0,
    );

    final distance = Geolocator.distanceBetween(
      actualLocation.lat,
      actualLocation.long,
      markerLocation.lat,
      markerLocation.long,
    );
    // print(res);
    ResponseModel? res;
    // handle dio response:
    try {
      const url = "https://utterly-legal-toad.ngrok-free.app/run_pipeline";

      //print(distance);

      final result = await dio.post(
        url,
        data: {"distance": distance.toInt()},
      );

      final respData = result.data;
      res = ResponseModel(
        time: DateTime.now(),
        res: respData["result"],
      );
      return res;
    } catch (e) {
      //print(e.toString());
      return ResponseModel(time: DateTime.now(), res: "0");
    }
  }

  @override
  Widget build(BuildContext context) {
    Future verificationDialog(bool flag) => showDialog(
          context: context,
          builder: (context) => VerificationDialog(
            isSuccess: flag,
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Verifier'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              time != null ? 'Last verified on: $time' : 'Verify first',
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: _initialPosition,
                zoom: 13,
              ),
              markers: _marker != null ? {_marker!} : {},
              onTap: (LatLng pos) {
                _updateMarker(pos);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              ResponseModel res = await _getResponse();

              if (res.res == "1") {
                verificationDialog(true);
              } else {
                verificationDialog(false);
              }
            },
            child: const Text('Submit'),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _currentLocation = await _getCurrentPosition();

          if (_currentLocation != null) {
            _updateMarker(
              LatLng(
                _currentLocation!.latitude,
                _currentLocation!.longitude,
              ),
            );

            _mapController.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(
                  _currentLocation!.latitude,
                  _currentLocation!.longitude,
                ),
                15,
              ),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
