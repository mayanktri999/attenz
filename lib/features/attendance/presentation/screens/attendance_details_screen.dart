import 'package:flutter/material.dart';

class AttendanceDetailsScreen extends StatelessWidget {
  final String subjectId;

  const AttendanceDetailsScreen({
    super.key,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance - $subjectId'),
      ),
      body: Center(
        child: Text(
          'Subject ID: $subjectId',
        ),
      ),
    );
  }
}