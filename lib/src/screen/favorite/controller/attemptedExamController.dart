import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import '../model/attemptedExamData.dart';

class AttemptedExamController extends GetxController {
  var previousExamList = <ExamParent>[].obs;

  var isFirstLoadRunning = false.obs;
  var isLoading = false.obs;

  var isLoadMoreRunning = false.obs;
  var tabIndex = 0.obs;
  late bool hasNextPage;
  int pageNumber = 1;
  ScrollController preScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getAttemptedExam(isRefresh: false);
  }

  //previous start
  Future<void> getAttemptedExam({required isRefresh}) async {
    pageNumber = 1;
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }
    AttemptedExamModel? model =
        await apiService.getAttemptedExam(page: pageNumber.toString());
    isFirstLoadRunning(false);
    if (model!.result == "success") {
      previousExamList.clear();
      previousExamList.addAll(model.data?.examParent ?? []);
      if (model.data?.total != null && pageNumber < model.data!.total!) {
        hasNextPage = true;
      } else {
        hasNextPage = false;
      }
      pageNumber = pageNumber + 1;
      if (hasNextPage) {
        getAttemptedExamMore();
      }
    } else {
      isFirstLoadRunning(false);
    }
  }

  Future<void> getAttemptedExamMore() async {
    preScrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          preScrollController.position.maxScrollExtent ==
              preScrollController.position.pixels) {
        isLoadMoreRunning(true);
        try {
          AttemptedExamModel? model =
              await apiService.getAttemptedExam(page: pageNumber.toString());
          if (model!.result == "success") {
            if (model.data?.total != null && pageNumber < model.data!.total!) {
              hasNextPage = true;
            } else {
              hasNextPage = false;
            }
            pageNumber = pageNumber + 1;
            previousExamList.addAll(model.data?.examParent ?? []);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }
//end
}
