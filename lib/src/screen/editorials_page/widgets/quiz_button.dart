import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/resrc/models/model/editorial_detail_model/editorial_detail.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeExamDetailController.dart';
import 'package:english_madhyam/src/screen/practice/instructions.dart';
import 'package:english_madhyam/src/screen/practice/performance_report.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizButton extends StatefulWidget {
  final EditorialDetails editorialDetails;
  final EditorialDetailController controller;

  const QuizButton({required this.editorialDetails,required this.controller, super.key});

  @override
  State<QuizButton> createState() => _QuizButtonState();
}

class _QuizButtonState extends State<QuizButton> {
  final PraticeExamDetailController Quizcontroller =
  Get.put(PraticeExamDetailController());
  @override
  Widget build(BuildContext context) {
    return _quizButton();
  }

  Widget _quizButton() {
    // if Quiz is available then show button
    if ((widget.editorialDetails.quizAvailable!) == 1) {
// if not attempted nd not completed then start quiz

      if ((widget.editorialDetails.isAttempt!) == 0 &&
          (widget.editorialDetails.isCompleted!) == 0) {
        return InkWell(
          onTap: () {
            if (widget.editorialDetails.examId != null) {
              Quizcontroller.getQuizDetailApi(widget.editorialDetails.examId);
              Get.off(() => TestInstructions(
                    title: widget.editorialDetails.title.toString(),
                    type: 0,
                    examid: widget.editorialDetails.examId!,
                    catTitle: "",
                  ));
            } else {
              Fluttertoast.showToast(msg: "No Quizz Available");
              cancel();
            }
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
                'Start Quiz',
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
        );
      }
      //if attemptd but not completed then Quiz is pause
      else if ((widget.editorialDetails.isAttempt!) == 1 &&
          (widget.editorialDetails.isCompleted!) == 0) {
        return InkWell(
          onTap: () {
            if (widget.editorialDetails.examId != null) {
              widget.controller.editorialid(widget.editorialDetails.id!);

              Quizcontroller.getQuizDetailApi(widget.editorialDetails.examId);

              Get.off(() => TestInstructions(
                  title: widget.editorialDetails.title.toString(),
                  type: 0,
                  catTitle: "",
                  examid: widget.editorialDetails.examId!));
            } else {
              Fluttertoast.showToast(msg: "No Quizz Available");
              cancel();
            }

            // Get.to(() => BottomWidget());
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
                'Resume Quiz',
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
        );
      }
      // if attempted and completed too then show result
      else {
        return InkWell(
          onTap: () {
            Get.to(() => PerformanceReport(
                  id: widget.editorialDetails.examId!.toString(),
                  eId: widget.editorialDetails.id!.toString(),
                  title: widget.editorialDetails.title,
                  catId: widget.editorialDetails.id!.toString(),
                  route: 0,
                ));
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
                'Show Report',
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
        );
      }
    } else {
      return const Text("");
    }
  }
}
