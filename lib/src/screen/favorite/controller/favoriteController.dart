import 'package:english_madhyam/resrc/utils/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import '../model/questionDataModel.dart';
import '../model/wardDataModel.dart';

class FavoriteController extends GetxController {
  var saveQuestionList = <QuestionData>[].obs;
  var saveWordsList = <WordData>[].obs;
  Rx<bool> isSavedQuestionNavigation = false.obs;

  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void getSaveQuestionList(String categoryId) {
    try {
      loading(true);
      apiService.getSavedQuestionList(categoryId: categoryId).then((resp) {
        loading(false);
        if (resp!.result ?? false) {
          saveQuestionList.clear();
          saveQuestionList.addAll(resp.questionsList ?? []);
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  void getSaveWordsList() {
    try {
      loading(true);
      apiService.getSaveWordsListApi().then((resp) {
        loading(false);
        if (resp!.result ?? false) {
          saveWordsList.clear();
          saveWordsList.addAll(resp.wordsList ?? []);
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  Future<void> removeWordsFromList(
      {required BuildContext context, required String wordId}) async {
    try {
      loading(true);
      apiService.removeWordsFromListApi(wordId: wordId).then((resp) {
        loading(false);
        if (resp!.result ?? false) {
        } else {
          UiHelper.showSnakbarMsg(context, resp?.message ?? "");
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  Future<void> removeQuestionFromList(
      {required BuildContext context, required String questionId}) async {
    try {
      loading(true);
      apiService.removeQuestionFromListApi(questionId: questionId).then((resp) {
        loading(false);
        if (resp!.result ?? false) {
        } else {
          UiHelper.showSnakbarMsg(context, resp?.message ?? "");
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  Future<void> saveWordsToList(
      {required BuildContext context, required String wordId}) async {
    try {
      loading(true);
      apiService.saveWordsToListApi(wordId: wordId).then((resp) {
        loading(false);
        if (resp!.result == true) {
        } else {
          UiHelper.showSnakbarMsg(context, resp?.message ?? "");
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  Future<void> saveQuestionToList(
      {required BuildContext context, required String questionId}) async {
    try {
      loading(true);
      apiService.saveQuestionToListApi(questionId: questionId).then((resp) {
        loading(false);
        if (resp!.result == true) {
          /*Get.showSnackbar(
            GetSnackBar(
              title: "Alert",
              snackPosition: SnackPosition.TOP,
              message: resp?.message.toString()??"",
              duration: const Duration(seconds: 3),
            ),
          );*/
        } else {
          UiHelper.showSnakbarMsg(context, resp?.message ?? "");
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }
}
