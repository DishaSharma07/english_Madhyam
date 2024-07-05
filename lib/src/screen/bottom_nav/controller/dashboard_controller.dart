import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/src/screen/home/controller/home_controller.dart';
import 'package:get/get.dart';
import '../../Notification_screen/controller/notification_contr.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;
  final _notificationController = Get.put(NotifcationController(),permanent: true);
  final _homeController = Get.put(HomeController(),permanent: true);

  final AuthenticationManager authController=Get.find();


  void changeTabIndex(int index) {
    tabIndex = index;
    _homeController.loading(false);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _notificationController.getNotification();
    authController.initPlatformState();
  }

}