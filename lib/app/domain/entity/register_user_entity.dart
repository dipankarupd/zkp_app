class UserEntity {
  final String id;
  final String name;
  final LocationEntity location;
  final int token;
  final String createdAt;
  final int presentCount;
  final int absentCount;
  final DateTime? lastChecked; // Nullable DateTime

  UserEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.token,
    required this.createdAt,
    required this.presentCount,
    required this.absentCount,
    this.lastChecked, // Nullable
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
