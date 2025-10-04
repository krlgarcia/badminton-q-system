import 'package:flutter/material.dart';
import 'screens/all_players_screen.dart';
import 'utils/sample_data.dart';

void main() {
  // Initialize sample data for demonstration purposes
  SampleDataInitializer.initializeSampleData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badminton Q',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const AllPlayersScreen(),
    );
  }
}


