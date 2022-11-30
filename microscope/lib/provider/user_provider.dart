import 'package:flutter/material.dart';
import 'package:microscope/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    email: '',
    uid: '',
    username: '',
  );

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
