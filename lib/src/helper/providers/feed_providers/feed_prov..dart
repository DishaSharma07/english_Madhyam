import 'package:english_madhyam/src/helper/model/editorials_model/getcoursesmodel.dart';
import 'package:english_madhyam/src/helper/model/feed_model/feed_model.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedProvider extends GetConnect{
  HttpService _httpService=HttpService();
  static ApiBaseHelper _apiBaseHelper=ApiBaseHelper();

  //
  Future<FeedModel?> getFeed({String? type,required String date}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "type":type,
      "date":date
    };
    final response = await _apiBaseHelper.post('daily_learnings', requestBody);
    try {


      return FeedModel.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}