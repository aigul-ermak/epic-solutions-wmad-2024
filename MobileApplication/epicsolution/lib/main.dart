import 'package:epicsolution/page/home_page.dart';
import 'package:epicsolution/page/login_page.dart';
import 'package:epicsolution/page/spashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './model/session.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserSession(token: ''),
      child: MyApp(),
    ),
  );

  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your applicati
  // on.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.grey[400],
      ),
      initialRoute: '/', // Set initial route to '/'
      routes: {
        '/': (context) => Login(), // Define the route for Login widget
        '/login': (context) => Login(),
        '/home': (context) => HomePage(
            token: Provider.of<UserSession>(context, listen: false)
                .token), // Define the route for Home page widget
        // Add other routes if needed
      },
    );
  }
}
