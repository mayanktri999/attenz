import 'user_model.dart';

/// Represents the response from `GET /attendance/search/:studentNumber`.
///
/// The backend returns integer percentage values (e.g. 92).
/// All numeric fields are stored as [double] for UI flexibility.
class AttendanceModel {
  final String id;
  final String userId;
  final double overallPercentage;
  final double overallPresent;
  final double overallLecture;
  final double overallRemedialClass;
  final double overallRemedialTotalClass;
  final DateTime? lastUpdated;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? user;

  const AttendanceModel({
    required this.id,
    required this.userId,
    required this.overallPercentage,
    required this.overallPresent,
    required this.overallLecture,
    required this.overallRemedialClass,
    required this.overallRemedialTotalClass,
    this.lastUpdated,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      overallPercentage: _parseDouble(json['overall_percentage']),
      overallPresent: _parseDouble(json['overall_present']),
      overallLecture: _parseDouble(json['overall_lecture']),
      overallRemedialClass: _parseDouble(json['overall_remedial_class']),
      overallRemedialTotalClass:
          _parseDouble(json['overall_remedial_total_class']),
      lastUpdated: _parseDateTime(json['last_updated']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      user: json['user'] != null
          ? UserModel.fromJson(
              Map<String, dynamic>.from(json['user'] as Map),
            )
          : null,
    );
  }

  /// Safely converts int, double, or string values to [double].
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
