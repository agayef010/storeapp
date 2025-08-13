import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String _error = '';

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isLoggedIn => _user != null;

  UserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');
      if (userData != null) {
        _user = User.fromJson(json.decode(userData));
      }
    } catch (e) {
      _error = 'İstifadəçi məlumatları yüklənərkən xəta baş verdi: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_user != null) {
        final userData = json.encode(_user!.toJson());
        await prefs.setString('user', userData);
      } else {
        await prefs.remove('user');
      }
    } catch (e) {
      _error = 'İstifadəçi məlumatları saxlanarkən xəta baş verdi: $e';
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Mock login for demonstration
      await Future.delayed(Duration(seconds: 1));
      
      if (email == 'test@example.com' && password == 'password') {
        _user = User(
          id: '1',
          name: 'Test İstifadəçi',
          email: email,
          phone: '+994501234567',
          address: 'Bakı şəhəri, Azərbaycan',
          avatarUrl: 'https://picsum.photos/200/200?random=user',
        );
        await _saveUser();
        return true;
      } else {
        _error = 'Email və ya şifrə yanlışdır';
        return false;
      }
    } catch (e) {
      _error = 'Giriş zamanı xəta baş verdi: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    await _saveUser();
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    if (_user != null) {
      _user = User(
        id: _user!.id,
        name: name ?? _user!.name,
        email: _user!.email,
        phone: phone ?? _user!.phone,
        address: address ?? _user!.address,
        avatarUrl: _user!.avatarUrl,
      );
      await _saveUser();
      notifyListeners();
    }
  }

  Future<void> updateAvatar(String avatarUrl) async {
    if (_user != null) {
      _user = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        phone: _user!.phone,
        address: _user!.address,
        avatarUrl: avatarUrl,
      );
      await _saveUser();
      notifyListeners();
    }
  }
} 