import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/quiz_details.dart';
import 'package:english_madhyam/src/helper/providers/exam/exam_prov.dart';
import 'package:english_madhyam/src/helper/providers/exam_details/quiz_details_prov.dart';
import 'package:english_madhyam/src/screen/bottom_nav/bottom_nav.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuizDetailsController extends GetxController{
  RxBool loading =false.obs;
  Rx<ExamDetails>quizDetail=ExamDetails().obs;
  RxString pausemessage="resume".obs;

  RxString message="".obs;
  var examid = 0.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  void examids(int? id){
    if(id!=null){
      examid.value = id;
      quizzesDEtails();
    }
  }

  void quizzesDEtails()async {
    try{
      loading(true);
      var response=await QuizDetailsProvider().getQuizDetails(examId:examid.value);
      if(response!=null){
        quizDetail.value=response;
      }else {
        return null;
      }

    }catch(e){
    }   finally{
      loading(false);
    }
  }
  //Start Exam
  void startExam({required int id})async {
    try{
      loading(true);
      var response=await ExamProvider().startExam(examId: id);
      if(response!=null){
        message.value=response.message!;
       pausemessage.value="resume";
      }else {
        return null;
      }

    }catch(e){
    }   finally{
      loading(false);
    }
  }

  //pause Exam
  void pauseExam({required int id,required int left})async {
    try{
      loading(true);
      var response=await ExamProvider().pauseExam(examId: id,timeLeft: left);
      if(response!=null){
        pausemessage.value=response.message!;

        Fluttertoast.showToast(msg: pausemessage.value);
        cancel();

      }else {
        return null;
      }

    }catch(e){
    }   finally{
      loading(false);
    }
  }

  //Question Attemopt
  void QuestionAttemptContr({required String id,required String left,required String QId,required String OId,})async {
    try{
      loading(true);
      var response=await ExamProvider().AttemptQue(examId: id, timeLeft: left, QuestionId: QId, OptionSelect: OId);
      if(response!=null){
        message.value=response.message!;
        // Fluttertoast.showToast(msg: "Question /*/Saved");
      }else {
        return null;
      }

    }catch(e){
    }   finally{
      loading(false);
    }
  }

}