import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  Timer _timer;
  String get token {
    return _token;
  }

  Future<int> authenticate(userData) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json '},
        body: json.encode({
          'email': userData['email'],
          'password': userData['password'],
          'returnSecureToken': true
        }));
    if (response.body.isEmpty) return 0;

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _token = responseData['idToken'];

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'userData',
          json.encode(
              {'token': _token, 'expiryDate': _expiryDate.toIso8601String()}));
      startTimer();
      notifyListeners();
    }
    return response.statusCode;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void startTimer() {
    int duration = DateTime.now().difference(_expiryDate).inSeconds.abs();
    _timer = Timer(Duration(seconds: duration), () async {
      await logout();
    });
  }

  Future<bool> tryToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final loadedData = json.decode(prefs.getString('userData'));
    final DateTime expiryDate = DateTime.parse(loadedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return false;
    _token = loadedData['token'];
    _expiryDate = expiryDate;
    startTimer();
    notifyListeners();
    return true;
  }

  bool get isAuth {
    if (_token == null || _token.isEmpty) return false;
    if (_expiryDate.isBefore(DateTime.now())) return false;
    return true;
  }
}
