import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/NotificationModel.dart';
import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationProvider extends GetConnect {
  HttpService _httpService = HttpService();
  static ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  static showExceptionToast(String mssg) {
    Fluttertoast.showToast(msg: mssg, timeInSecForIosWeb: 10);
    cancel();

  }
  Future<NotificationModel?> NotificanList() async {
    final prefs = await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
    };
    print(requestBody);

    final response =
        await _apiBaseHelper.post('notification_list', requestBody);
    print(response);

    try {
      return NotificationModel.fromJson(response);
    } on NetworkException{
      showExceptionToast('Data is not Available');
    }catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

  Future<ReadedNotification?> NotificanRead(
      {required String notification_id}) async {
    final prefs = await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "notification_id": notification_id
    };

    final response =
        await _apiBaseHelper.post('read_notification', requestBody);
    try {
      return ReadedNotification.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

  Future<ReadedNotification> clearALlNotificationProvider() async {
    final prefs = await SharedPreferences.getInstance();
    Map requestBody = {"token": prefs.getString("token")};
    final respo = await _apiBaseHelper.post("clear_notification", requestBody);
    return ReadedNotification.fromJson(respo);
  }
}

class ReadedNotification {
  bool? result;

  ReadedNotification({this.result});

  ReadedNotification.fromJson(Map<String, dynamic> json) {
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    return data;
  }
}
