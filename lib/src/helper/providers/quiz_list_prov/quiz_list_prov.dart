import 'package:english_madhyam/src/helper/model/all_category.dart';
import 'package:english_madhyam/src/helper/model/quiz_list/quiz_list.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizListProvider extends GetConnect{
  HttpService _httpService=HttpService();
  static ApiBaseHelper _apiBaseHelper=ApiBaseHelper();

  Future<QuizListing?> getQuizList({required String type, int ?editorial_id,required String id,int ?page}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "type":type,
      "editorial_id":editorial_id,
      "category_id":id,
      "page":page
    };
    print(requestBody);
    final response = await _apiBaseHelper.post('dev/exam_list', requestBody);
    print(response);
    try {



      return QuizListing.fromJson(response);
    } catch (e) {

      _httpService.showExceptionToast();
      return null;
    }
  }
  Future<GetAllQuizCategory?> getQuizCategoryList({required String page}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "page":page

    };
    final response = await _apiBaseHelper.post('getAllCategories', requestBody);
    try {


      return GetAllQuizCategory.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}