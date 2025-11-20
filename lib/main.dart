import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_to/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       brightness:Brightness.dark,
       primaryColor: const Color(0xFF00061a),
       shadowColor: const Color(0xFF001456),
       splashColor: const Color(0xFF4169e8),

      ),
      
      home: const HomePage(),
    );
  }
}

