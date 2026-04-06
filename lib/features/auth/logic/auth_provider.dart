import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final Box<UserModel> _usersBox = Hive.box<UserModel>('usersBox');
  final Box _sessionBox = Hive.box('sessionBox');

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Hàm Đăng ký
  Future<bool> register(String email, String password, String name) async {
    if (_usersBox.containsKey(email)) {
      return false; // Email đã tồn tại
    }
    final newUser = UserModel(
        id: DateTime.now().toString(),
        email: email,
        password: password,
        displayName: name);
    await _usersBox.put(email, newUser); // Dùng email làm Key luôn cho dễ tìm
    return true;
  }


  Future<void> logout() async {
    _currentUser = null;
    await _sessionBox.delete('loggedInEmail');
    notifyListeners(); // Cập nhật lại giao diện ngay lập tức
  }
}
