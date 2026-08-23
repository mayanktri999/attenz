import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const AttenZ());
}

class AttenZ extends StatelessWidget {
  const AttenZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AttenZ',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      themeMode: ThemeMode.system,

      home: const Scaffold(
        body: Center(
          child: Text('AttenZ'),
        ),
      ),
    );
  }
}