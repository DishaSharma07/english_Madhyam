import 'dart:io';

import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/src/auth/login/login_page.dart';
import 'package:english_madhyam/src/screen/category/page/libraryPage.dart';
import 'package:english_madhyam/src/screen/menu/view/menuListView.dart';
import 'package:english_madhyam/src/screen/payment/controller/paymentController.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';

import 'package:english_madhyam/src/screen/home/home_page/purchase_history_screen.dart';
import 'package:english_madhyam/src/setting/page/settingPage.dart';

import 'package:english_madhyam/src/screen/profile/page/profile_page.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/contact_us.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import '../../commonController/authenticationController.dart';
import '../favorite/controller/favoriteController.dart';
import '../favorite/page/attemptedExamList.dart';
import '../favorite/page/saveQuestionList.dart';
import '../favorite/page/saveWordsList.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  final AuthenticationManager authenticationController = Get.find();
  String message = '';
  String image = '';
  final ProfileControllers _subcontroller = Get.find();
  final PaymentController _paymentController = Get.put(PaymentController());
  final FavoriteController _favoriteController = Get.find();

  @override
  void initState() {
    super.initState();
    userDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 20, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (_subcontroller.loading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          Get.to(() => const ProfilePage());
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.23,
                              decoration: BoxDecoration(
                                  color: lightGreyColor,
                                  image: DecorationImage(
                                      image: _subcontroller
                                                      .profileGet.value.user !=
                                                  null &&
                                              _subcontroller.profileGet.value
                                                      .user!.image !=
                                                  null
                                          ? NetworkImage(_subcontroller
                                              .profileGet.value.user!.image!)
                                          : const NetworkImage(
                                              "https://cdn2.iconfinder.com/data/icons/instagram-ui/48/jee-74-512.png",
                                              scale: 0.2),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(28)),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: greyColor.withOpacity(0.6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: SvgPicture.asset(
                                      "assets/icon/Edit.svg",
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomDmSans(
                    text: " General",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                  buildMenuWidget(
                      index: 0,
                      imagePath: Icons.history,
                      menuTitle:
                          Platform.isAndroid ? "My Purchases" : "My History"),
                  // Icons.favorite
                  buildMenuWidget(
                      index: 1,
                      imagePath: Icons.favorite,
                      menuTitle: "My Questions"),

                  //Icons.save,
                  buildMenuWidget(
                      index: 2,
                      imagePath: Icons.wordpress_sharp,
                      menuTitle: "My Words"),

                  //Icons.save,
                  buildMenuWidget(
                      index: 3,
                      imagePath: Icons.save,
                      menuTitle: "Attempted Exam"),

                  buildMenuWidget(
                      index: 4,
                      imagePath: Icons.share,
                      menuTitle: "Share the App"),

                  buildMenuWidget(
                      index: 5,
                      imagePath: Icons.contact_page,
                      menuTitle: "Contact Us"),

                  buildMenuWidget(
                      index: 6,
                      imagePath: Icons.dark_mode,
                      menuTitle: "Dark Mode"),

                  buildMenuWidget(
                      index: 7, imagePath: Icons.more_horiz, menuTitle: "More"),
                  //Icons.settings
                  buildMenuWidget(
                      index: 8,
                      imagePath: Icons.logout,
                      menuTitle: Platform.isAndroid ? "Logout" : "Logout"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildMenuWidget({imagePath, menuTitle, index}) {
    return InkWell(
      onTap: () {
        Get.back();
        switch (index) {
          case 0:
            _paymentController.purchaseHistory();
            Get.to(() => const PurchaseHistoryScreen());
            break;
          case 1:
            // _favoriteController.getSaveQuestionList();
            _favoriteController.isSavedQuestionNavigation.value=true;
            Get.back();
            // Get.to(() => SaveQuestionList());
            Get.to(() => MaterialParentCategoriesPage
());
            break;
          case 2:
            _favoriteController.getSaveWordsList();
            Get.back();
            Get.to(() => SaveWordList());
            break;
          case 3:
            Get.back();
            Get.to(() => AttemptedExampList());
            break;
          case 4:
            onShare(context);
            break;
          case 5:
            Get.to(() => ContactUs());
            break;
          case 6:
            Get.to(() => SettingPage());
            break;
          case 7:
            Get.to(() => MenuListView());
            break;
          case 8:
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return dialog();
                });
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Row(
          children: [
            Icon(
              imagePath,
              color: primaryColor,
            ),
            const SizedBox(
              width: 15,
            ),
            CustomDmSans(
              text: menuTitle,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            const Spacer(
              flex: 3,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  void onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
        "Share English Madhyam App with your friends ,${"https://play.google.com/store/search?q=english%20madhyam&c=apps"}",
        subject: "Share English Madhyam App",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  logout() async {
    authenticationController.handleSignOut();

    await apiService.logOutApi();
    authenticationController.removeToken();
    Get.offAll(LoginPage());

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (ctx) => LoginPage()), (route) => false);
  }

  userDetails() async {
    setState(() {
      image = authenticationController.getProfileImage() ?? "";
    });
  }

  Widget dialog() {
    return Dialog(
      shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 8),
            child: CustomDmSans(
              text: "English Madhyam",
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 18),
            child: CustomDmSans(
              text: "Are you sure you want to Logout ?",
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(context);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomDmSans(
                        align: TextAlign.center,
                        text: "No",
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const VerticalDivider(
                width: 1,
                thickness: 0.2,
                color: Colors.white,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // logout.logout();
                    logout();
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomDmSans(
                        text: "Yes",
                        align: TextAlign.center,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
