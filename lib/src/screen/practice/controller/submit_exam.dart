import 'package:english_madhyam/resrc/models/model/submit_exam/submit_exam.dart';
import 'package:english_madhyam/resrc/utils/ui_helper.dart';
import 'package:english_madhyam/src/screen/practice/performance_report.dart';
import 'package:get/get.dart';

import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';

class SubmitExamController extends GetxController {
  RxBool loading = false.obs;
  Rx<SubmitExam> submit = SubmitExam().obs;

  Future<void> submitControl(
      {required String catId,
      required String eid,
      required String data,
      required String id,
      required String time,
      required int route,
      required String title}) async {
    loading(true);
    var response = await apiService.submitExam(
        examData: data, examId: id, remainTime: time);
    loading(false);
    if (response != null) {
      UiHelper.showSuccessMsg(null, response.message.toString());
      print("this is sumit ---");
      Get.off(
            () => PerformanceReport(
          id: id,
          eId: eid,
          catId: catId,
          route: 3,
          title: title,
        ),
      );
      submit.value = response;
    } else {
    }
  }
}
