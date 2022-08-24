import 'package:english_madhyam/src/helper/controllers/Notification_contr/notification_contr.dart';
import 'package:english_madhyam/src/helper/controllers/quiz_list_controller/quiz_list.dart';
import 'package:english_madhyam/src/screen/choose_plan/choose_plan_page.dart';
import 'package:english_madhyam/src/screen/feed/feed_category.dart';
import 'package:english_madhyam/src/screen/home/home_page/home_page.dart';
import 'package:english_madhyam/src/screen/practice/daily_quiz_category.dart';
import 'package:english_madhyam/src/screen/videos_screen/video_cat_screen.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class BottomWidget extends StatefulWidget {
  final int? index;
  const BottomWidget({Key? key,this.index}) : super(key: key);

  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget>
    with SingleTickerProviderStateMixin {

  final NotifcationController _notifcationController=Get.put(NotifcationController());
final QuizListController _controller=Get.put(QuizListController());
  final iconList = [
    "Home.svg",
    "Document.svg",
    "Activity.svg",
    "ticket_star.svg",
    "learn.svg"
  ];

  final text = <String>["Main", "Material","Practice", "Feed", "Video"];

  int _selectedPageIndex = 0;
  bool selectedIcon = false;
  late AppLifecycleState _notification;
  late PageController pageController;
  late AnimationController _animationController;
  late Animation<double> animation;

  final List<Widget> _pages = [

  ];
  Future<bool>_onwill()async{
    if(_controller.selectedPageIndex.value==0){
      SystemNavigator.pop();
      return await true;
    }else{
      setState(() {
        _controller.selectedPageIndex.value=0;
      });      return await false;



    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _controller.pageC.value=pageController;
    _selectedPageIndex = (widget.index!=null?widget.index:0)!;

    _notifcationController.getNotification();
    _pages.add(
      HomePage(
        bottomcontroller: pageController,
      ),
    );
    _pages.add(
      const ChoosePlan(),
    );
    _pages.add(const DailyQuizCategory());

    _pages.add(
         const FeedCategory(),
    );
    _pages.add(
        const VideoCatScreen()
    );
    // _controller.quizzesCategoryListContr();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    Future.delayed(
      const Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  @override
  void onPause() {
    // Implement your code inside here
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onwill,
        child: Obx((){
          print(_controller.selectedPageIndex.value);
          return PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            allowImplicitScrolling: false,
            itemCount: _pages.length,
            itemBuilder: (ctx, indx) {
              return _pages[_controller.selectedPageIndex.value];
            },
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedPageIndex = index;
              });
              _controller.selectedPageIndex.value=index;
              pageController.animateToPage(  _controller.selectedPageIndex.value,
                  duration: const Duration(milliseconds: 50), curve: Curves.ease);
            },
          );
        }),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          onTap: (ind) {
            setState(() {
              _selectedPageIndex = ind;
              _controller.selectedPageIndex.value=ind;

            });
          },
          backgroundColor: themePurpleColor,
          currentIndex: _controller.selectedPageIndex.value,
          selectedIconTheme: IconThemeData(color: whiteColor),
          type: BottomNavigationBarType.fixed,
          fixedColor: whiteColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        _controller.selectedPageIndex.value== 0
                            ? "assets/icon/home_fill.svg"
                            : "assets/icon/${iconList[0]}",
                        color:_controller.selectedPageIndex.value== 0?lightYellowColor: whiteColor,
                        height: 18,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CustomRoboto(
                        text: text[0],
                        color: _controller.selectedPageIndex.value == 0?lightYellowColor:whiteColor,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icon/${iconList[1]}",
                        color: _controller.selectedPageIndex.value == 1?themeYellowColor:whiteColor,
                        height: 18,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CustomRoboto(
                        text: text[1],
                        color: _controller.selectedPageIndex.value== 1?themeYellowColor:whiteColor,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                label: ""),

            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                       "assets/icon/${iconList[2]}",
                        color:_controller.selectedPageIndex.value== 2?themeYellowColor: whiteColor,
                        height: 18,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CustomRoboto(
                        text: text[2],
                        color: _controller.selectedPageIndex.value == 2?themeYellowColor:whiteColor,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        _controller.selectedPageIndex.value == 3?"assets/icon/${iconList[3]}"
                            :"assets/icon/Ticket_Star_fill.svg",

                        color: _controller.selectedPageIndex.value == 3?themeYellowColor:whiteColor,
                        height: 18,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CustomRoboto(
                        text: text[3],
                        color: _controller.selectedPageIndex.value == 3?themeYellowColor:whiteColor,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icon/${iconList[4]}",
                        color: _controller.selectedPageIndex.value == 4?themeYellowColor:whiteColor,
                        height: 18,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CustomRoboto(
                        text: text[4],
                        color: _controller.selectedPageIndex.value == 4?themeYellowColor:whiteColor,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                label: ""),
          ],
        ),
      ),
    );
  }
}
