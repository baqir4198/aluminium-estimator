import 'package:aluminium_estimator/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const FabApp());

class FabApp extends StatelessWidget {
  const FabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fabrication',
      theme: AppTheme.light(),
      home: const HomeScreen(),
    );
  }
}


