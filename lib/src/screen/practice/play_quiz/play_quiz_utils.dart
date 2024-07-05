// import 'package:english_madhyam/main.dart';
// import 'package:english_madhyam/src/helper/model/quiz_details.dart';
// import 'package:english_madhyam/src/screen/practice/controller/praticeExamDetailController.dart';
// import 'package:english_madhyam/src/utils/colors/colors.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class PlayQuizUtils{
//   List<ExamQuestion> examQues;
//   int selectedQuestion;
//   PraticeExamDetailController controller;
//
//
//   PlayQuizUtils({required this.controller,required this.examQues,required this.selectedQuestion});
//
//
//
//   String _printDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }
//
//   //submit dailog
//   _openSubmitDialog({required String type}) async {
//     var examId = int.parse(
//         examQues[selectedQuestion].examId!);
//
//     for (int i = 0; i < examQues.length; i++) {
//       var element = examQues[i];
//       //   print("========== START $i==========");
//       List<int> availableOptions = [];
//       element.options?.forEach((options) {
//         availableOptions.add(options.id ?? 0);
//       });
//       if (element.isAttempt == 1 &&
//           !availableOptions.contains(element.isSelect)) {
//         Fluttertoast.showToast(
//             msg:
//             "Please select your answer for question number ${i + 1} again.");
//         selectedQuestion = i;
//         controller.goToQuestion(i);
//         controller.removeAnswer(selectedQuestion);
//         return;
//       }
//     }
//
//     var response = await Get.dialog(
//         AlertDialog(
//           title: Stack(
//             alignment: Alignment.topCenter,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     "Time Remaining",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         color: purpleColor,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     // "",
//                     _printDuration(Duration(seconds: _remainingTime)),
//                     style: TextStyle(
//                         color: purpleColor,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               Align(
//                 alignment: Alignment.topRight,
//                 child: InkWell(
//                   onTap: () {
//                     Get.back();
//                   },
//                   child: const Icon(Icons.close),
//                 ),
//               ),
//             ],
//           ),
//           content: Container(
//             margin: const EdgeInsets.only(top: 10),
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               Container(
//                 padding: const EdgeInsets.only(bottom: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Answered",
//                       style: TextStyle(
//                           color: greenColor,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       _getAnsweredNumber().toString(),
//                       style: TextStyle(
//                           color: greenColor,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.only(bottom: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Not Answered",
//                       style: TextStyle(
//                           color: redColor,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       _getNotAnsweredNumber().toString(),
//                       style: TextStyle(
//                           color: redColor,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.only(bottom: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Marked For Review",
//                       style: TextStyle(
//                           color: Colors.orange,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       _getReviewNumber().toString(),
//                       style: const TextStyle(
//                           color: Colors.orange,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//               ),
//               type == "Pause"
//                   ? InkWell(
//                   onTap: () async {
//                     pauseTimer();
//                     var result = await _quizDetailsController.pauseExam(
//                         id: examId,
//                         left: _remainingTime,
//                         listData:
//                         widget.examDetails.content!.examQuestion ?? []);
//                     print("aaa--now is back");
//                     Future.delayed(const Duration(seconds: 0), () {
//                       Navigator.pop(context, result);
//                     });
//                   },
//                   child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 20),
//                       decoration: BoxDecoration(
//                           color: purpleColor,
//                           borderRadius: BorderRadius.circular(100)),
//                       child: Obx(() {
//                         if (_quizDetailsController.loading.value) {
//                           return Center(
//                             child: Lottie.asset(
//                                 "assets/animations/loader.json",
//                                 height: MediaQuery.of(context).size.height *
//                                     0.05),
//                           );
//                         } else {
//                           return Text(
//                             _quizDetailsController.pauseMessage.value ==
//                                 "resume" ||
//                                 _quizDetailsController
//                                     .pauseMessage.value ==
//                                     ""
//                                 ? "Pause"
//                                 : "Resume",
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                                 color: Colors.white),
//                           );
//                         }
//                       })))
//                   : InkWell(
//                 onTap: () async {
//                   Navigator.pop(context);
//                   _timer?.cancel();
//                   _submitExamController.submitControl(
//                       id: widget.examDetails.content!.id.toString(),
//                       eid: widget.examDetails.content!.editorialId
//                           .toString(),
//                       title: widget.title,
//                       catId: widget.examDetails.content!.categoryId
//                           .toString(),
//                       data: jsonEncode(
//                           widget.examDetails.content!.examQuestion),
//                       route: widget.type,
//                       time: _remainingTime.toString());
//                 },
//                 child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10, horizontal: 20),
//                     decoration: BoxDecoration(
//                         color: purpleColor,
//                         borderRadius: BorderRadius.circular(100)),
//                     child: Obx(() {
//                       if (_submitExamController.loading.value) {
//                         return Center(
//                           child: Lottie.asset(
//                             "assets/animations/loader.json",
//                             height:
//                             MediaQuery.of(context).size.height * 0.04,
//                           ),
//                         );
//                       } else {
//                         return const Text(
//                           "SUBMIT",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,
//                               color: Colors.white),
//                         );
//                       }
//                     })),
//               )
//             ]),
//           ),
//         ),
//         barrierDismissible: false);
//     print("aaa----$response");
//     if (response != null) Navigator.pop(context);
//   }
// }