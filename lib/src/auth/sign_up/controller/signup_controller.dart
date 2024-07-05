import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import 'package:english_madhyam/resrc/utils/ui_helper.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/storage/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../screen/bottom_nav/dashboard_page.dart';
import '../../otp/send_otp_model/send_otp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../model/city_model.dart';
import '../model/signup_model.dart';
import '../model/state_model.dart';
import '../signup_screen.dart';

class SignupController extends GetxController with CacheManager {
  GoogleSignInAccount? _currentUser;

  var states = <StateList>[].obs;
  var cities = <CityList>[].obs;

  GoogleSignIn googleSignIn = GoogleSignIn();
  final AuthenticationManager authenticationController = Get.find();

  Future<void> handleSignOut() => googleSignIn.signOut();
  late FirebaseMessaging _firebaseMessaging;
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _firebaseMessaging = FirebaseMessaging.instance;
  }

  Future<void> signup(dynamic requestBody) async {
    loading(true);
    SignUpModel? response = await apiService.signup(requestBody);
    loading(false);
    if (response?.result == 'success') {
      setProfileData(
          name: response?.user?.name?.toString() ?? "",
          username: response?.user?.id?.toString() ?? "",
          email: response?.user?.email?.toString() ?? "",
          profile: response?.user?.image.toString() ?? "",
          mobile: response?.user?.phone ?? "");
      saveToken(response?.token.toString());
      Get.offNamedUntil(DashboardPage.routeName, (route) => false);
    } else {
      Fluttertoast.showToast(
          msg: response!.message! + '      ${response.result!}');
    }
  }

  Future<void> otpVerify(
      {required context, required String mobile, required String otp}) async {
    loading(true);
    Map requestBody = {"phone": mobile, "otp": otp};
    SendOTP? res = await apiService.verifyOtp(requestBody);
    loading(false);
    if (res?.result == "success") {
      if (res?.status == "old") {
        authenticationController.login("", mobile, context);
      } else {
        try {
          UiHelper.showSnakbarSucess(context, res?.message ?? "");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RegisterScreen(
                        mobile: mobile,
                      )),
              (route) => route.isFirst);
        } catch (e) {
          UiHelper.showSnakbarMsg(context, e.toString());
        }
      }
    } else {
      UiHelper.showSnakbarMsg(context, res?.message ?? "");
    }
  }
}
