import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/features/student/providers/current_student_provider.dart';

/// Login screen — identity/session selection only.
///
/// There is currently no student authentication API.
/// This screen captures the student number, stores it in
/// [currentStudentNumberProvider], and navigates to Home.
///
/// No password is collected or sent anywhere.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _studentNumberController = TextEditingController();

  @override
  void dispose() {
    _studentNumberController.dispose();
    super.dispose();
  }

  void _login() {
    final studentNumber = _studentNumberController.text.trim();

    if (studentNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your student number'),
        ),
      );
      return;
    }

    // Store student number in session state — no API call made.
    ref.read(currentStudentNumberProvider.notifier).setStudentNumber(studentNumber);

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              const Text(
                'Welcome to AttenZ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Enter your student number to continue',
                style: TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: _studentNumberController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _login(),
                decoration: const InputDecoration(
                  labelText: 'Student Number',
                  hintText: 'Enter your student number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}