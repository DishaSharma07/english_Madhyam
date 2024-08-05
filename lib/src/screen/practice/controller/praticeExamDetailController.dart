import 'dart:convert';

import 'package:english_madhyam/resrc/models/model/graph_data/graph_data_model.dart';
import 'package:english_madhyam/resrc/models/model/quiz_details.dart';
import 'package:english_madhyam/resrc/utils/ui_helper.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/auth/sign_up/model/signup_model.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import '../../../commonController/authenticationController.dart';
import '../attemptedQuizPage.dart';

class PraticeExamDetailController extends GetxController {
  Rx<ExamDetails> quizDetail = ExamDetails().obs;
  RxString pauseMessage = "resume".obs;
  RxString message = "".obs;
  var quizId = 0.obs;
  var loading = true.obs;
  var loadingQuestion = false.obs;
  var selectedQuestion=0.obs;
  var selectedOption=0.obs;
  var selectedOptionIndex=0.obs;

  Rx<GraphData> graphdata = GraphData().obs;
  Rx<double> percentage = 0.0.obs;
  var dataLoaded=false.obs;

  List<MyExamData> myExamList=[];

  final AuthenticationManager _authManager=Get.find();

  Future<GraphData?> graphDataFetch({required String examId}) async {
    try {
      dataLoaded.value = true;
      var response = await apiService.graphData(examId: examId);

      if (response != null) {
        graphdata.value = response;
        pieChart();
        update();
        dataLoaded(false);
        return graphdata.value;
      }else{
        dataLoaded(false);
      }
    } catch (e) {
      loading(false);
    }
  }
  Future<bool> reportQuiz(dynamic requestBody) async {
    loading(true);
    bool? response = await apiService.reportQuestion(requestBody);
    loading(false);
    if (response == true) {

      Fluttertoast.showToast(
          msg: "Successfully reported");
    } else {
      Fluttertoast.showToast(
          msg: "Error Ocuured");
    }
    return  response;
  }

  ///navigation between questions
  goToQuestion(int i) {
    if (i <  quizDetail.value.content!.examQuestion!.length && i >= 0) {
        selectedQuestion.value = i;
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }
  /// remove answer to particular question
  removeAnswer(int i) async {
    if (i < quizDetail.value.content!.examQuestion!.length && i >= 0) {
      for (int k = 0; k < quizDetail.value.content!.examQuestion![i].options!.length; k++) {
        quizDetail.value.content!.examQuestion![i].options![k].checked = 0;
      }

        quizDetail.value.content!.examQuestion![i].isAttempt = 0;
        quizDetail.value.content!.examQuestion![i].ansType = 0;
        selectedOption.value=0;
        selectedOptionIndex.value=0;

    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }


  double pieChart() {
    int unanswered = (graphdata.value.content!.totalQuestion! -
        graphdata.value.content!.skipQuestion!);
    percentage.value =
        (unanswered / graphdata.value.content!.totalQuestion!) * 100;

    return percentage.value;
  }


  void getQuizDetailApi(int? id) {
    if (id != null) {
      quizId.value = id;
      quizzesDetails();
    }
  }

  void quizzesDetails({
    int? route,
    String? title,
  }) async {
    try {
      loading(true);
      var response = await apiService.getQuizDetails(examId: quizId.value);
      loading(false);
      if (response != null) {
        print(response.result);
        quizDetail.value = response;

        if (route != null) {
          Get.to(() => AttemptedQuizPage(
            examDetails: quizDetail.value,
            reviewExam: true,
            title: title??"",
            type: route,
          ));
        }
      } else {
        Fluttertoast.showToast(msg: response!.message.toString());
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      loading(false);
    }
  }

  //Start Exam
  void startExam({required int id}) async {
    try {
      loading(true);
      var response = await apiService.startExam(examId: id);
      loading(false);
      if (response != null) {
        message.value = response.message!;
        pauseMessage.value = "resume";
      } else {
        return null;
      }
    } catch (e) {
    } finally {
      loading(false);
    }
  }

  //pause Exam
  Future<Map> pauseExam({required int id, required int left,required List<ExamQuestion> listData}) async {
    var responseJson={};
    myExamList.clear();
    for(int i=0;i<listData.length;i++){
      if(listData[i].options!=null && listData[i].isAttempt==1){
        myExamList.add(MyExamData(questionId: listData[i].id??0, optionId: listData[i].isSelect??0));
      }else{
        myExamList.add(MyExamData(questionId: listData[i].id??0, optionId: 0));
      }
    }
    var list = MyExamData.getListMap(myExamList);
    var requestBody = {
      "token": _authManager.getToken(),
      "exam_id": id,
      "time_left": left,
      "exam_data":list
    };
    loading(true);
    var response = await apiService.pauseExam(jsonEncode(requestBody));
    loading(false);
    if (response != null) {
      pauseMessage.value = response.message!;
      UiHelper.showSuccessMsg(null,  response.message??"");
      responseJson={"message":response.message??"","status":true};
    } else {
      responseJson={"message":"","status":false};
    }
    return responseJson;
  }



  //Question Attemopt
  Future<bool?> questionAttemptContr({
    required String id,
    required String left,
    required String questionId,
    required String oId,
  }) async {

    try {
      loadingQuestion(true);
      var response = await apiService.attemptQuestion(
          examId: id, timeLeft: left, questionId: questionId, optionSelect: oId);
      loadingQuestion(false);
      if (response != null) {
        message.value = response.message!;
        return true;
      } else {
        return false;
      }
    } catch (e) {
    } finally {
      loadingQuestion(false);
    }
  }
}

class MyExamData{
  int? questionId;
  int? optionId;
  MyExamData({required this.questionId,required this.optionId});

  Map<String, dynamic> toMap() {
    return {
      'question_Id': questionId,
      'option_id': optionId,
    };
  }

  static dynamic getListMap(List<dynamic> items) {
    if (items == null) {
      return null;
    }
    List<Map<String, dynamic>> list = [];
    items.forEach((element) {
      list.add(element.toMap());
    });
    return list;
  }
}
