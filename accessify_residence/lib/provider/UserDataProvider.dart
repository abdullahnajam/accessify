import 'package:accessify/model/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserDataProvider extends ChangeNotifier {
  UserModel userModel;
  void setUserData(UserModel data) {
    this.userModel = data;
    notifyListeners();
  }


}
