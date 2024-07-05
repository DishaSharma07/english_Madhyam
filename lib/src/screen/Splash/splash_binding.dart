import 'package:english_madhyam/src/screen/Splash/splash_controller.dart';
import 'package:get/get.dart';


class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());

  }
}