import 'package:dio/dio.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/resrc/models/model/apply_coupon_model.dart';
import 'package:english_madhyam/resrc/models/model/coupon_list_ldel.dart';
import 'package:english_madhyam/resrc/models/model/purchase_history_model.dart';
import 'package:english_madhyam/resrc/models/model/succes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';
import 'package:english_madhyam/resrc/helper/api_repository/exceptions.dart'
    as apiExceptions;

import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';

class PaymentController extends GetxController {
  RxBool loading = false.obs;
  RxBool applyCouponloading = false.obs;
  RxBool CouponListloading = false.obs;
  RxBool purchaseloading = false.obs;
  Rx<Success> checkPayment = Success().obs;
  Rx<String> couponCode = "".obs;
  RxBool applied = false.obs;
  Rx<ApplyCoupon> applyCoupon = ApplyCoupon().obs;
  Rx<CouponList> couponListcontr = CouponList().obs;
  Rx<PurchaseHistoryModel> purchasehistory = PurchaseHistoryModel().obs;
  var globalsubscription = "".obs;
  var tabIndex = 0;

  @override
  void onInit() {
    super.onInit();
    profileDataFetch();
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  Future<void> profileDataFetch() async {
    try {
      loading(true);
      var response = await apiService.profileGetApi();
      loading(false);
      if (response != null) {
        globalsubscription.value = response.user!.isSubscription.toString();
        print(response.user!.isSubscription);
        if (response.user!.isSubscription.toString() == "Y") {
          changeTabIndex(0);
        } else {
          changeTabIndex(1);
        }
      }
    } catch (e) {
      loading(false);
    }
  }

  Future<Success?> confirmPayment(
      {required String amount,
      required String pay,
      required String PlanID,
      required String paymentMethod}) async {
    loading(true);
    var response = await apiService.checkPAyment(
        amount: amount, pay: pay, planId: PlanID, paymentMethod: paymentMethod);
    loading(false);
    if (response?.result == true) {
      checkPayment.value = response!;
      return response;
    } else {
      Fluttertoast.showToast(msg: response?.message ?? "");
      cancel();
      return response;
    }
  }

  void applyCouponContr(
      {required String PlanID, required String Coupon}) async {
    try {
      applyCouponloading(true);

      var response =
          await apiService.applyCoupon(plan_id: PlanID, coupon: Coupon);
      if (response != null) {
        if (response.result == true) {
          applyCoupon.value = response;
          couponCode.value = Coupon;
          Fluttertoast.showToast(msg: "Wohoo!! Coupon Applied");
          cancel();
          Get.back();
        } else {
          _vibrateDevice();
          _showCouponNotAppliedPopup(response.message.toString());
          // Fluttertoast.showToast(msg: response.message.toString());
          cancel();
        }
      } else {
        _vibrateDevice();
        _showCouponNotAppliedPopup(response!.message.toString());
        cancel();
        return null;
      }
    } on DioError catch (e) {
      // Handle Dio-specific errors, including 400 responses
      if (e.response != null && e.response!.statusCode == 400) {
        print('Bad Request: ${e.response!.data}');
        // Handle the 400 response accordingly
        _vibrateDevice();
        _showCouponNotAppliedPopup(e.response!.data['message'].toString());
        applyCouponloading(false);
      } else {
        print('Error during HTTP request: $e');
        _vibrateDevice();
        _showCouponNotAppliedPopup(e.response!.data['message'].toString());
        applyCouponloading(false);
        // Handle other Dio errors
      }
    } catch (e) {
      // Handle any other exceptions that occur during the request
      print('Error during HTTP request: $e');
      apiExceptions.ClientException error = e as apiExceptions.ClientException;
      _vibrateDevice();
      _showCouponNotAppliedPopup(e.message.toString());
      applyCouponloading(false);
    }
  }

  void _vibrateDevice() async {
    if (await Vibration.hasVibrator() != null) {
      print("vibrator");
      Vibration.vibrate(duration: 500);
    }
  }

  void _showCouponNotAppliedPopup(String message) {
    Fluttertoast.showToast(
        msg: "Coupon not applied: $message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  //Coupon List Controller
  void CouponListContr() async {
    try {
      CouponListloading(true);
      var response = await apiService.couponList();
      if (response != null) {
        if (response.result == true) {
          couponListcontr.value = response;
        } else {
          Fluttertoast.showToast(msg: response.message.toString());
          cancel();
        }
      } else {
        return null;
      }
    } catch (e) {
    } finally {
      CouponListloading(false);
    }
  }

  void purchaseHistory() async {
    try {
      purchaseloading(true);
      var response = await apiService.purchaseHistory();
      purchaseloading(false);

      if (response != null) {
        if (response.result == "success") {
          purchasehistory.value = response;
        } else {
          Fluttertoast.showToast(msg: response.message.toString());
          cancel();
        }
      } else {
        return null;
      }
    } catch (e) {
      purchaseloading(false);

    } finally {
      purchaseloading(false);
    }
  }
}
