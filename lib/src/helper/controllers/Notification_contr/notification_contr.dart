import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/NotificationModel.dart';
import 'package:english_madhyam/src/helper/providers/_notification_prov.dart';
import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotifcationController extends GetxController {
  var notification_loading = false.obs;
  var notification_read = ReadedNotification().obs;
  RxInt unread_notification = 0.obs;
  RxBool clearAll_value=false.obs;
  Rx<NotificationModel> notificationdata = NotificationModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getNotification();
  }

  void getNotification() async {
    try {
      notification_loading(true);
      unread_notification.value = 0;
      var notificationresponse = await NotificationProvider().NotificanList();
      if (notificationresponse != null) {
        notificationdata.value = notificationresponse;
        for (int i = 0; i < notificationresponse.notification!.length; i++) {
          if (notificationresponse.notification![i].read == 0) {
            unread_notification++;
          } else {}
        }
        notificationresponse.notification!.where((element) {
          if (element.read == 0) {
            unread_notification++;
            return true;
          } else {
            return false;
          }
        });
      } else {
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry",
          timeInSecForIosWeb: 20);
      cancel();
    } finally {
      notification_loading(false);
    }
  }

  void readNotification({required String id}) async {
    try {
      notification_loading(true);
      var notificationresponse =
          await NotificationProvider().NotificanRead(notification_id: id);
      if (notificationresponse!.result != false) {
        notification_read.value = notificationresponse;
        getNotification();
      } else {
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry",
          timeInSecForIosWeb: 20);
      cancel();
    } finally {
      notification_loading(false);
    }
  }

  void clearAll() async {
    try {
      notification_loading(true);
      var clearNotification =
          await NotificationProvider().clearALlNotificationProvider();

      if (clearNotification != null) {
        clearAll_value.value=clearNotification.result!;
        if(clearNotification.result==true){
          getNotification();
        }
      }
    } catch (e) {
    } finally {
      notification_loading(false);

    }
  }
}
