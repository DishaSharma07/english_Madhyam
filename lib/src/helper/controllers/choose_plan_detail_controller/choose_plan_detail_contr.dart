import 'package:english_madhyam/src/helper/model/choose_plan_model/choose_plan_model.dart';
import 'package:english_madhyam/src/helper/model/plan_detail/plan_detial.dart';
import 'package:english_madhyam/src/helper/providers/choose_plan_list/choose_plan_prov..dart';
import 'package:english_madhyam/src/helper/providers/plan_detail_prov/plan_detail_prov.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanDetailsController extends GetxController {
  RxBool loading=true.obs;
  RxInt groupValue = 0.obs;
  Rx<ChoosePlanModel>choosePlan=ChoosePlanModel().obs;
  Rx<PlanDetailModel>planDetails=PlanDetailModel().obs;
  ScrollController freeScrollController=ScrollController();
  ScrollController paidScrollController=ScrollController();
  int page = 1;
  var lstTask = List<dynamic>.empty(growable: true).obs;
  var lstTask2 = List<dynamic>.empty(growable: true).obs;

  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;


  @override
  void onInit()async {
    // TODO: implement onInit
    super.onInit();
    getPlanDetails();
    getTask(page);
    paginateTask();






  }

  void paginateTask() {
    freeScrollController.addListener(() {
      if (freeScrollController.position.pixels ==
          freeScrollController.position.maxScrollExtent) {
        page++;
        getMoreTask(page);
      }
    });
  }


  // Get More data
  void getMoreTask(int page) {
    try {
      ChoosePlanProvider().getCourseList(page: page.toString()).then((resp) {
        if (resp!.freeCategories!.data!.isNotEmpty) {
          isMoreDataAvailable(true);

        } else {
          isMoreDataAvailable(false);

          // showSnackBar("Message", "No more items", Colors.lightBlueAccent);
        }
        lstTask.addAll(resp.freeCategories!.data!);
        lstTask2.addAll(resp.paidCategories!.data!);

      }, onError: (err) {
        isMoreDataAvailable(false);
      });
    } catch (exception) {
      isMoreDataAvailable(false);
    }
  }
  void onClickRadioButton(value) {
    groupValue.value = value;
    update();


  }
  // Fetch Data
  void getTask(int page) {
    try {
      isMoreDataAvailable(false);
      isDataProcessing(true);
      ChoosePlanProvider().getCourseList(page: page.toString()).then((resp) {
        isDataProcessing(false);
        lstTask.addAll(resp!.freeCategories!.data!);
        lstTask2.addAll(resp.paidCategories!.data!);

      }, onError: (err) {
        isDataProcessing(false);
      });
    } catch (exception) {
      isDataProcessing(false);
    }
  }
  void getPlanlist({required String page}) async {
    try {
      loading(true);
      var response = await ChoosePlanProvider().getCourseList(page: page);

      if (response != null) {


        if(choosePlan.value.freeCategories!=null){
          PaidCategories free=response.freeCategories!;
          choosePlan.value.freeCategories!.data!.addAll(response.freeCategories!.data!);
        }else{
          choosePlan.value.freeCategories=response.freeCategories;
        }

        update();


      } else {

        return null;
      }
    } catch (e) {
    }
    finally{
      loading(false);
    }

  }
  void getPlanDetails() async {

    try {
      loading(true);
      var response = await PlanDetailProvider().getPlanDetails();

      if (response != null) {
        planDetails.value = response;

      } else {

        return null;
      }
    } catch (e) {
    }
    finally{
      loading(false);
    }

  }
}
