import 'package:zkp_app/app/domain/entity/register_user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required LocationModel super.location,
    required super.token,
    required super.createdAt,
    required super.presentCount,
    required super.absentCount,
    super.lastChecked,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'] as Map<String, dynamic>)
          : LocationModel(latitude: 0.0, longitude: 0.0),
      token: json['login_token'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      presentCount: json['present_count'] as int? ?? 0,
      absentCount: json['absent_count'] as int? ?? 0,
      lastChecked: json['last_checked'] != null
          ? DateTime.tryParse(json['last_checked'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': (location as LocationModel).toJson(),
      'login_token': token,
      'created_at': createdAt,
      'present_count': presentCount,
      'absent_count': absentCount,
      'last_checked': lastChecked?.toIso8601String(),
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
