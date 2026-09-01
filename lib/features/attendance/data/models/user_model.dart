/// Represents the `user` object embedded in the attendance search response.
///
/// All fields except [id] are nullable because the backend may omit them.
class UserModel {
  final String id;
  final String fullName;
  final String rollNumber;
  final String admissionNumber;
  final DateTime? dob;
  final String? gender;
  final int? age;
  final DateTime? admissionDate;
  final String? email;
  final String? mobileNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.rollNumber,
    required this.admissionNumber,
    this.dob,
    this.gender,
    this.age,
    this.admissionDate,
    this.email,
    this.mobileNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
      rollNumber: (json['roll_number'] ?? '').toString(),
      admissionNumber: (json['admission_number'] ?? '').toString(),
      dob: _parseDateTime(json['dob']),
      gender: json['gender']?.toString(),
      age: _parseInt(json['age']),
      admissionDate: _parseDateTime(json['admission_date']),
      email: json['email']?.toString(),
      mobileNumber: json['mobile_number']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }
}
