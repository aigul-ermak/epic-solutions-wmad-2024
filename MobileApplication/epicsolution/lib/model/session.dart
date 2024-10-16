import 'package:flutter/foundation.dart';

class UserSession extends ChangeNotifier {
  String _token;

  UserSession({String token = ''}) : _token = token;

  String get token => _token;

  set token(String value) {
    if (_token != value) {
      _token = value;
      notifyListeners();
    }
  }
}
