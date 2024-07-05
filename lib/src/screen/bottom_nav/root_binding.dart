import 'package:get/get.dart';
import '../Notification_screen/controller/notification_contr.dart';
import '../home/controller/home_controller.dart';
import '../practice/controller/praticeController.dart';
import 'controller/dashboard_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController(),permanent: true);
 /*   Get.put<NotifcationController>(NotifcationController(),permanent: true);
    Get.put<QuizListController>(QuizListController(),permanent: true);
    Get.put<HomeController>(HomeController(),permanent: true);*/

  }
}