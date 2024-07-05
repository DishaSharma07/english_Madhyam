import 'dart:io';

import 'package:english_madhyam/resrc/models/model/home_model/home_model.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeExamDetailController.dart';
import 'package:english_madhyam/src/screen/practice/instructions.dart';
import 'package:english_madhyam/src/screen/practice/performance_report.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../profile/controller/profile_controllers.dart';
import '../../utils/custom_roboto/custom_roboto.dart';
import '../payment/page/choose_plan_details.dart';

class DailyQuiz extends StatefulWidget {
  final List<Quizz> quiz;
  const DailyQuiz({Key? key, required this.quiz}) : super(key: key);

  @override
  _DailyQuizState createState() => _DailyQuizState();
}

class _DailyQuizState extends State<DailyQuiz> {
  final PraticeExamDetailController quizController = Get.put(PraticeExamDetailController());
  final ProfileControllers profileControllers = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.quiz.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext ctx, int index) {
          return InkWell(
            onTap: () {
              if (widget.quiz[index].completed == 0) {
                quizController.getQuizDetailApi(widget.quiz[index].id);
                if (widget.quiz![index].type == 1 &&
                    profileControllers.profileGet.value.user!.isSubscription ==
                        "Y") {
                  Get.to(() => TestInstructions(
                        examid: widget.quiz[index].id!,
                        title: widget.quiz[index].title.toString(),
                        catTitle: widget.quiz[index].categoryName!,
                        type: 2,
                      ));
                } else if (widget.quiz![index].type == 1 &&
                    profileControllers.profileGet.value.user!.isSubscription ==
                        "N") {
                  //pay page
                  if (Platform.isAndroid) {
                    Get.to(() => const ChoosePlanDetails());
                  } else {
                    Get.to(() => TestInstructions(
                      examid: widget.quiz[index].id!,
                      title: widget.quiz[index].title.toString(),
                      catTitle: widget.quiz[index].categoryName!,
                      type: 2,
                    ));
                    //TODO change here
                    // Get.to(() => InAppPlanDetail());
                  }
                } else {
                  Get.to(() => TestInstructions(
                        examid: widget.quiz[index].id!,
                        title: widget.quiz[index].title.toString(),
                        catTitle: widget.quiz[index].categoryName!,
                        type: 2,
                      ));
                }
              } else {
                Get.to(() => PerformanceReport(
                      id: widget.quiz[index].id.toString(),
                      eId: "",
                      route: 2,
                    ));
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.88,
              margin: const EdgeInsets.only(right: 10, bottom: 4),
              padding:
                  const EdgeInsets.only(top: 10, bottom: 8, left: 10, right: 8),
              decoration: BoxDecoration(
                  //color: whiteColor,
                  /*boxShadow: [
                    BoxShadow(
                        color: greyColor.withOpacity(0.5),
                        blurRadius: 1,
                        offset: const Offset(2, 4))
                  ],*/
                  border:
                      Border.all(color: greyColor.withOpacity(0.2), width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeYellowColor.withOpacity(0.15),
                        image: widget.quiz[index].image != ""
                            ? DecorationImage(
                                image: NetworkImage(
                                  widget.quiz[index].image.toString(),
                                ),
                                scale: 1.2,
                                fit: BoxFit.cover)
                            : const DecorationImage(
                                image:
                                    AssetImage("assets/img/place_holder.png"),
                                scale: 1.2,
                                fit: BoxFit.cover)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.quiz[index].title!.length > 25
                              ? widget.quiz[index].title!.substring(0, 25) +
                                  ".."
                              : widget.quiz[index].title!,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              /*color: blackColor*/),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                widget.quiz[index].totalQuestion!.toString() +
                                    " Question.",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                   /* color: greyColor*/),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              widget.quiz[index].duration != ""
                                  ? Text(
                                      widget.quiz[index].duration.toString() +
                                          "  Mins",
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          /*color: greyColor*/),
                                    )
                                  : const Text(""),
                              const SizedBox(
                                width: 8,
                              ),
                              widget.quiz[index].categoryName != null
                                  ? Expanded(
                                      child: Text(
                                        widget.quiz[index].categoryName!
                                                    .length >
                                                20
                                            ? widget.quiz[index].categoryName!
                                                    .substring(0, 12) +
                                                ".."
                                            : widget.quiz[index].categoryName
                                                .toString(),
                                        maxLines: 2,
                                        style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: purpleColor),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 2, bottom: 4, left: 6, right: 4),
                              decoration: BoxDecoration(
                                  color: themeYellowColor,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Start Quiz ",
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: whiteColor),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_outlined,
                                    color: whiteColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            CustomRoboto(
                              text: widget.quiz[index].type == 0
                                  ? "Free"
                                  : "Premium",
                              fontSize: 12,
                              color: purpleColor,
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
