class LoginResponse {
  final bool success;
  final String token;
  final StudentData student;

  const LoginResponse({
    required this.success,
    required this.token,
    required this.student,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
      student: StudentData.fromJson(
        json['student'] ?? {},
      ),
    );
  }
}

class StudentData {
  final String studentNumber;
  final String name;
  final String? email;

  const StudentData({
    required this.studentNumber,
    required this.name,
    this.email,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      studentNumber: json['student_number'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
    );
  }
}