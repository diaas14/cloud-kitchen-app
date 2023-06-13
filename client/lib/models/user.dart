import 'package:flutter/foundation.dart';
import 'package:client/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  Future<void> fetchUserProfileData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userData = await fetchProfileData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      // rethrow;
    }
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      _userData = jsonDecode(userDataString);
    }
    notifyListeners();
  }

  Future<void> saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = jsonEncode(data);
    await prefs.setString('userData', userDataString);
    _userData = data;
    notifyListeners();
  }
}
