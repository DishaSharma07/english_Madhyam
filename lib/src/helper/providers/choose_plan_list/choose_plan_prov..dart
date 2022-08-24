import 'package:english_madhyam/src/helper/model/choose_plan_model/choose_plan_model.dart';
import 'package:english_madhyam/src/helper/model/feed_model/feed_model.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChoosePlanProvider extends GetConnect{
  final HttpService _httpService=HttpService();
  static final ApiBaseHelper _apiBaseHelper=ApiBaseHelper();

  //plan list
  Future<ChoosePlanModel?> getCourseList({required String page}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "page":page
    };
    final response = await _apiBaseHelper.post('categoryTypeList', requestBody);
    try {


      return ChoosePlanModel.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}