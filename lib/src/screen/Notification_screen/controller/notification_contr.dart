import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import 'package:english_madhyam/resrc/models/model/NotificationModel.dart';
import 'package:get/get.dart';

class NotifcationController extends GetxController {
  var notification_loading = false.obs;
  var notification_read = ReadedNotification().obs;
  RxInt unread_notification = 0.obs;
  RxBool clearAll_value = false.obs;
  Rx<NotificationRespoModel> notificationdata = NotificationRespoModel().obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<dynamic> getNotification() async {
    try {
      notification_loading(true);
      unread_notification.value = 0;
      var notificationresponse = await apiService.notificationList();
      notification_loading(false);
      if (notificationresponse != null) {
        notificationdata.value = notificationresponse;
        if (notificationresponse.notification != null &&
            notificationresponse.notification!.isNotEmpty) {
          for (int i = 0; i < notificationresponse.notification!.length; i++) {
            if (notificationresponse.notification![i].read == 0) {
              unread_notification++;
            }
          }
          notificationresponse.notification!.where((element) {
            if (element.read == 0) {
              unread_notification++;
              return true;
            } else {
              return false;
            }
          });
        }
      }
      return true;
    } catch (e) {
      notification_loading(false);
      return false;
    }
  }

  void readNotification({required String id}) async {
    try {
      notification_loading(true);
      var notificationresponse =
          await apiService.notificationRead(notificationId: id);
      if (notificationresponse!.result != false) {
        notification_read.value = notificationresponse;
        getNotification();
      } else {}
    } catch (e) {
      notification_loading(false);
    }
  }

  void clearAll() async {
    try {
      notification_loading(true);
      var clearNotification = await apiService.clearALlNotificationProvider();

      if (clearNotification != null) {
        clearAll_value.value = clearNotification.result!;
        if (clearNotification.result == true) {
          getNotification();
        }
      }
    } catch (e) {
      notification_loading(false);
    }
  }
}
