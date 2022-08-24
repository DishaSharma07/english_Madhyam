
import 'package:shared_preferences/shared_preferences.dart';
class Prefs{
  static Future<UserPrefManager> getUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    UserPrefManager userPrefManager=UserPrefManager(name: sharedPreferences.getString("name")!, image: sharedPreferences.getString("image")!);


    return userPrefManager;
  }
}
class UserPrefManager{
  final String name;
  final String image;

  UserPrefManager({required this.name,required this.image});

}
