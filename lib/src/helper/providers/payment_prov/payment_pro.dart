import 'package:english_madhyam/src/helper/model/apply_coupon_model.dart';
import 'package:english_madhyam/src/helper/model/choose_plan_model/create_payment.dart';
import 'package:english_madhyam/src/helper/model/coupon_list_ldel.dart';
import 'package:english_madhyam/src/helper/model/purchase_history_model.dart';
import 'package:english_madhyam/src/helper/model/succes.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentProvider extends GetConnect{
  HttpService _httpService=HttpService();
  static ApiBaseHelper _apiBaseHelper=ApiBaseHelper();

  Future< Success?> checkPAyment({required String amount,required String pay,required planId,required couponCode}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "amount":amount,
      "txn_id":pay,
      "plan_id":planId

     };
    final response = await _apiBaseHelper.post('check_payment', requestBody);
    try {


      return Success.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }
  //Apply Coupon
  Future< ApplyCoupon?> applyCoupon({required String plan_id,required String coupon}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "coupon_code":coupon,
      "plan_id":plan_id,
    };
    final response = await _apiBaseHelper.post('apply_coupon', requestBody);
    try {


      return ApplyCoupon.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }
  //Coupon List
  Future< CouponList?> couponList() async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),

    };
    final response = await _apiBaseHelper.post('coupons_list', requestBody);
    try {


      return CouponList.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }
  Future< PurchaseHistoryModel?> purchaseHistory() async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),

    };
    final response = await _apiBaseHelper.post('purchase_history', requestBody);
    try {


      return PurchaseHistoryModel.fromJson(response);
    } catch (e) {

      _httpService.showExceptionToast();
      return null;
    }
  }


}