import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import 'package:english_madhyam/resrc/models/model/choose_plan_model/choose_plan_model.dart';
import 'package:english_madhyam/resrc/models/model/plan_detail/plan_detial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commonController/authenticationController.dart';

class MaterialController extends GetxController {
  Rx<bool> isLoading= false.obs;
  Rx<int> groupValue = 0.obs;

  Rx<ChoosePlanModel>choosePlan=ChoosePlanModel().obs;
  Rx<PlanDetailModel>planDetails=PlanDetailModel().obs;

  ScrollController freeScrollController=ScrollController();
  ScrollController paidScrollController=ScrollController();

  final AuthenticationManager authController=Get.find();
  int page = 1;
  var materialCategoryList = [].obs;
  var materialChildList = [].obs;

  var isFirstLoadRunning = false.obs;
  var isMoreDataAvailable = true.obs;
  var planIdOneMonth="";
  var planIdThreeMonth="";
  var planIdOneYear="";
  var planIdSixMonth="";
  String subCateId="";

  @override
  void onInit()async {
    super.onInit();
  }
  void getMaterialCategory(String parentId) {
    try {
      isFirstLoadRunning(true);
      apiService.getSubcategory(parentId: parentId).then((resp) {
        isFirstLoadRunning(false);
        materialCategoryList.clear();
        materialCategoryList.addAll(resp?.subCategories??[]);
      }, onError: (err) {
        isFirstLoadRunning(false);
      });
    } catch (exception) {
      isFirstLoadRunning(false);
    }
  }

  void paginateTask() {
    freeScrollController.addListener(() {
      if (freeScrollController.position.pixels ==
          freeScrollController.position.maxScrollExtent) {
        page++;
        getLoadMoreMaterialList(page);
      }
    });
  }
  //used for load the material List
  void getLoadMoreMaterialList(int page) {
    try {
      apiService.getCourseList(page: page.toString(),subCateId:subCateId).then((resp) {
        if (resp?.childCategories!=null && resp!.childCategories!.isNotEmpty) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
        }
        materialChildList.addAll(resp?.childCategories??[]);
      }, onError: (err) {
        isMoreDataAvailable(false);
      });
    } catch (exception) {
      isMoreDataAvailable(false);
    }
  }

  Future<void> getMaterialList(int page,String subCateId) async {
    this.subCateId=subCateId;
    try {
      isMoreDataAvailable(false);
      isFirstLoadRunning(true);
      apiService.getCourseList(page: page.toString(),subCateId:subCateId).then((resp) {
        isFirstLoadRunning(false);
        materialChildList.clear();
        materialChildList.addAll(resp?.childCategories??[]);
        paginateTask();
      }, onError: (err) {
        isFirstLoadRunning(false);
      });
    } catch (exception) {
      isFirstLoadRunning(false);
    }
  }
  void onClickRadioButton(value) {
    groupValue.value = value;
    // update();
  }
  void getPlanDetails() async {
    isLoading(true);
    PlanDetailModel? response = await apiService.getPlanDetails();
    if (response != null) {
      planDetails.value = response;
      isLoading(false);

      if(planDetails.value.list!=null && planDetails.value.list!.isNotEmpty){
        planIdOneMonth=planDetails.value.list!.firstWhere((plan)=>plan.duration==1).id.toString();
        planIdThreeMonth=planDetails.value.list!.firstWhere((plan)=>plan.duration==3).id.toString();
        planIdSixMonth=planDetails.value.list!.firstWhere((plan)=>plan.duration==6).id.toString();
        planIdOneYear=planDetails.value.list!.firstWhere((plan)=>plan.duration==12).id.toString();

      }
    } else {
      isLoading(false);

      return null;
    }

  }
}
