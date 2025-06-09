class StudentEntity {
  final String id;
  final String name;
  final LocationEntity location;
  final int token;
  final DateTime registeredAt;

  StudentEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.token,
    required this.registeredAt,
  });
}

class LocationEntity {
  final double latitude;
  final double longitude;

  LocationEntity({
    required this.latitude,
    required this.longitude,
  });
}
