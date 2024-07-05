import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/boldTextView.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';



import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/leader_Board/page/leader_board.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeExamDetailController.dart';
import 'package:english_madhyam/src/screen/bottom_nav/dashboard_page.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/editorials_details.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/progress_bar_report/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';

class PerformanceReport extends StatefulWidget {
  final String id;
  final String eId;
  final String? catId;
  final int route;
  final String? title;

  const PerformanceReport(
      {Key? key,
      required this.eId,
      required this.id,
      this.title,
      this.catId,
      required this.route})
      : super(key: key);

  @override
  _PerformanceReportState createState() => _PerformanceReportState();
}

class _PerformanceReportState extends State<PerformanceReport> {
  final PraticeExamDetailController _quizDetailsController =
      Get.put(PraticeExamDetailController());

  Future<bool> _onWillPop() async {
    bool back = true;
    print(widget.route);
    switch (widget.route) {
      /// in case Report is showing from editorial detail page
      case 0:
        Get.back();
       /* Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => CommonEditorialsDetailsPage(
                    editorial_id: int.parse(widget.eId),
                    editorial_title: widget.title!)),
            (route) => route.isFirst);*/
        break;

      /// in case Report is showing from Quiz listing page
      case 1:
        Get.back();
        //Get.offNamedUntil(DashboardPage.routeName, (route) => false);
        break;

      /// in case Report is showing from Quiz home page
      case 2:
        Get.back();
        // Get.offNamedUntil(DashboardPage.routeName, (route) => false);
        break;
      case 3:
        Get.back();
        //Get.offNamedUntil(DashboardPage.routeName, (route) => false);
        break;
    }
    return back;
  }

  double percent = 0.0;
  int unanswered = 0;
  var data;
  var attempted;

  @override
  void initState() {
    _quizDetailsController.graphDataFetch(examId: widget.id);
    _quizDetailsController.getQuizDetailApi(int.parse(widget.id));

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          //backgroundColor: whiteColor,
          appBar: AppBar(
            //backgroundColor: whiteColor,
            centerTitle: false,
            elevation: 0.0,
            title: const ToolbarTitle(
              title: "Overall Performance Summary",
            ),
            actions: [],
          ),
          body: GetX<PraticeExamDetailController>(
            builder: (controller) {
              data = _quizDetailsController.graphdata.value.content!;
              attempted = double.parse(data.correctQuestion.toString()) +
                  double.parse(data.incorrectQuestion.toString());
              return Stack(
                children: [
                  controller.dataLoaded.value == true
                      ? const Loading()
                      : loadGraphData(),
                  controller.loading.value == true
                      ? const Loading()
                      : const SizedBox()
                ],
              );
            },
          )),
    );
  }

  loadGraphData() {
    return SingleChildScrollView(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*0.32,
            child: loadParentWidget(),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 10.0,
                      animation: true,
                      backgroundColor: lightGreyColor,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: pinkColor,
                      percent: _quizDetailsController.percentage / 100,
                    ),
                    Text(
                      "Total Question Attempted:",
                      style: GoogleFonts.roboto(
                          fontSize: 14, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Text(
                  "QUESTION  DISTRIBUTION",
                  style:
                      GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ProgressBar(
                    redSize: double.parse((_quizDetailsController
                                .graphdata.value.content!.incorrectQuestion! /
                            _quizDetailsController
                                .graphdata.value.content!.totalQuestion!)
                        .toString()),
                    greenSize: double.parse((_quizDetailsController
                                .graphdata.value.content!.correctQuestion! /
                            _quizDetailsController
                                .graphdata.value.content!.totalQuestion!)
                        .toString())),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            _quizDetailsController
                                .graphdata.value.content!.correctQuestion!
                                .toString(),
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: lightGreenColor),
                          ),
                          Text(
                            "Correct",
                            style: GoogleFonts.lato(
                                fontSize: 14, color: lightGreenColor),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            _quizDetailsController
                                .graphdata.value.content!.incorrectQuestion!
                                .toString(),
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: pinkColor),
                          ),
                          Text(
                            "Incorrect",
                            style:
                                GoogleFonts.lato(fontSize: 14, color: pinkColor),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            (_quizDetailsController
                                    .graphdata.value.content!.skipQuestion)
                                .toString(),
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: greyColor),
                          ),
                          Text(
                            "Unanswered",
                            style:
                                GoogleFonts.lato(fontSize: 14, color: greyColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 45,
                    child: MaterialButton(
                      color: primaryColor1,
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                      onPressed: () async {
                        _quizDetailsController.quizzesDetails(
                            title: widget.title, route: widget.route);
                      },
                      child: const BoldTextView(
                        text: "View Solution",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 2,),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 45,
                    child: MaterialButton(
                      color: primaryColor1,
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                      onPressed: () async {
                        Get.toNamed(LeaderboardPage.routeName,arguments: {"examId":widget.id,"cateId":widget.catId});
                      },
                      child: const BoldTextView(
                        text: "View Leaderboard",
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  loadParentWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: loadHeaderPart())
      ],
    );
  }

  loadHeaderPart() {





    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: homeTopColor,

          borderRadius: BorderRadius.circular(12),

      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              buildChildMenuBody(
                "Rank",
                "${data.rank}/${data.totalStudents}",
                "assets/img/rank.png",
              ),
              buildChildMenuBody(
                "Score",
                "${data.marks}/${data.totalMarks}",
                "assets/img/trophy.png",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildChildMenuBody(
                "Accuracy",getAccuracy((data.correctQuestion!+data.incorrectQuestion!),data.correctQuestion??0),
                "assets/img/iaccuracy.png",
              ),
              buildChildMenuBody(
                "Percentile",
                calculatePercentile(data?.rank??0,data.totalStudents??0),
                "assets/img/ratio.png",
              ),
            ],
          ),
          buildChildMenuBody(
              "Attempted",
              "${attempted.toInt()}/${data.totalQuestion}",
              "assets/img/attempt.png"),
        ],
      ),
    );
  }

  buildChildMenuBody(
    title,
    subTitle,
    String score,
  ) {
    return Expanded(
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Image.asset(
          score,
          height: 30,
        ),
        title: BoldTextView(
          text: title,
          textAlign: TextAlign.start,
          color: primaryColor1,
        ),
        subtitle: RegularTextDarkMode(
          text: subTitle,
          textSize: 16,
          color: labelColor,
        ),
      ),
    );
  }

  String getAccuracy(int totalQuestion,int correctQuestion){
    /*Accuracy=(
        Total Number of Questions
        Number of Correct Answers
        ​
    )×100*/

    var accuracy= double.parse(((correctQuestion / totalQuestion)*100).toString());
    return accuracy.toStringAsFixed(2);
  }


  String calculatePercentile(int rank, int totalItems) {
    if (rank <= 0 || rank > totalItems || totalItems <= 0) {
      throw ArgumentError("Invalid rank or totalItems");
      return "0 %";
    }
    double percentile = (totalItems - rank) / totalItems * 100.0;
    return "${percentile.toStringAsFixed(2)} %";
  }
}
