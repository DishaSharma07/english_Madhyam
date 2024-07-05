import 'dart:io';
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../resrc/widgets/loading.dart';
import '../../../commonController/authenticationController.dart';
import '../../../custom/toolbarTitle.dart';
import '../../bottom_nav/controller/dashboard_controller.dart';
import '../../pages/page/About_us.dart';
import '../../pages/page/Privacy.dart';
import '../../pages/page/Terms&co.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';
import '../controller/menuController.dart';

class MenuListView extends GetView<CustomMenuController> {
  static const routeName = "/MenuListView";
  MenuListView({Key? key}) : super(key: key);

  @override
  final controller = Get.put(CustomMenuController());

  final DashboardController dashboardController = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const ToolbarTitle(
          title: "More",
          color: Colors.white,
        ),
      ),
      body:Container(
        width: context.width,
        height: context.height,
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildMenuList(context)
                ],
              ),
            ),
            Obx(() =>
                controller.loading.value ? const Loading() : const SizedBox())
          ],
        ),
      ),
    );
  }
  buildMenuList(BuildContext context) {
    return GetX<CustomMenuController>(builder: (controller) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.menuMenuList.length,
        itemBuilder: (context, index) => buildChildMenuBody(index, context),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1 / 1,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5),
      );
    });
  }

  buildChildMenuBody(int index, BuildContext context) {
    return GestureDetector(
      onTap: (){
        switch(index){
          case 0:
            if (Platform.isAndroid) {
              Get.to(() => const ChoosePlanDetails());
            } else {
              Get.to(() => InAppPlanDetail());
            }
            break;
          case 1:
            Get.to(() => AboutUs());
            break;
          case 2:
            Get.to(() => TermsCond());
            break;
          case 3:
            Get.to(() => PrivacyPo());
            break;
        }
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
            color: primaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  controller.menuMenuList[index].iconUrl ?? "",
                  height: 25,
                  color: white
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  controller.menuMenuList[index].title ?? "",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(
                      fontFamily: "SourceSansPro",
                      fontSize: 13,
                      color: white ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
