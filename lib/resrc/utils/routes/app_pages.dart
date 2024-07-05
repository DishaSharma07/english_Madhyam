import 'package:english_madhyam/src/screen/leader_Board/page/leader_board.dart';
import 'package:get/get.dart';

import '../../../src/auth/login/login_page.dart';
import '../../../src/screen/Splash/splash_binding.dart';
import '../../../src/screen/Splash/splash_page.dart';
import '../../../src/screen/bottom_nav/dashboard_page.dart';
import '../../../src/screen/bottom_nav/root_binding.dart';


class AppPages {
  static final pages = [
    GetPage(name: SplashScreen.routeName, page: () => const SplashScreen(),binding: SplashBinding()),
    GetPage(name: LoginPage.routeName, page: () =>  LoginPage()),

    GetPage(
        name: DashboardPage.routeName,
        binding: RootBinding(),
        page: () => DashboardPage()),

    GetPage(
        name: LeaderboardPage.routeName,
        page: () => LeaderboardPage()),

  ];
}
