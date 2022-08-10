import 'package:e_warung/data/model/login_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  static const id = 'ID';
  static const username = 'USERNAME';
  static const email = 'EMAIL';
  static const nama = 'NAMA';
  static const alamat = 'ALAMAT';
  static const latitude = 'LATITUDE';
  static const longitude = 'LONGITUDE';
  static const noTelp = 'NO_TELP';
  static const avatar = 'AVATAR';
  static const role = 'ROLE';
  static const activate = 'ACTIVATE';

  Future<User> get getUserLogin async {
    final SharedPreferences prefs = await sharedPreferences;
    User user = User(
      id: prefs.getString(id) ?? "",
      username: prefs.getString(username) ?? "",
      email: prefs.getString(email) ?? "",
      password: "",
      nama: prefs.getString(nama) ?? "",
      alamat: prefs.getString(alamat) ?? "",
      latitude: prefs.getString(latitude) ?? "",
      longitude: prefs.getString(longitude) ?? "",
      noTelp: prefs.getString(noTelp) ?? "",
      avatar: prefs.getString(avatar) ?? "",
      role: prefs.getString(role) ?? "",
      activate: prefs.getString(activate) ?? "",
    );
    return user;
  }

  void setUserLogin(User user) async {
    final SharedPreferences prefs = await sharedPreferences;

    prefs.setString(id, user.id);
    prefs.setString(username, user.username ?? "");
    prefs.setString(email, user.email);
    prefs.setString(nama, user.nama ?? "");
    prefs.setString(alamat, user.alamat ?? "");
    prefs.setString(latitude, user.latitude ?? "");
    prefs.setString(longitude, user.longitude ?? "");
    prefs.setString(noTelp, user.noTelp ?? "");
    prefs.setString(avatar, user.avatar ?? "");
    prefs.setString(role, user.role);
    prefs.setString(activate, user.activate);
  }

  void removeUserLogin() async {
    final SharedPreferences prefs = await sharedPreferences;

    prefs.remove(id);
    prefs.remove(username);
    prefs.remove(email);
    prefs.remove(nama);
    prefs.remove(alamat);
    prefs.remove(latitude);
    prefs.remove(longitude);
    prefs.remove(noTelp);
    prefs.remove(avatar);
    prefs.remove(role);
    prefs.remove(activate);
  }
}
