// lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz; // Import timezone data
import 'providers/task_provider.dart';
import 'services/theme_service.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Initialize timezone data for notifications
  await NotificationService.initialize(); // Initialize notifications

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Task Management App',
            themeMode: themeService.currentTheme,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blueGrey,
              textTheme: GoogleFonts.robotoTextTheme(),
              scaffoldBackgroundColor: Colors.grey[200],
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 21, 0, 253),
                foregroundColor: Colors.white,
              ),
              cardColor: Colors.white,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              textTheme: GoogleFonts.robotoTextTheme(),
              scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Color.fromARGB(255, 255, 7, 7),
              ),
              cardColor: Colors.blueAccent,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
