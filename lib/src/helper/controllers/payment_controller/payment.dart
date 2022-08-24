import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/apply_coupon_model.dart';
import 'package:english_madhyam/src/helper/model/coupon_list_ldel.dart';
import 'package:english_madhyam/src/helper/model/purchase_history_model.dart';
import 'package:english_madhyam/src/helper/model/succes.dart';
import 'package:english_madhyam/src/helper/providers/payment_prov/payment_pro.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
class PaymentController extends GetxController{
  RxBool loading =false.obs;
  RxBool applyCouponloading =false.obs;
  RxBool CouponListloading =false.obs;
  RxBool purchaseloading =false.obs;
  // Rx<CreatePaymentModel>PaymentData=CreatePaymentModel().obs;
  Rx<Success>checkPayment=Success().obs;
  Rx<String>couponCode="".obs;
  RxBool applied=false.obs;
  Rx<ApplyCoupon>applyCoupon=ApplyCoupon().obs;
  Rx<CouponList>couponListcontr=CouponList().obs;
  Rx<PurchaseHistoryModel>purchasehistory=PurchaseHistoryModel().obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  // void CreatePayment({required String PlanID,String ?code})async {
  //   try{
  //     loading(true);
  //     var response=await PaymentProvider().createPAyment(plan_id: PlanID,code: code);
  //     if(response!=null){
  //       PaymentData.value=response;
  //     }else {
  //       return null;
  //     }
  //
  //   }catch(e){
  //   }   finally{
  //     loading(false);
  //   }
  // }
  void checkPaymentContr({required String amount,required String pay,required String PlanID,required String CouponCode})async {
    try{
      loading(true);
      var response=await PaymentProvider().checkPAyment(amount: amount,pay: pay,planId: PlanID,couponCode: CouponCode);
      if(response!=null){
      if(response.result==true){
        checkPayment.value=response;

      }

      }else {
        return null;
      }

    }catch(e){
    }   finally{
      loading(false);
    }
  }
  void applyCouponContr({required String PlanID,required String Coupon})async {
    try{
      applyCouponloading(true);
      var response=await PaymentProvider().applyCoupon(plan_id: PlanID,coupon: Coupon );
      if(response!=null){
      if(response.result==true){
        applyCoupon.value=response;
        couponCode.value=Coupon;
        Fluttertoast.showToast(
            msg: "Wohoo!! Coupon Applied");
        cancel();


        Get.back();

      }else{
        Fluttertoast.showToast(msg: response.message.toString());
        cancel();

      }

      }else {

        return null;
      }

    }catch(e){
    }   finally{
      applyCouponloading(false);
    }
  }
  //Coupon List Controller
  void CouponListContr()async {
    try{
      CouponListloading(true);
      var response=await PaymentProvider().couponList( );
      if(response!=null){
      if(response.result==true){
        couponListcontr.value=response;
      }else{
        Fluttertoast.showToast(msg: response.message.toString());
        cancel();

      }

      }else {

        return null;
      }

    }catch(e){
    }   finally{
      CouponListloading(false);
    }
  }
  void purchaseHistory()async {
    try{
      purchaseloading(true);
      var response=await PaymentProvider().purchaseHistory( );
      if(response!=null){
       if(response.result=="success"){
        purchasehistory.value=response;

      }else{
        Fluttertoast.showToast(msg: response.message.toString());
        cancel();

      }

      }else {

        return null;
      }

    }catch(e){
    }   finally{
      purchaseloading(false);
    }
  }


}