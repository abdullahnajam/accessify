import 'package:accessify/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  setVisitsAllowed(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(allowedVisits, value);
  }
  Future<bool> getVisitsAllowed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(allowedVisits) ?? true);
  }
}