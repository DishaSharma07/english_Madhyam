import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/src/screen/favorite/page/attemptedExamList.dart';
import 'package:english_madhyam/src/screen/home/controller/home_controller.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';
import 'package:english_madhyam/src/screen/Notification_screen/page/Notifications.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/editorials_page.dart';
import 'package:english_madhyam/src/screen/home/achievers.dart';
import 'package:english_madhyam/src/screen/home/daily_quiz.dart';
import 'package:english_madhyam/src/screen/home/drawer_screen.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/editorials.dart';
import 'package:english_madhyam/src/screen/home/refer_and_earn.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../resrc/widgets/loading.dart';
import '../../Notification_screen/controller/notification_contr.dart';
import '../../bottom_nav/controller/dashboard_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticationManager _authController = Get.find();
  final DashboardController dashboardController = Get.find();
  String userName = "";
  late String userImage;
  GlobalKey<NavigatorState>? NavigationKey;

  final HomeController homeController = Get.find();
  final ProfileControllers _profile = Get.put(ProfileControllers());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CarouselController _sliderController = CarouselController();
  final NotifcationController _notifcationController = Get.find();

  String? name;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _current = 0;

  void _onRefresh() async {
    // monitor network fetch
    homeController.homeApiFetch();
     _profile.profileDataFetch();
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  userDetails() async {
    homeController.homeApiFetch();
    setState(() {
      name = _authController.getName();
    });
    _authController.getBirthday() == true && _authController.getShowed() != true
        ? _openSubmitDialog()
        : null;
  }

  @override
  void initState() {
    super.initState();
    userDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: const DrawerNavigation(),
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegularTextView(
                text: "Hi ," + name.toString(),
              ),
              RegularTextView(
                text: homeController.greeting.value,
              ),
            ],
          ),
          leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(Icons.menu,size: 35,),
            ),
          ),
          actions: [
            InkWell(
              onTap: () async {
                await _notifcationController.getNotification();
                Get.to(() => NotificationScreen());
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0, top: 20),
                child: Stack(
                  children: [
                    SvgPicture.asset("assets/icon/bell.svg",color: primaryColor,),
                    Positioned(
                      // draw a red marble
                      top: 0.0,
                      right: 0.0,
                      child: _notifcationController.unread_notification > 0
                          ? const Icon(Icons.brightness_1,
                              size: 8.0, color: Colors.redAccent)
                          : const SizedBox(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        body: GetX<HomeController>(
          builder: (homeController) {
            return Stack(
              children: [
                SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                      child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/img/bg.png",
                                ),
                                fit: BoxFit.fitWidth)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            homeController.banner.isEmpty
                                ? const SizedBox()
                                : Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.3,
                                  width: MediaQuery.of(context).size.width,
                                  child: slider()),
                            ),
                            const SizedBox(height: 12,),
                            homeController.courses.isNotEmpty
                                ? recentPostWidget()
                                : const SizedBox(),
                            homeController.dailyQuizList.isNotEmpty?loadQuizData():const SizedBox(),
                            attemptedExamWidget(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 20),
                              child: Achieverstake(
                                  achievers: homeController.achievers),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 20),
                              child: InkWell(
                                  onTap: () {
                                    onShare(context);
                                  },
                                  child: const RefferEarn()),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: purpleColor.withOpacity(0.13),
                              child: bottom(),
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      )),),
                homeController.loading.value
                    ? const Loading()
                    : const SizedBox()
              ],
            );
          },
        ));
  }


  Widget loadQuizData(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15, bottom: 15, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daily Quiz >",
                style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: (){
                  dashboardController.changeTabIndex(1);
                  setState(() {
                  });
                },
                child: Text(
                  "View All",
                  style: GoogleFonts.lato(
                      fontSize: 16,color: primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.16,
                    child: DailyQuiz(
                      quiz: homeController.dailyQuizList,
                    )),
                const SizedBox(
                  height: 12,
                ),
               /* Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      dashboardController.changeTabIndex(2);
                      setState(() {
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 35,
                          right: 35,
                          top: 10,
                          bottom: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: purpleColor,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "See all",
                        style: GoogleFonts.lato(
                            fontSize: 16, color: purpleColor),
                      ),
                    ),
                  ),
                )*/
              ],
            )),
      ],
    );
  }

  Widget recentPostWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Padding(
             padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
             child: Text(
               "Recent Posts",
               style: GoogleFonts.lato(
                   fontSize: 20, fontWeight: FontWeight.w600),
             ),
           ),
           InkWell(
             onTap: (){
               Get.to(() => EditorialsPage());
             },
             child: Padding(
               padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
               child: Text(
                 "View All",
                 style: GoogleFonts.lato(color: primaryColor,
                     fontSize: 16, fontWeight: FontWeight.w600),
               ),
             ),
           ),
         ],
       ),
        EditorialsList(
          type: 0,
          editorials: homeController.courses,
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget attemptedExamWidget() {
    return InkWell(
      onTap: (){
        Get.to(AttemptedExampList());
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: primaryColor
        ),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
            child: Text(
              "Attempted Exam",
              style: GoogleFonts.lato(
                  fontSize: 16, fontWeight: FontWeight.w600,color: white),
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios,size: 20,color: white),
        ),
      ),
    );
  }


  Widget slider() {
    final List<Widget> imageSliders = homeController.banner
        .map((item) => Container(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  child: Image.network(item.banner.toString(),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width)),
            ))
        .toList();

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Expanded(
        child: CarouselSlider(
          items: imageSliders,
          carouselController: _sliderController,
          options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 0.9,
              autoPlay: true,
              aspectRatio: 1.9,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: homeController.banner.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () {
              _sliderController.animateToPage(
                entry.key,
              );
            },
            child: Container(
              width: 6.0,
              height: 6.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gradientBlue
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  void onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
        "Share English Madhyam App with your friends ,${"https://play.google.com/store/search?q=english%20madhyam&c=apps"}",
        subject: "Share English Madhyam App",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  Widget bottom() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                homeController.students + " +",
                style: GoogleFonts.montserrat(
                  color: purplegrColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const RegularTextView(text: "Students",textSize: 15,)
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (homeController.successRate).toString(),
                style: GoogleFonts.montserrat(
                  color: purplegrColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const RegularTextView(text: "Success Rate",textSize: 15,)
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${homeController.mentors} +",
                style: GoogleFonts.montserrat(
                  color: purplegrColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const RegularTextView(text: "Mentors",textSize: 15,)
            ],
          ),
        ],
      ),
    );
  }

  _openSubmitDialog() async {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/img/birthImg.png",
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    )),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "May God Bless you with health, wealth and prosperity in your life",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ]),
            ));
    _authController.setBirthdayAndShowed(false, true);
  }
}
