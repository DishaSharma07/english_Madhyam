import 'dart:io';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/auth/log_out/log_out_model.dart';
import 'package:english_madhyam/src/auth/login/model/login_model.dart';
import 'package:english_madhyam/src/auth/login/model/new_usermodel.dart';
import 'package:english_madhyam/src/auth/otp/send_otp_model/send_otp.dart';
import 'package:english_madhyam/src/auth/sign_up/model/city_model.dart';
import 'package:english_madhyam/src/auth/sign_up/model/signup_model.dart';
import 'package:english_madhyam/src/auth/sign_up/model/state_model.dart';
import 'package:english_madhyam/src/helper/model/birthdayModel.dart';
import 'package:english_madhyam/src/helper/model/deviceinfo_model.dart';
import 'package:english_madhyam/src/helper/model/mandatoryupdate_model.dart';
import 'package:english_madhyam/src/helper/model/secondarywarning_model.dart';
import 'package:english_madhyam/src/helper/model/succes.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HttpService extends ApiBaseHelper {
  ApiBaseHelper _apiHelper = ApiBaseHelper();
  String _userID = '0';
  String _token = '';
  String _deviceId = '';
  String _deviceToken = '';
  String _deviceType = 'web';

  Future _init() async {
    final _prefs = await SharedPreferences.getInstance();
    int _id = _prefs.getInt('userID') ?? 0;
    _userID = _id.toString();
    _token = _prefs.getString('token') ?? "";
    _deviceToken = _prefs.getString("deviceToken") ?? "";

    _deviceId = _prefs.getString('device_id') ?? "";
    if (Platform.isAndroid) {
      _deviceType = 'Android';
    } else if (Platform.isIOS) {
      _deviceType = 'IOS';
    }
  }

  showExceptionToast({String? mssg}) async {
    Fluttertoast.showToast(
        msg: mssg == null ? 'Something Went Wrong' : mssg,
        timeInSecForIosWeb: 10);
    cancel();
  }

// Send OTP
  Future<SendOTP?> getSendOtp(reqBody) async {
    final response = await _apiHelper.post('send_otp_v2', reqBody);
    try {
      return SendOTP.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "OTP not Send ");
      return null;
    }
  }

  Future<NewUserModel?> isNewUser(String email, BuildContext context) async {
    Map req = {
      "email": email,
    };
    final response = await _apiHelper.post('is_new_user', req);
    try {
      return NewUserModel.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "Something went wrong");
      return null;
    }
  }

  //Verify OTP
  Future<SendOTP?> verify_otp(
      {required String mobile, required String OTP}) async {
    Map requestBody = {"phone": mobile, "otp": OTP};
    final response = await _apiHelper.post('verify_otp', requestBody);

    try {
      return SendOTP.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "OTP not verified");
      return null;
    }
  }
  Future<SecondaryWarningModel?> secondaryWarning(
    ) async {
    Map requestBody = {"package_id": "com.englishmadhyam"};
    final response = await _apiHelper.secondaryPost('https://www.teknikoglobal.com/home/get_application_status', requestBody);

    try {
      return SecondaryWarningModel.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "OTP not verified");
      return null;
    }
  }

  ///device  info
  Future<DeviceInfo?> device_info(
      {required String device_type,
      required String device_name,
      required String ip_address,
      required String os_version,
      required String device_token}) async {
    await _init();
    Map requestBody = {
      "token": _token,
      "device_type": device_type,
      "device_name": device_name,
      "ip_address": ip_address,
      "os_version": os_version,
      "device_token": device_token
    };
    final response = await _apiHelper.post('dev/device_info', requestBody);
    print(response.toString() + "DEVICE INFO API IS HERW +++++++++");

    try {
      return DeviceInfo.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "OTP not verified");
      return null;
    }
  }

//Login API
  Future<UserModel?> Login_api(
      {String? mobile,
      String? email,
      required String deviceT,
      required String deviceTOK,
      required String deviceID}) async {
    await _init();

    Map requestBody = {
      "phone": mobile,
      "email": email,
      "deviceID": deviceID,
      "deviceToken": deviceTOK,
      "deviceType": deviceT,
    };
    final response = await _apiHelper.post('login_v2', requestBody);

    try {
      return UserModel.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "Troubling in Login");
      return null;
    }
  }

  //state list
  Future<StateModel?> state_api() async {
    Map requestBody = {};
    final response = await _apiHelper.post('getState', requestBody);
    try {
      return StateModel.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "");
      return null;
    }
  }

  Future<MandatoryUpdate?> mandatoryUpdate() async {
    await _init();
    Map requestBody = {"token": _token};
    final response = await _apiHelper.post('app_version', requestBody);
    try {
      return MandatoryUpdate.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "");
      return null;
    }
  }
  ///warning popUp
  Future<Success?> warningPop() async {
    final response = await _apiHelper.get('app_msg');
    try {
      print("LEARN");
      return Success.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: e.toString());
      return null;
    }
  }

//City list
  Future<CityModel?> cityApi({
    required String State,
  }) async {
    Map requestBody = {
      "state_id": State,
    };
    final response = await _apiHelper.post('getCity', requestBody);
    try {
      return CityModel.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "");
      return null;
    }
  }

//Sign Up
  Future<SignUpModel?> signUpApi({
    required String State,
    required String name,
    required String date_of_birth,
    required String city_id,
    required String phone,
    String? email,
    required String deviceID,
    required String deviceToken,
    required String deviceType,
  }) async {
    await _init();

    Map requestBody = {
      "state_id": State,
      "name": name,
      "date_of_birth": date_of_birth,
      "city_id": city_id,
      "phone": phone,
      "email": email,
      "deviceID": deviceID,
      "deviceToken": deviceToken,
      "deviceType": deviceType,
    };
    final response = await _apiHelper.post('register_v2', requestBody);

    try {
      return SignUpModel.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "Can't be Register");
      return null;
    }
  }

  //Log OUT

  Future<LogOutModel?> logOutApi() async {
    await _init();

    Map requestBody = {
      "token": _token,
      "user_id": _userID,
      "deviceID": _deviceId,
    };
    final response = await _apiHelper.post('logout', requestBody);
    try {
      return LogOutModel.fromJson(response);
    } catch (e) {
      showExceptionToast(mssg: "Not logout");
      return null;
    }
  } //Log OUT

//Birthday APi
  Future<BirthDayModel?> BirthDay() async {
    await _init();

    Map requestBody = {
      "token": _token,
    };
    final response = await _apiHelper.post('birthday_details', requestBody);
    try {
      return BirthDayModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

//Home APi

}
