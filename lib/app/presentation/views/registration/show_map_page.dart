// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class RegistrationMapPage extends StatefulWidget {
//   const RegistrationMapPage({super.key});

//   @override
//   State<RegistrationMapPage> createState() => _RegistrationMapPageState();
// }

// class _RegistrationMapPageState extends State<RegistrationMapPage> {
//   static const LatLng _initialPosition = LatLng(12.9716, 77.5946);

//   late GoogleMapController _mapController;
//   Marker? _marker;
//   Position? _currentLocation;

//   Future<Position> _getCurrentPosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   void _updateMarker(LatLng pos) {
//     setState(() {
//       _marker = Marker(
//         markerId: const MarkerId('selected_location'),
//         position: pos,
//         draggable: true,
//         icon: BitmapDescriptor.defaultMarker,
//         infoWindow: const InfoWindow(
//           title: 'Selected Location',
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // fetch the username arg from the prev screen:
//     final arg = ModalRoute.of(context)?.settings.arguments as Map?;
//     // final username = arg?['username'] ?? 'User';

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//         title: Text(
//           'Enter Location',
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Text(
//               'Please select preferred location for classes',
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Expanded(
//               child: GoogleMap(
//                 onMapCreated: _onMapCreated,
//                 initialCameraPosition: const CameraPosition(
//                   target: _initialPosition,
//                   zoom: 13,
//                 ),
//                 markers: _marker != null ? {_marker!} : {},
//                 onTap: (LatLng pos) {
//                   _updateMarker(pos);
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle location selection
//                 if (_marker != null) {
//                   Navigator.pop(context, {
//                     'location': {
//                       'lat': _marker!.position.latitude,
//                       'lng': _marker!.position.longitude
//                     }
//                   });
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Please select a location')),
//                   );
//                 }
//               },
//               child: Text('Confirm Location'),
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           try {
//             _currentLocation = await _getCurrentPosition();

//             if (_currentLocation != null) {
//               _updateMarker(
//                 LatLng(
//                   _currentLocation!.latitude,
//                   _currentLocation!.longitude,
//                 ),
//               );

//               _mapController.animateCamera(
//                 CameraUpdate.newLatLngZoom(
//                   LatLng(
//                     _currentLocation!.latitude,
//                     _currentLocation!.longitude,
//                   ),
//                   15,
//                 ),
//               );
//             }
//           } catch (e) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(e.toString())),
//             );
//           }
//         },
//         child: const Icon(Icons.my_location),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zkp_app/app/presentation/bloc/registration/bloc/bloc_bloc.dart';

class RegistrationMapPage extends StatefulWidget {
  const RegistrationMapPage({super.key});

  @override
  State<RegistrationMapPage> createState() => _RegistrationMapPageState();
}

class _RegistrationMapPageState extends State<RegistrationMapPage> {
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

    // Update location in bloc
    context.read<RegistrationBloc>().add(
          LocationSelectedEvent(
            latitude: pos.latitude,
            longitude: pos.longitude,
          ),
        );
  }

  void _showSuccessDialog(int token) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Registration Successful'),
        content: Text('Your verification token is: $token'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.status == RegistrationStatus.loading) {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state.status == RegistrationStatus.success &&
            state.token != null) {
          // Close loading dialog if it's open
          Navigator.of(context).pop();
          // Show success dialog with token
          _showSuccessDialog(state.token!);
        } else if (state.status == RegistrationStatus.failure &&
            state.errorMessage != null) {
          // Close loading dialog if it's open
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            'Enter Location',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                'Please select preferred location for classes',
              ),
              const SizedBox(
                height: 5,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle location selection
                  if (_marker != null) {
                    // Print the latitude and longitude values of the selected location
                    print('Latitude: ${_marker!.position.latitude}');
                    print('Longitude: ${_marker!.position.longitude}');

                    // Trigger registration submission
                    context.read<RegistrationBloc>().add(
                          RegistrationSubmittedEvent(),
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
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          },
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }
}
