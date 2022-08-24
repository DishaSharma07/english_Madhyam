import 'package:english_madhyam/src/helper/model/quiz_list/quiz_list.dart';
import 'package:english_madhyam/src/helper/model/submit_exam/submit_exam.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmitExamProvider extends GetConnect{
  HttpService _httpService=HttpService();
  static ApiBaseHelper _apiBaseHelper=ApiBaseHelper();
  Future<SubmitExam?> submitExam({required String examId,required String examData,required String remainTime}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "examId":examId,
      "examData":examData,
      "time_left":remainTime,


    };
    final response = await _apiBaseHelper.post('submit_exam', requestBody);
    try {



      return SubmitExam.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}