import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/src/screen/feed/controller/feed_controller.dart';
import 'package:english_madhyam/src/screen/feed/page/phraseDayPage.dart';
import 'package:english_madhyam/src/screen/feed/page/wordDayPage.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../custom/toolbarTitle.dart';


class FeedDashboard extends StatefulWidget {
  FeedDashboard({Key? key}) : super(key: key);

  @override
  _FeedDashboardState createState() => _FeedDashboardState();
}

class _FeedDashboardState extends State<FeedDashboard>
    with TickerProviderStateMixin {
  late TabController tabController;

  final FeedController _feedController =
      Get.put<FeedController>(FeedController());

  DateTime? dateTime;
  String formattedDate = "";
  String chooseDate = "";

  List<String> color = [
    "#EDF6FF",
    "#FFDDDD",
    "#F6F4FF",
    "#EBFFE5",
  ];

  @override
  void initState() {
    super.initState();
     _feedController.feedApiFetch(type: "word", date: "2");
    //_feedController.getFeedListApi(isRefresh: false);
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          if (tabController.index == 0) {
            _feedController.feedApiFetch(type: "word", date: "2");
           //_feedController.getFeedListApi(isRefresh: true);
          } else if (tabController.index == 1) {
            _feedController.feedApiFetch(type: "phrase", date: "2");
          } else {}
        });
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: purpleColor.withOpacity(0.15),
      appBar: AppBar(
          elevation: 0.0,
          //backgroundColor: Colors.transparent,
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: const ToolbarTitle(title: 'Daily Learnings',),
          actions: [
            InkWell(
              onTap: () async {
                DateTime? newDateTime = await showRoundedDatePicker(
                  height: MediaQuery.of(context).size.height * 0.3,
                  styleDatePicker: MaterialRoundedDatePickerStyle(
                    backgroundHeader: themeYellowColor,
                  ),
                  context: context,
                  initialDate: dateTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(
                    const Duration(seconds: 10),
                  ),
                  theme: ThemeData(primarySwatch: Colors.pink),
                );

                if (newDateTime != null) {
                  setState(() {
                    dateTime = newDateTime;

                    formattedDate = DateFormat("MMM -d-y").format(dateTime!);
                    chooseDate =
                        " ${dateTime!.year}-${dateTime!.month}-${dateTime!.day}";
                    if (tabController.index == 0) {
                      _feedController.feedApiFetch(
                          type: "word", date: chooseDate);
                    } else {
                      _feedController.feedApiFetch(
                          type: "phrase", date: chooseDate);
                    }
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/icon/calendar.svg",
                  color: purpleColor,
                ),
              ),
            )
          ]),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            buildTabWidget(),
            Expanded(
              child: TabBarView(
                  controller: tabController,
                  children: const [
                    WordDayPage(),
                    PhraseDayPge(),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      child: TabBar(
        //unselectedLabelColor: blackColor,
          indicatorSize: TabBarIndicatorSize.label,
          controller: tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,

          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: purpleColor),
          tabs: [
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "WORD",
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Phrase",
                      style: GoogleFonts.roboto(fontSize: 14)),
                ),
              ),
            ),
          ]),
    );
  }


}
