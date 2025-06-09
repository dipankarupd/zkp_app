// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UpdateMapPage extends StatefulWidget {
  const UpdateMapPage({super.key});

  @override
  State<UpdateMapPage> createState() => _UpdateMapPageState();
}

class _UpdateMapPageState extends State<UpdateMapPage> {
  static const LatLng _initialPosition = LatLng(12.9716, 77.5946);

  late GoogleMapController _mapController;
  Marker? _marker;
  Position? _currentLocation;

  @override
  void initState() {
    super.initState();
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Enter Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text('Please select preferred location for classes'),
            const Text(
              'Note: You will need to wait for 7 days to rechange.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_marker != null) {
                  final LatLng selected = _marker!.position;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          // 'Selected Location: (${selected.latitude.toStringAsFixed(5)}, ${selected.longitude.toStringAsFixed(5)})',
                          'Sorry! Cannot Update Location. You recently updated.'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a location')),
                  );
                }
              },
              child: const Text('Confirm Location'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            _currentLocation = await _getCurrentPosition();

            if (_currentLocation != null) {
              final LatLng currentLatLng = LatLng(
                _currentLocation!.latitude,
                _currentLocation!.longitude,
              );

              _updateMarker(currentLatLng);

              _mapController.animateCamera(
                CameraUpdate.newLatLngZoom(currentLatLng, 15),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
