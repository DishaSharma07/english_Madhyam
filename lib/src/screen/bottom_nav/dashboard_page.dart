import 'dart:io';

import 'package:english_madhyam/src/screen/feed/page/feedDashboardPage.dart';
import 'package:english_madhyam/src/screen/home/home_page/home_page.dart';
import 'package:english_madhyam/src/screen/videos_screen/page/videoDashboardPage.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../category/page/libraryPage.dart';
import '../favorite/controller/favoriteController.dart';
import '../home/home_page/pass_page.dart';
import '../home/home_page/purchase_history_screen.dart';
import '../payment/page/choose_plan_details.dart';
import '../payment/page/in_app_plan_page.dart';
import '../profile/controller/profile_controllers.dart';
import 'controller/dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  final int? index;
  static const routeName = "/dashboard";
  DashboardPage({Key? key, this.index}) : super(key: key);

  var favoriteController = Get.put(FavoriteController());

  final iconList = [
    "Home.svg",
    "Document.svg",
    /*"Activity.svg",*/
    "ticket_star.svg",
    "learn.svg",
    "ticket_star.svg",
  ];
  bool selectedIcon = false;
  List<String> bottomTitle = ["Main", "Library", "Feed", "Lecture", "Pass"];


  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (_) {
        favoriteController.isSavedQuestionNavigation.value=false;
        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: IndexedStack(
                  index: controller.tabIndex,
                  children: [
                    HomePage(),
                    MaterialParentCategoriesPage
(),
                    FeedDashboard(),
                    VideoDashboardPage(),
                    PassPage()
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: themePurpleColor,
              onTap: controller.changeTabIndex,
              currentIndex: controller.tabIndex,
              unselectedItemColor: whiteColor,
              //selectedItemColor: button_color,
              showSelectedLabels: true,
              selectedItemColor: lightYellowColor,
              selectedIconTheme: IconThemeData(color: whiteColor),
              showUnselectedLabels: true,
              unselectedFontSize: 14,
              selectedFontSize: 16,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SvgPicture.asset(
                      controller.tabIndex == 0
                          ? "assets/icon/home_fill.svg"
                          : "assets/icon/${iconList[0]}",
                      color: controller.tabIndex == 0
                          ? themeYellowColor
                          : whiteColor,
                      height: 18,
                    ),
                  ),
                  label: bottomTitle[0],
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SvgPicture.asset(
                      "assets/icon/${iconList[1]}",
                      color: controller.tabIndex == 1
                          ? themeYellowColor
                          : whiteColor,
                      height: 18,
                    ),
                  ),
                  label: bottomTitle[1],
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SvgPicture.asset(
                      controller.tabIndex == 2
                          ? "assets/icon/Ticket_Star_fill.svg"
                          : "assets/icon/${iconList[2]}",
                      color: controller.tabIndex == 2
                          ? themeYellowColor
                          : whiteColor,
                      height: 18,
                    ),
                  ),
                  label: bottomTitle[2],
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SvgPicture.asset(
                      "assets/icon/${iconList[3]}",
                      color: controller.tabIndex == 3
                          ? themeYellowColor
                          : whiteColor,
                      height: 18,
                    ),
                  ),
                  label: bottomTitle[3],
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SvgPicture.asset(
                      "assets/icon/${iconList[4]}",
                      color: controller.tabIndex == 4
                          ? themeYellowColor
                          : whiteColor,
                      height: 18,
                    ),
                  ),
                  label: bottomTitle[4],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
