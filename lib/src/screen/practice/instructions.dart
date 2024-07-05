import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeController.dart';
import 'package:english_madhyam/src/screen/practice/play_quiz/playQuizPage.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'controller/praticeExamDetailController.dart';
import '../pages/page/converter.dart';

class TestInstructions extends StatefulWidget {
  final int examid;
  final String title;
  final String catTitle;
  final int type;
  const TestInstructions(
      {Key? key,
      required this.type,
      required this.catTitle,
      required this.examid,
      required this.title})
      : super(key: key);

  @override
  _TestInstructionsState createState() => _TestInstructionsState();
}

class _TestInstructionsState extends State<TestInstructions> {
  final PraticeExamDetailController controller = Get.find();

  HtmlConverter _htmlConverter = HtmlConverter();
  String htmlconvert = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: whiteColor,
      appBar: AppBar(
        //backgroundColor: whiteColor,
        elevation: 0.0,
        centerTitle: false,
        title: ToolbarTitle(
          title: widget.title,
        ),
      ),
      body: widget.examid == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset('assets/animations/49993-search.json',
                      height: MediaQuery.of(context).size.height * 0.14),
                ),
                CustomDmSans(
                  text: "No Questions Available",
                  fontWeight: FontWeight.w500,
                )
              ],
            )
          : GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Colors.greenAccent,
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 18.0, bottom: 10, left: 20, right: 20),
                  child: GetX<PraticeExamDetailController>(
                      init: PraticeExamDetailController(),
                      builder: (controller) {
                        if (controller.loading.value == true) {
                          return Center(
                            child: Lottie.asset("assets/animations/loader.json",
                                height:
                                    MediaQuery.of(context).size.height * 0.1),
                          );
                        } else {
                          if (controller.quizDetail.value.content!.examQuestion!.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Lottie.asset(
                                      'assets/animations/49993-search.json',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14),
                                ),
                                CustomDmSans(
                                  text: "No Questions Available",
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomDmSans(
                                  text: controller
                                          .quizDetail.value.content!.title!
                                          .toString() +
                                      "   :" +
                                      controller
                                          .quizDetail.value.content!.publishAt!
                                          .substring(0, 10)
                                          .toString(),
                                  color: redColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomDmSans(
                                  text: "General instructions",
                                  color: blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomDmSans(
                                  text:
                                      "Please read the following instructions very carefully",
                                  color: blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomDmSans(
                                    text:
                                        "Negative Marking : - ${controller.quizDetail.value.content!.negativeMark.toString()}"),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: CustomDmSans(
                                      text: _htmlConverter.removeAllHtmlTags(
                                          controller.quizDetail.value.content!
                                              .instruction!
                                              .toString()),
                                      fontSize: 14,
                                      color: blackColor,
                                      letterspace: 0.1,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      color: lightGreyColor,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    CustomDmSans(
                                      text:
                                          "You have not Visited the Question Yet.",
                                      fontSize: 14,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: redColor,
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6))),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    CustomDmSans(
                                      text:
                                          "You have not answered the Question.",
                                      fontSize: 14,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: greenColor,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(6),
                                              topLeft: Radius.circular(6))),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: CustomDmSans(
                                        text:
                                            "You have NOT answered the question but have marked the question for review.",
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: magenttaColor,
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: CustomDmSans(
                                        text:
                                            "You have answered the question but marked it for review.",
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.startExam(id: widget.examid);
                                    Get.off(() => PlayQuizPage(
                                          examDetails:
                                              controller.quizDetail.value,
                                          reviewExam: false,
                                          title: controller.quizDetail.value
                                                      .content!.isDailyQuiz ==
                                                  1
                                              ? widget.catTitle
                                              : widget.title,
                                          type: widget.type,
                                        ));
                                  },
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 30,
                                          right: 30,
                                          top: 10,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: purplegrColor, width: 2),
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
                                        controller.quizDetail.value.content!
                                                    .isAttempt ==
                                                1
                                            ? "Resume Test"
                                            : 'Start Test',
                                        style: GoogleFonts.roboto(
                                            color: whiteColor,
                                            decoration: TextDecoration.none,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            shadows: [
                                              Shadow(
                                                offset: const Offset(1.0, 4),
                                                blurRadius: 3.0,
                                                color:
                                                    greyColor.withOpacity(0.5),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                      }),
                ),
              ),
            ),
    );
  }
}
