import 'package:english_madhyam/src/helper/model/all_category.dart';
import 'package:english_madhyam/src/helper/model/quiz_list/quiz_list.dart';
import 'package:english_madhyam/src/helper/providers/quiz_list_prov/quiz_list_prov.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class QuizListController extends GetxController {
  RxBool loading = true.obs;
  RxBool catloading = false.obs;
  RxInt selectedPageIndex=0.obs;
  Rx<PageController>pageC=PageController().obs;
  Rx<QuizListing> quizList = QuizListing().obs;
  Rx<GetAllQuizCategory> quizCategoryList = GetAllQuizCategory().obs;
  var  quizListing = List<dynamic>.empty(growable: true).obs;
  var quizListingQuiz = List<dynamic>.empty(growable: true).obs;

  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;
  int page = 1;
  ScrollController editorialList=ScrollController();
  ScrollController quizListScroll=ScrollController();
  RxString categoryy="".obs;


  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
    getTask();
    paginateTask();
    paginateTaskQuiz();
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
  void getTaskQuiz({required String cat}) {
    try {
      isMoreDataAvailable(false);
      categoryy.value=cat;
      isDataProcessing(true);
      QuizListProvider().getQuizList(type: "daily",id:cat,page: page ).then((resp) {
        if(resp!.result=="success"){
          isDataProcessing(false);
          page=1;
    if(quizListingQuiz.isEmpty){
      quizListingQuiz.addAll(resp.content!.data!);
          }else if(quizListingQuiz[0]==resp.content!.data![0]){
      isMoreDataAvailable(false);
      isDataProcessing(false);
    }else{
      isMoreDataAvailable(false);
      isDataProcessing(false);
    }
          quizList.value=resp;
        }else{
          if( quizListingQuiz.isNotEmpty){

            quizListingQuiz.clear();
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
    }finally{
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
  void paginateTaskQuiz() {
    quizListScroll.addListener(() {
      if (quizListScroll.position.pixels ==
          quizListScroll.position.maxScrollExtent) {
        page++;
        getMoreTaskQuiz(page);
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
  void getMoreTaskQuiz(int pageCount) {
    print(categoryy.value);
    isDataProcessing(true);
    try {
      if(quizList.value.content!.total!>quizListingQuiz.length){
        QuizListProvider().getQuizList(type: "daily",id:categoryy.value,page: pageCount )
            .then((resp) {
print(resp.toString()+"4444444444444");
          if(resp!.result=="success"){
            if (resp.content!.data!.isNotEmpty) {
print("ADDED");
              quizListingQuiz.addAll(resp.content!.data!);
              isMoreDataAvailable(false);
              isDataProcessing(false);
              quizList.value=resp;

            } else {
              isMoreDataAvailable(false);
              isDataProcessing(false);
              page--;

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
    finally{
      isDataProcessing(false);

    }
  }

}
