import 'dart:async';
import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:get/get.dart';
import '../model/parentCategoryModel.dart';

class LibraryController extends GetxController {
  var loading = false.obs;
  final AuthenticationManager _authManager = Get.find();
  var parentCategories = <dynamic>[].obs;

  @override
  void onInit() {
    getParentCategory(isRefresh: false);
    super.onInit();
  }

  Future<void> getParentCategory({required bool isRefresh}) async {
    if(!isRefresh){
      loading(true);
    }
    loading(true);
    ParentCategoryModel model = await apiService.getParentCategory(page: "");
    loading(false);
    if (model?.data=="success") {
      parentCategories.clear();
      parentCategories.addAll(model.parentCategories ?? []);
      update();
    }
  }

}


