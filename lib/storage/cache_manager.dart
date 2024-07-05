import 'dart:convert';

import 'package:english_madhyam/resrc/models/model/editorial_detail_model/editorial_task_model.dart';
import 'package:get_storage/get_storage.dart';

enum CacheManagerKey { TOKEN,FCMTOKEN,USERNAME,PASSWORD,PROFILE,NAME,IMAGE,WALLET,IS_REMEMBER,EMAIL,MOBILE }

mixin CacheManager {
  Future<bool> saveToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TOKEN.toString(), token);
    return true;
  }

  String? getToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.TOKEN.toString());
  }


  Future<bool> saveFcmToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.FCMTOKEN.toString(), token);
    return true;
  }
  bool? getBirthday() {
    final box = GetStorage();
    return box.read("birthday");
  }

  bool? getShowed() {
    final box = GetStorage();
    return box.read("showed");
  }

  Future<void> setBirthdayAndShowed(birthday,showed) async {
    final box = GetStorage();
    await box.write("birthday", birthday);
    await box.write("showed", showed);
  }
  // Future<void> setReadingData(editorialId,int startingIndex,int endingIndex) async {
  //   final box = GetStorage();
  //   await box.write(editorialId.toString(), "${startingIndex}_$endingIndex");
  // }
  Future<void> setReadingData(editorialId,String editorialDescription) async {
    final box = GetStorage();
    await box.write(editorialId.toString(), editorialDescription);
  }
  String getReadingData(editorialId)  {
    final box = GetStorage();
   return  box.read(editorialId.toString())??"";
  }

  String? getFcmToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.FCMTOKEN.toString());
  }


  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.TOKEN.toString());
    print("Token removed");
  }

  Future<bool> setProfileData({required String username,required String name,
    required String email,required String profile,required String mobile}) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.NAME.toString(), name);
    await box.write(CacheManagerKey.USERNAME.toString(), username);
    await box.write(CacheManagerKey.EMAIL.toString(), email);
    await box.write(CacheManagerKey.MOBILE.toString(), mobile);
    await box.write(CacheManagerKey.PROFILE.toString(), profile);
    return true;
  }

  Future<bool> saveRememberMe({required String username,required String password,required bool isChecked}) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.USERNAME.toString(), username);
    await box.write(CacheManagerKey.PASSWORD.toString(), password);
    await box.write(CacheManagerKey.IS_REMEMBER.toString(), isChecked);
    return true;
  }

  String? getUsername() {
    final box = GetStorage();
    return box.read(CacheManagerKey.USERNAME.toString());
  }

  String? getEmail() {
    final box = GetStorage();
    return box.read(CacheManagerKey.EMAIL.toString());
  }
  String? getProfileImage() {
    final box = GetStorage();
    return box.read(CacheManagerKey.PROFILE.toString());
  }
  String? getMobile() {
    final box = GetStorage();
    return box.read(CacheManagerKey.MOBILE.toString());
  }

  bool? isRememberLogin() {
    final box = GetStorage();
    return box.read(CacheManagerKey.IS_REMEMBER.toString());
  }

  String? getName() {
    final box = GetStorage();
    return box.read(CacheManagerKey.NAME.toString())??"";
  }

  String? getImage() {
    final box = GetStorage();
    return box.read(CacheManagerKey.IMAGE.toString())??"";
  }
  String? getBallance() {
    final box = GetStorage();
    return box.read(CacheManagerKey.WALLET.toString())??"";
  }
  // Retrieve a list of EditorialDescription objects from JSON
  List<EditorialDescription> getEditorialDescriptions(String key) {
    final box = GetStorage();
    String? jsonString = box.read<String>(key);
    if (jsonString != null) {
      List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => EditorialDescription.fromJson(json)).toList();
    }
    return [];
  }
}