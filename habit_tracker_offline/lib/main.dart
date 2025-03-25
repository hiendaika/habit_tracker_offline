import 'package:flutter/material.dart';
import 'package:habit_tracker_offline/database/habit_database.dart';
import 'package:habit_tracker_offline/pages/home_page.dart';
import 'package:habit_tracker_offline/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize database
  await HabitDatabase.initialize(); //initialize la static method
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(
      providers: [
        //Habit provider
        ChangeNotifierProvider(create: (context) => HabitDatabase()),
        //Theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context, listen: false).themeData,
      home: const HomePage(),
    );
  }
}
