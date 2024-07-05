import 'package:english_madhyam/resrc/models/model/quiz_list/quiz_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';

class PraticeExamListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool catLoading = false.obs;
  RxInt selectedPageIndex = 0.obs;

  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  late bool hasNextPage;
  //late int _pageNumber;
  int pageNumber = 1;
  ScrollController scrollController = ScrollController();
  ScrollController scrollCtr = ScrollController();

  var praticeExamList = [].obs;

  var subCategoryId="";


  RxString categoryy = "".obs;

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments!=null){
      getQuizListByCategory(isRefresh: false,cat: Get.arguments["childCategories"]);
    }

  }
  //start
  Future<void> getQuizListByCategory(
      {required String cat,required bool isRefresh}) async {
    subCategoryId=cat;
    pageNumber=1;
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }
    QuizListing? model =
    await apiService.getPracticeListExam(type: "daily", id: subCategoryId, page: pageNumber);
    if (model!.result == "success") {
      praticeExamList.clear();
      praticeExamList.addAll(model.content?.data??[]);
      if(model.content?.total!=null && pageNumber < model.content!.total!){
        pageNumber = pageNumber + 1;
        hasNextPage = true;
      }else{
        hasNextPage = false;
      }
      if (hasNextPage) {
        getPracticeChildLoadMore();
      }
      isFirstLoadRunning(false);
    } else {
      isFirstLoadRunning(false);
    }
  }

  Future<void> getPracticeChildLoadMore() async {
    scrollCtr.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollCtr.position.maxScrollExtent ==
              scrollCtr.position.pixels) {
        isLoadMoreRunning(true);
        try {
          QuizListing? model =
          await apiService.getPracticeListExam(type: "daily", id: subCategoryId, page: pageNumber);
          if (model!.result == "success") {

            print("load more---");
            print(model.content?.total);
            print(model.content?.lastPage);
            print(model.content?.currentPage);
            if(model.content?.total!=null && pageNumber < model.content!.total!){
              pageNumber = pageNumber + 1;
              hasNextPage = true;
            }else{
              hasNextPage = false;
            }
            print("has next page$hasNextPage");
            praticeExamList.addAll(model.content?.data??[]);
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

