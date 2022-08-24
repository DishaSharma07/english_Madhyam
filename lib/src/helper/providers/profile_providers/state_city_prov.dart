import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/auth/sign_up/model/city_model.dart';
import 'package:english_madhyam/src/auth/sign_up/model/state_model.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileProvider extends GetConnect {
  static ApiBaseHelper _apiHelper = ApiBaseHelper();

//Exception Toast
  static showExceptionToast() {
    Fluttertoast.showToast(msg: 'Something Went Wrong', timeInSecForIosWeb: 10);
    cancel();

  }

//state list
  Future<StateModel?> state_api(
      {required String mobile,
      required String deviceT,
      required String deviceTOK,
      required String deviceID}) async {
    Map requestBody = {
      "deviceToken": deviceTOK,
      "deviceType": deviceT,
      "deviceID": deviceID,
      "phone": mobile
    };
    final response = await _apiHelper.post('getState', requestBody);
    try {
      return StateModel.fromJson(response);
    } catch (e) {
      showExceptionToast();
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
      showExceptionToast();
      return null;
    }
  }
}
