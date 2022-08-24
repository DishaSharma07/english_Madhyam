import 'package:english_madhyam/src/helper/model/all_category.dart';
import 'package:english_madhyam/src/helper/model/quiz_list/quiz_list.dart';
import 'package:english_madhyam/src/helper/providers/quiz_list_prov/quiz_list_prov.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizListController extends GetxController {
  RxBool loading = true.obs;
  RxBool catloading = false.obs;
  RxInt selectedPageIndex=0.obs;
  Rx<PageController>pageC=PageController().obs;
  Rx<QuizListing> quizList = QuizListing().obs;
  Rx<GetAllQuizCategory> quizCategoryList = GetAllQuizCategory().obs;
  var quizListing = List<dynamic>.empty(growable: true).obs;

  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;
  int page = 1;
  ScrollController editorialList=ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
    getTask();
    paginateTask();
  }

  void quizzesList({required String cat}) async {
    try {
      loading(true);
      var response = await QuizListProvider().getQuizList(type: "daily",id:cat );
      if (response != null) {
        quizList.value = response;
      } else {
         return null;
      }
    } catch (e) {
    } finally {
      loading(false);
    }
  }

  // void quizzesCategoryListContr() async {
  //   try {
  //     catloading(true);
  //     var response = await QuizListProvider().getQuizCategoryList(page: );
  //     print("response   ... .... ...${response}");
  //     if (response != null) {
  //       quizCategoryList.value = response;
  //       print("LENGTH   ==  ${quizCategoryList.value.data!.length}");
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     catloading(false);
  //   }
  // }

  void getTask() {
    try {
      isMoreDataAvailable(false);
      isDataProcessing(true);
      QuizListProvider().getQuizCategoryList(page:page.toString() ).then((resp) {
        if(resp!.data=="success"){
          isDataProcessing(false);
    if(quizListing.isEmpty){
            quizListing.addAll(resp.categories!.data!);
          }else if(quizListing[0]==resp.categories!.data![0]){
      isMoreDataAvailable(false);
      isDataProcessing(false);
    }else{
      isMoreDataAvailable(false);
      isDataProcessing(false);
    }
          quizCategoryList.value=resp;
        }else{
          if( quizListing.isNotEmpty){

              quizListing.clear();
              page=1;
              isDataProcessing(false);
              isMoreDataAvailable(false);
          }

          else {
            page = 1;
            isDataProcessing(false);
            isMoreDataAvailable(false);
          }}


      }, onError: (err) {
        isDataProcessing(false);
      });
    } catch (exception) {
      isDataProcessing(false);
    }
  }

  void paginateTask() {
    editorialList.addListener(() {
      if (editorialList.position.pixels ==
          editorialList.position.maxScrollExtent) {
        page++;
        getMoreTask(page);
      }
    });
  }
  void getMoreTask(int pageCount) {
    isDataProcessing(true);
    try {
      if(quizCategoryList.value.categories!.total!>quizListing.length){
        QuizListProvider().getQuizCategoryList(page:page.toString() )
            .then((resp) {

          if(resp!.data=="success"){
            if (resp.categories!.data!.isNotEmpty) {

              quizListing.addAll(resp.categories!.data!);
              isMoreDataAvailable(false);
              isDataProcessing(false);
              quizCategoryList.value=resp;

            } else {
              isMoreDataAvailable(false);
              isDataProcessing(false);

            }

          }else{
            isMoreDataAvailable(false);
            isDataProcessing(false);
            page--;
          }


        }, onError: (err) {
          isMoreDataAvailable(false);
          isDataProcessing(false);
        });
      }else{
        isDataProcessing(false);
        isMoreDataAvailable(false);
      }
    } catch (exception) {
      isMoreDataAvailable(false);
    }
  }
}
