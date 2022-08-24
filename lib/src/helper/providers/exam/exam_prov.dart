import 'package:english_madhyam/src/helper/model/quiz_details.dart';
import 'package:english_madhyam/src/helper/model/quiz_list/quiz_list.dart';
import 'package:english_madhyam/src/helper/model/succes.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamProvider extends GetConnect{
  HttpService _httpService=HttpService();
  static ApiBaseHelper _apiBaseHelper=ApiBaseHelper();

// Start Exam
  Future<Success?> startExam({required int examId}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "exam_id":examId
    };
    final response = await _apiBaseHelper.post('startExam', requestBody);
    try {
      return Success.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

  //Pause Exam
  Future<Success?> pauseExam({required int examId,required int timeLeft}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "exam_id":examId,
      "time_left":timeLeft
    };
    final response = await _apiBaseHelper.post('pause_exam', requestBody);
    try {
      return Success.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }



  //question Attempt
  Future<Success?> AttemptQue({required String examId,required String timeLeft,required String QuestionId,required String OptionSelect}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "exam_id":examId,
      "time_left":timeLeft,
      "question_id":QuestionId,
      "selected_option":OptionSelect
    };
    final response = await _apiBaseHelper.post('attempt_question', requestBody);
    try {
      return Success.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}