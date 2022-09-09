import 'package:english_madhyam/src/auth/login/login_page.dart';
import 'package:english_madhyam/src/auth/social%20login.dart';
import 'package:english_madhyam/src/helper/controllers/payment_controller/payment.dart';
import 'package:english_madhyam/src/helper/controllers/profile_controllers/profile_controllers.dart';
import 'package:english_madhyam/src/screen/home/home_page/purchase_history_screen.dart';
import 'package:english_madhyam/src/utils/About_us.dart';
import 'package:english_madhyam/src/utils/Terms&co.dart';
import 'package:english_madhyam/src/utils/Privacy.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:english_madhyam/src/screen/profile/profile_page.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/contact_us.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String message = '';
  String image = '';
  final HttpService _httpService = HttpService();
  final ProfileControllers _subcontroller = Get.find();
  final PaymentController _paymentController = Get.put(PaymentController());

  Future<void> _handleSignOut() => googleSignIn.signOut();

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    _handleSignOut();
    var respo = await _httpService.logOutApi();

    setState(() {
      message = respo!.message.toString();
    });
    if (respo!.result == "success") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const LoginPage()),
          (route) => false);
      prefs.clear();
    }
  }

  userDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString('image')!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDetails();
  }

  // final AuthController logout = AuthController();
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
                                      image: _subcontroller.profileGet.value
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
                    text: "General",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                  InkWell(
                    onTap: () {
                      _paymentController.purchaseHistory();

                      Get.to(() => const PurchaseHistoryScreen());
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icon/Document_fill.svg",
                            color: blackColor),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomDmSans(
                          text: "My Purchases",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                        IconButton(
                            onPressed: () {
                              _paymentController.purchaseHistory();

                              Get.to(() => const PurchaseHistoryScreen());
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: blackColor,
                              size: 18,
                            ))
                      ],
                    ),
                  ),
                  // InkWell(
                  //   onTap: (){
                  //     Get.to(()=>const LeaderBoard());
                  //   },
                  //   child: Row(
                  //     children: [
                  //       SvgPicture.asset("assets/icon/Activity.svg",color: blackColor),
                  //       const SizedBox(
                  //         width: 15,
                  //       ),
                  //       CustomDmSans(
                  //         text: "Leader Board",
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //         color: blackColor,
                  //       ),
                  //       const Spacer(
                  //         flex: 3,
                  //       ),
                  //       IconButton(
                  //           onPressed: () {},
                  //           icon: Icon(
                  //             Icons.arrow_forward_ios_rounded,
                  //             color: blackColor,
                  //             size: 18,
                  //           ))
                  //     ],
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      onShare(context);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icon/info.svg"),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomDmSans(
                          text: "Share the App",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                        IconButton(
                            onPressed: () {
                              onShare(context);
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: blackColor,
                              size: 18,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                    child: CustomDmSans(
                      text: "More",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: blackColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => ContactUs());
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icon/Calling.svg"),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomDmSans(
                          text: "Contact Us",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                        IconButton(
                            onPressed: () {
                              Get.to(() => ContactUs());
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: blackColor,
                              size: 18,
                            ))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => AboutUs());
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icon/Document_fill.svg",
                          color: blackColor,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomDmSans(
                          text: "About us",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                        IconButton(
                            onPressed: () {
                              Get.to(() => AboutUs());
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: blackColor,
                              size: 18,
                            ))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => TermsCond());
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icon/Info Circle.svg"),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomDmSans(
                          text: "Terms & Condition",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                        IconButton(
                            onPressed: () {
                              Get.to(() => TermsCond());
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: blackColor,
                              size: 18,
                            ))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const PrivacyPo());
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icon/shield.svg"),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomDmSans(
                          text: "Privacy Policy",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                        IconButton(
                            onPressed: () {
                              Get.to(() => const PrivacyPo());
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: blackColor,
                              size: 18,
                            ))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return dialog();
                          });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icon/Logout.svg"),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomDmSans(
                          text: "Logout",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return dialog();
                                  });
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: blackColor,
                              size: 18,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
