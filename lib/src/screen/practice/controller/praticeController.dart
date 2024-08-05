import 'package:english_madhyam/resrc/models/model/all_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';

class PraticeController extends GetxController {
  var practiceListList = <PracticeQuizData>[].obs;
  var previousExamList = <PracticeQuizData>[].obs;

  var isFirstLoadRunning = false.obs;
  var isLoading = false.obs;

  var isLoadMoreRunning = false.obs;
  var tabIndex = 0.obs;
  late bool hasNextPage;

  //late int _pageNumber;
  int pageNumber = 1;
  ScrollController scrollController = ScrollController();
  ScrollController preScrollController = ScrollController();

  var practiceCategoryList = [].obs;
  var subCategoryId = "";

  void getSubCategories(parentId) {
    try {
      isFirstLoadRunning(true);
      apiService.getSubcategory(parentId: parentId).then((resp) {
        isFirstLoadRunning(false);
        if (resp!.data == "success") {
          practiceCategoryList.clear();
          practiceCategoryList.addAll(resp.subCategories ?? []);
        } else {
          isFirstLoadRunning(false);
        }
      }, onError: (err) {
        isFirstLoadRunning(false);
      });
    } catch (exception) {
      isFirstLoadRunning(false);
    }
  }

  //start
  Future<void> getPracticeChildListData(
      {required subCategoryId, required isRefresh}) async {
    subCategoryId = subCategoryId;
    pageNumber = 1;
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }
    GetAllQuizCategory? model = await apiService.getChildCategory(
        page: pageNumber.toString(), subCategoryId: subCategoryId);
    if (model!.data == "success") {
      practiceListList.clear();
      previousExamList.clear();
      List<PracticeQuizData>? list= model.childCategory?.where((data) => data.isPrevious == 0).toList();
      practiceListList.addAll(list??[]);
      List<PracticeQuizData>? list2= model.childCategory?.where((data) => data.isPrevious == 1).toList();
      previousExamList.addAll(list2??[]);
      if (model.total != null && pageNumber < model.total!) {
        hasNextPage = true;
      } else {
        hasNextPage = false;
      }
      pageNumber = pageNumber + 1;
      if (hasNextPage) {
        getPracticeChildLoadMore();
      }
      isFirstLoadRunning(false);
    } else {
      isFirstLoadRunning(false);
    }
  }

  Future<void> getPracticeChildLoadMore() async {
    scrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        try {
          GetAllQuizCategory? model = await apiService.getChildCategory(
              page: pageNumber.toString(), subCategoryId: subCategoryId);
          if (model!.data == "success") {
            if (model.total != null && pageNumber < model.total!) {
              hasNextPage = true;
            } else {
              hasNextPage = false;
            }
            pageNumber = pageNumber + 1;
            List<PracticeQuizData>? list= model.childCategory?.where((data) => data.isPrevious == 0).toList();
            practiceListList.addAll(list??[]);
            List<PracticeQuizData>? list2= model.childCategory?.where((data) => data.isPrevious == 1).toList();
            previousExamList.addAll(list2??[]);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  getMockList() {
    List<PracticeQuizData> filteredList =
        practiceListList.where((data) => data.isPrevious == 0).toList();
  }

//end
}
