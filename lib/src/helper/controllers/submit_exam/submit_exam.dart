import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/submit_exam/submit_exam.dart';
import 'package:english_madhyam/src/helper/providers/submit_exam/submit_exam_prov.dart';
import 'package:english_madhyam/src/screen/practice/performance_report.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubmitExamController extends GetxController{
  RxBool loading =true.obs;
  Rx<SubmitExam>submit=SubmitExam().obs;



  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();

  }

   SubmitControl({required String catId,required String eid,required String data,required String id,required String time,required int route,required String title})async {
    try{
      loading(true);
      var response=await SubmitExamProvider().submitExam(examData: data,examId:id ,remainTime:time );
      if(response!=null){
        Fluttertoast.showToast(msg: response.message.toString());
        cancel();

        Get.off(()=>PerformanceReport(
          id: id,
          eid: eid,
          catid: catId,
          Route: route,
          title: title,
        ),);
        return submit.value=response;


      }else {
        return null;
      }

    }catch(e){
    }   finally{
      loading(false);
    }
  }


}