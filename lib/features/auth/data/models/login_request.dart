class LoginRequest {
  final String studentNumber;
  final String password;

  const LoginRequest({
    required this.studentNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_number': studentNumber,
      'password': password,
    };
  }
}