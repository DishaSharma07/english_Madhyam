import 'package:english_madhyam/src/helper/model/plan_detail/plan_detial.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanDetailProvider extends GetConnect{
  final HttpService _httpService=HttpService();
  static final ApiBaseHelper _apiBaseHelper=ApiBaseHelper();

  //plan list
  Future<PlanDetailModel?> getPlanDetails() async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
    };
    final response = await _apiBaseHelper.post('subscription_plans', requestBody);
    try {


      return PlanDetailModel.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}