import 'dart:ui';

import 'package:epicsolution/model/userOutput.dart';
import 'package:flutter/material.dart';
import 'package:epicsolution/api_handler.dart';

import '../model/model.dart';
import 'MyButton.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController employeeController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _LoginState extends State<Login> {
  final ApiHandler apiHandler = ApiHandler();

  void logIn() async {
    String employeeNumber = employeeController.text;
    String password = passwordController.text;

    UserOutput? userOutput =
        (await apiHandler.loginUser(context, employeeNumber, password));

    if (userOutput != null) {
      print('Login successful!');
      showCustomDialog(context, 'Success', 'Login successful!');
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/home');

      employeeController.clear();
      passwordController.clear();
    } else {
      print('Login failed!');
      showCustomDialog(
          context, 'Error', 'Login failed! Please check your credentials.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Color(0xFF5474FC);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey[900]!,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 10),
            Container(
              height: 150,
              child: Image.asset('images/logo.jpeg', height: 150),
            ),
            SizedBox(height: 50),
            Text(
              'Log In',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: employeeController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor)),
                  fillColor: Colors.grey[50],
                  filled: true,
                  hintText: 'Employee Number',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.38)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.68))),
                  fillColor: Colors.grey[50],
                  filled: true,
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.38)),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 35),
            MyButton(
              onTap: logIn, // Call logIn method when the button is tapped
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Color(0xFFA3FFD6), // Specify the background color here
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFA3FFD6),
            // Adjust the background color here if needed
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
