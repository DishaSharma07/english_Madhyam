

import 'package:english_madhyam/src/helper/controllers/editorial_detail_controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/helper/controllers/exam_details/quiz_details.dart';
import 'package:english_madhyam/src/helper/controllers/graph_data_contr/graphdata_contr.dart';
import 'package:english_madhyam/src/helper/controllers/quiz_list_controller/quiz_list.dart';
import 'package:english_madhyam/src/helper/model/editorial_detail_model/editorial_detail.dart';
import 'package:english_madhyam/src/screen/bottom_nav/bottom_nav.dart';
import 'package:english_madhyam/src/screen/editorials_page/editorials_details.dart';
import 'package:english_madhyam/src/screen/home/home_page/home_page.dart';
import 'package:english_madhyam/src/screen/practice/daily_quiz_category.dart';
import 'package:english_madhyam/src/screen/practice/practice.dart';
import 'package:english_madhyam/src/screen/practice/question_page.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/progress_bar_report/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class PerformanceReport extends StatefulWidget {
  final String id;
  final String eid;
  final String? catid;
  final int Route;
  final String? title;

  const PerformanceReport({Key? key,required this.eid, required this.id,this.title, this.catid,required this.Route}) : super(key: key);

  @override
  _PerformanceReportState createState() => _PerformanceReportState();
}

class _PerformanceReportState extends State<PerformanceReport> {
  final GraphDataController _graphDataController =
      Get.put(GraphDataController());
  final QuizListController _controller=Get.find();
  final EditorialDetailController detailController =
  Get.find();
  final QuizDetailsController _quizDetailsController=Get.put(QuizDetailsController());
  // final QuizListController _catcontroller=Get.put(QuizListController());

  Future<bool> _onWillPop() async {
    bool back = true;
    // in case
   switch (widget.Route){
     // in case Report is showing from editorial detail page
     case 0:
       detailController.meaningList(
           id: widget.eid);
       // detailController.editorialDetailsFetch(
       //     id: widget.eid);

       Navigator.of(context).pushAndRemoveUntil(
           MaterialPageRoute(builder: (context)=> EditorialsDetails(
              editorial_id: int.parse(widget.eid), editorial_title: widget.title!)
       ), (route) => route.isFirst);
       break;
   // in case Report is showing from Quiz listing page
     case 1:

       Navigator.of(context).pushAndRemoveUntil(
           MaterialPageRoute(
               builder: (context) =>
               const BottomWidget(index: 2)
           ), (route) => false
       );
       // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
       //
       //   return const DailyQuizCategory();
       // }
       //
       // ), (route) => false
       // );
       break;
   // in case Report is showing from Quiz home page
     case 2:
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>
        const BottomWidget()
       ), (route) => false
       );
       break;
   }
    // Get.offUntil(
    //
    //   (route) {
    //
    //   },
    // );
    return back;
  }

  double percent = 0.0;
  int unanswered = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quizDetailsController.examids(int.parse(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    _graphDataController.graphDataFetch(examid: widget.id);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            backgroundColor: whiteColor,
            centerTitle: false,
            leading: BackButton(
              color: blackColor,
            ),
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Text(
              'Performance Report',
              style: GoogleFonts.lato(
                  color: blackColor, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          body: Obx(() {
            if (_graphDataController.loading.value == true) {
              return Center(
                child: Lottie.asset(
                  "assets/animations/loader.json",
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
              );
            } else {

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: blackColor,
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _graphDataController
                                        .graphdata.value.content!.marks
                                        .toString(),
                                    style: GoogleFonts.roboto(fontSize: 18),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Divider(
                                      thickness: 1.5,
                                      color: blackColor,
                                    ),
                                  ),
                                  Text(
                                    _graphDataController
                                        .graphdata.value.content!.totalMarks
                                        .toString(),
                                    style: GoogleFonts.roboto(fontSize: 18),
                                  ),
                                ]),
                          ),
                          Text(
                            "Score",
                            style: GoogleFonts.roboto(fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            // width: 100.0,
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: blackColor,
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _graphDataController.graphdata.value.content!.rank.toString(),
                                    // _graphDataController.graphdata.value.content!.rank.toString(),
                                    style: GoogleFonts.roboto(fontSize: 18),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Divider(
                                      thickness: 1.5,
                                      color: blackColor,
                                    ),
                                  ),
                                  Text(
                                   _graphDataController.graphdata.value.content!.totalStudents.toString(),
                                    // _graphDataController.graphdata.value.content!.rankTotal.toString(),
                                    style: GoogleFonts.roboto(fontSize: 18),
                                  ),
                                ]),
                          ),
                          Text(
                            "Rank",
                            style: GoogleFonts.roboto(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
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
                              percent: _graphDataController.percentage/100,
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
                          style: GoogleFonts.lato(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                         ProgressBar(
                             redSize: double.parse((_graphDataController.graphdata.value
                                 .content!.incorrectQuestion!/_graphDataController.graphdata.value.content!.totalQuestion!).toString()),
                             greenSize:double.parse((_graphDataController.graphdata.value
                             .content!.correctQuestion!/_graphDataController.graphdata.value.content!.totalQuestion!).toString()) ),
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
                                    _graphDataController.graphdata.value
                                        .content!.correctQuestion!
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
                                    _graphDataController.graphdata.value
                                        .content!.incorrectQuestion!
                                        .toString(),
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: pinkColor),
                                  ),
                                  Text(
                                    "Incorrect",
                                    style: GoogleFonts.lato(
                                        fontSize: 14, color: pinkColor),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    (_graphDataController.graphdata.value
                                            .content!.skipQuestion)
                                        .toString(),
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: greyColor),
                                  ),
                                  Text(
                                    "Unanswered",
                                    style: GoogleFonts.lato(
                                        fontSize: 14, color: greyColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _quizDetailsController.quizzesDEtails();
                      Get.to(()=>QuestionPage(
                        examdetails: _quizDetailsController.quizDetail.value,
                        ReviewExam: true,Title: widget.title,type: widget.Route,));

                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: purplegrColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: greyColor,
                                blurRadius: 2,
                                spreadRadius: 1,
                                offset: const Offset(1, 2))
                          ],
                          gradient: RadialGradient(
                            center: const Alignment(0.0, 0.0),
                            colors: [purpleColor, purplegrColor],
                            radius: 3.0,
                          ),
                        ),
                        child: Text(
                          'View Solution',
                          style: GoogleFonts.roboto(
                              color: whiteColor,
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  offset: const Offset(1.0, 4),
                                  blurRadius: 3.0,
                                  color: greyColor.withOpacity(0.5),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          })),
    );
  }
}
