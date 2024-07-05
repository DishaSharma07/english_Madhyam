// import 'package:english_madhyam/main.dart';
// import 'package:english_madhyam/src/utils/colors/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class QuizBottomActions extends StatefulWidget {
//   const QuizBottomActions({Key?key}):super(key: key)
//
//   @override
//   // State<QuizBottomActions> careateState() => _QuizBottomActionsState();
// }
//
// class _QuizBottomActionsState extends State<QuizBottomActions> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 70,
//         decoration: BoxDecoration(boxShadow: const [
//           BoxShadow(
//             color: Colors.grey,
//             offset: Offset(0.0, 1.0), //(x,y)
//             blurRadius: 4.0,
//           ),
//         ], color: whiteColor),
//         margin: const EdgeInsets.only(top: 10),
//         padding: const EdgeInsets.only(top: 0),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           child: Row(
//             children: [
//               Expanded(
//                 child: (selectedQuestion <= 0)
//                     ? Container()
//                     : Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: Colors.black,
//                           side: const BorderSide(
//                               color: Colors.purple, width: 1),
//                           shape: const RoundedRectangleBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(6))),
//                         ),
//                         onPressed: () {
//                           viewPrevQuestion();
//                         },
//                         child: const Text(
//                           "Previous",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ))
//                   ],
//                 ),
//               ),
//               widget.reviewExam == false
//                   ? Container(
//                   margin: const EdgeInsets.all(0),
//                   child: OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         backgroundColor: redColor,
//                         side:
//                         const BorderSide(color: Colors.black, width: 1),
//                         shape: const RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(6))),
//                       ),
//                       onPressed: () {
//                         removeAnswer(selectedQuestion);
//                       },
//                       child: const Text(
//                         "Clear",
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       )))
//                   : const SizedBox(),
//               const SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                   child: (selectedQuestion == null
//                       ? Container()
//                       : Container(
//                       margin: const EdgeInsets.all(0),
//                       child: OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.white,
//                             backgroundColor: greenColor,
//                             side: const BorderSide(
//                                 color: Colors.black, width: 1),
//                             shape: const RoundedRectangleBorder(
//                                 borderRadius:
//                                 BorderRadius.all(Radius.circular(6))),
//                           ),
//                           onPressed: () {
//                             viewNextQuestion(
//                                 option: selectedOption.toString());
//                           },
//                           child: widget.reviewExam == false
//                               ? Text(
//                             selectedQuestion + 1 <
//                                 _examQuestion.length
//                                 ? "Save & Next"
//                                 : "Submit Exam",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: whiteColor,
//                                 fontWeight: FontWeight.bold),
//                           )
//                               : Text(
//                             selectedQuestion + 1 <
//                                 _examQuestion.length
//                                 ? "Next"
//                                 : "End",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: whiteColor,
//                                 fontWeight: FontWeight.bold),
//                           )))))
//             ],
//           ),
//         ));
//   }
//   //View Prev Question
//   viewPrevQuestion() {
//     if ((selectedQuestion) > 0) {
//       setState(() {
//         selectedQuestion -= 1;
//         selectedOption=0;
//         selectedOptionIndex=0;
//       });
//     } else {
//       Fluttertoast.showToast(msg: "No previous question found");
//       cancel();
//     }
//   }
//
// //Remove Answer
//   removeAnswer(int i) async {
//     if (i < _examQuestion.length && i >= 0) {
//       for (int k = 0; k < _examQuestion[i].options!.length; k++) {
//         _examQuestion[i].options![k].checked = 0;
//       }
//       setState(() {
//         _examQuestion[i].isAttempt = 0;
//         _examQuestion[i].ansType = 0;
//         selectedOption=0;
//         selectedOptionIndex=0;
//
//       });
//     } else {
//       Fluttertoast.showToast(msg: "question not found");
//       cancel();
//     }
//   }
// }
