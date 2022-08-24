import 'package:english_madhyam/src/helper/model/editorials_model/getcoursesmodel.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditorialProvider extends GetConnect{
  HttpService _httpService=HttpService();
  static ApiBaseHelper _apiBaseHelper=ApiBaseHelper();
  Future<GetCoursesModel?> getcourses({String? date,required String page}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "date":date,
      "page":page
    };
    final response = await _apiBaseHelper.post('get_editorials', requestBody);
    try {


      return GetCoursesModel.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}