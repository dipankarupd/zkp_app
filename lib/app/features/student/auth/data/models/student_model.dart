import 'package:zkp_app/app/features/student/auth/domain/entity/student_entity.dart';

class StudentModel extends StudentEntity {
  StudentModel({
    required super.id,
    required super.name,
    required LocationModel super.location,
    required super.token,
    required super.registeredAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'] as Map<String, dynamic>)
          : LocationModel(latitude: 0.0, longitude: 0.0),
      token: json['token'] as int? ?? 0,
      registeredAt: DateTime.parse(json['registered_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': (location as LocationModel).toJson(),
      'token': token,
      'registered_at': registeredAt.toIso8601String(),
    };
  }
}

class LocationModel extends LocationEntity {
  LocationModel({
    required super.latitude,
    required super.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
