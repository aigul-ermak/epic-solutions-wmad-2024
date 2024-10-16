import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/model.dart';
import 'model/userOutput.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import './model/session.dart';

// Import the UserOutput class

class ApiHandler {
  final String baseUrl = "http://10.0.2.2:5073/api/login";

  Future<UserOutput?> loginUser(
      BuildContext context, String employeeNumber, String password) async {
    final uri = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'employeeNumber': employeeNumber,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String token = responseData['token'];

        Provider.of<UserSession>(context, listen: false).token = token;

        return UserOutput.fromJson(responseData);
      } else {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
