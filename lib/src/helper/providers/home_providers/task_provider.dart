import 'dart:io';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/home_model/home_model.dart';
import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskProvider extends GetConnect {
  static ApiBaseHelper _apiHelper = ApiBaseHelper();
  String _userID = '0';
  String _token = '';
  String _deviceId = '';
  String _deviceToken = '';
  String _deviceType = 'web';

//saving user data in Shared prefer.
  Future _init() async {
    final _prefs = await SharedPreferences.getInstance();
    int _id = _prefs.getInt('userID') ?? 0;
    _userID = _id.toString();
    _token = _prefs.getString('token') ?? "";
    _deviceToken = _prefs.getString("deviceToken") ?? "";

    _deviceId = (await PlatformDeviceId.getDeviceId)!;
    if (Platform.isAndroid) {
      _deviceType = 'Android';
    } else if (Platform.isIOS) {
      _deviceType = 'IOS';
    }
  }

//Exception Toast
  static showExceptionToast(String mssg) {
    Fluttertoast.showToast(msg: mssg, timeInSecForIosWeb: 10);
    cancel();

  }

  //Fetch Home Page data

  Future<HomeApiModel?> HomeApi({required String DeviceId}) async {
    await _init();
    Map requestBody = {
      "token": _token,
      "device_id":DeviceId
    };
    final response = await _apiHelper.post('home', requestBody);
    try {

      return HomeApiModel.fromJson(response);
    }on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry",
          timeInSecForIosWeb: 20);
      cancel();
    }
    catch (e) {
      showExceptionToast('Something went wrong');
      return null;
    }
  }
}
