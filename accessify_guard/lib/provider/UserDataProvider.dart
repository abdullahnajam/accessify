
import 'package:flutter/cupertino.dart';
import 'package:guard/model/user_model.dart';

class UserDataProvider extends ChangeNotifier {
  UserModel userModel;
  void setUserData(UserModel data) {
    this.userModel = data;
    notifyListeners();
  }


}
