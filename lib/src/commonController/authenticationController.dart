import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:english_madhyam/resrc/utils/ui_helper.dart';
import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import 'package:english_madhyam/storage/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../../resrc/helper/fcm/push_notification_service.dart';
import '../auth/login/model/login_model.dart';
import '../auth/login/model/new_usermodel.dart';
import '../auth/otp/otp_page.dart';
import '../auth/sign_up/signup_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../screen/bottom_nav/dashboard_page.dart';
import '../setting/page/DarkThemePreference.dart';

class AuthenticationManager extends GetxController with CacheManager {
  GoogleSignInAccount? _currentUser;
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    update();
  }

  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> handleSignIn(BuildContext context) async {
    try {
      _currentUser = await googleSignIn.signIn();
      if (_currentUser != null) {
        socialCheck(_currentUser!.email, context);
      }
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      // print(error);
    }
  }

  Future<void> handleSignOut() => googleSignIn.signOut();
  late FirebaseMessaging _firebaseMessaging;
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _firebaseMessaging = FirebaseMessaging.instance;
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
    getFcmTokenFrom();
  }

  /*get device token from firebase service*/
  void getFcmTokenFrom() async {
    _firebaseMessaging.getToken().then((token) {
      saveFcmToken(token);
      print('token: $token');
    }).catchError((err) {
      print("This is bug from FCM${err.message.toString()}");
    });
    FirebaseMessaging.onMessage.listen(
      (event) {
        // notificationCount=notificationCount+1;
        print('Notification is come');
      },
    );
  }

  Future<void> sendOtp({required context, required mobile}) async {
    loading(true);
    Map requestBody = {
      "phone": mobile,
    };
    UserModel? response = await apiService.sendOtp(requestBody);
    loading(false);
    if (response?.result == 'success') {
      UiHelper.showSnakbarSucess(
          context, response?.message ?? "Something wrong");
      Get.to(() => OtpPage(
            mobile: mobile,
          ));
    } else {
      UiHelper.showSnakbarMsg(context, response?.message ?? "Something wrong");
    }
  }

  Future<void> socialCheck(String email, BuildContext context) async {
    loading(true);
    Map req = {
      "email": email,
    };
    NewUserModel? res = await apiService.socialLogin(req);
    loading(false);
    if (res!.status == "old") {
      login(email, "", context);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => RegisterScreen(
                    email: email,
                  )),
          (route) => false);
    }
  }

  Future<void> login(String email, String phone, BuildContext context) async {
    var tempToken = "";
    if (getFcmToken() == null) {
      _firebaseMessaging.getToken().then((token) {
        tempToken = token ?? "";
      }).catchError((err) {});
    }

    loading(true);
    Map requestBody = {
      "phone": phone,
      "email": email,
      "deviceID": (await PlatformDeviceId.getDeviceId),
      "deviceToken": getFcmToken() ?? tempToken,
      "deviceType": Platform.isAndroid ? "Android" : "IOS",
    };
    UserModel? response = await apiService.login(requestBody);
    loading(false);

    if (response!.result == 'success') {
      if (response.user?.loginEnabled == 1) {
        setProfileData(
            name: response.user?.name?.toString() ?? "",
            username: response.user?.id?.toString() ?? "",
            email: email,
            profile: response.user!.image.toString(),
            mobile: response.user?.phone ?? "");

        saveToken(response.token.toString());
        /*  prefs.setString('dob', response.user?.dateOfBirth ?? "");
          prefs.setInt('state_id', response.user?.stateId ?? 0);
          prefs.setInt('city_id', response.user!.cityId ?? 0);
          prefs.setString('slug', response.user!.slug.toString());*/
        Get.offNamedUntil(DashboardPage.routeName, (route) => false);
      }
      UiHelper.showSnakbarSucess(
          context, response.message ?? "Your account has been disabled.");
      return;
    }
  }

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  ///finding device type
  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo)!;
        apiService.saveDeviceInfo(
            deviceToken: getFcmToken() ?? "",
            deviceName: deviceData['model'],
            deviceType: "Android",
            ipAddress: "",
            osVersion: deviceData['version.release']);

        /* homeController.mandatoryUpdateContr(
          int.parse(_packageInfo.buildNumber),
          "Android",
          context,
        );*/
      }
    } on PlatformException {
      Fluttertoast.showToast(msg: "Failed to get Platform version");
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  ///Getting Device Info
  Map<String, dynamic>? _readAndroidBuildData(AndroidDeviceInfo build) {
    try {
      return <String, dynamic>{
        'version.release': build.version.release,
        'model': build.model,
        'androidId': build.id,
      };
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to get Platform version" + e.toString());
    }
  }

  final isLogged = false.obs;

  bool isLogin() {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
    } else {
      isLogged.value = false;
    }
    return isLogged.value;
  }
}
