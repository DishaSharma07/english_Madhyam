// import 'package:english_madhyam/main.dart';
// import 'package:english_madhyam/src/helper/model/quiz_details.dart';
// import 'package:english_madhyam/src/screen/pages/page/converter.dart';
// import 'package:english_madhyam/src/screen/practice/play_quiz/playQuizPage.dart';
// import 'package:english_madhyam/src/utils/colors/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// class OptionWidget extends StatefulWidget {
//   bool reviewExam;
//   ExamQuestion examQuestion;
//     OptionWidget({Key? key, required this.reviewExam,required this.examQuestion}) : super(key: key);
//
//   @override
//   State<OptionWidget> createState() => _OptionWidgetState();
// }
//
// class _OptionWidgetState extends State<OptionWidget> {
//   final HtmlConverter _htmlConverter = HtmlConverter();
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.reviewExam == false
//         ? Container(
//         margin: const EdgeInsets.only(top: 10),
//         padding: const EdgeInsets.only(left: 5, right: 5),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: List.generate(
//                 widget.examQuestion.options!.length, (j) {
//               return InkWell(
//                 onTap: () {
//                   if (_quizDetailsController.loadingQuestion.value) {
//                     return;
//                   }
//                   giveAnswer(selectedQuestion, j);
//                 },
//                 child: Container(
//                     margin: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: (widget.examQuestion
//                                 .options![j].id
//                                 ==
//                                 selectedOption)
//                                 ? greenColor
//                                 : Colors.grey,
//                             offset: const Offset(0.0, 1.0), //(x,y)
//                             blurRadius: 4.0,
//                           ),
//                         ],
//                         border: Border.all(
//                             color: (widget.examQuestion
//                                 .options![j].id
//                                 ==
//                                 selectedOption)
//                                 ? greenColor
//                                 : whiteColor,
//                             width: 2),
//                         color: whiteColor,
//                         borderRadius: BorderRadius.circular(10)),
//                     padding: const EdgeInsets.only(
//                         left: 10, top: 5, bottom: 5, right: 10),
//                     child: Row(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                               color: whiteColor,
//                               borderRadius: BorderRadius.circular(50)),
//                           width: 30,
//                           height: 30,
//                           child: Center(
//                             child: Text(chars[j],
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     color: blackColor,
//                                     fontWeight: FontWeight.w600)),
//                           ),
//                         ),
//                         (widget.examQuestion
//                             .options![j]
//                             .optionE ==
//                             null)
//                             ? const Text("")
//                             : Expanded(
//                           child: Container(
//                               padding: const EdgeInsets.only(
//                                   left: 5, right: 5),
//                               child: /* CustomDmSans(
//                                 fontSize: 16,
//                                 color: blackColor,
//                                 text: _htmlConverter
//                                     .removeAllHtmlTags(_examQuestion[
//                                 selectedQuestion]
//                                     .options![j]
//                                     .optionE
//                                     .toString()),
//                               )*/
//                               Text(
//                                 _htmlConverter.removeAllHtmlTags(
//                                     widget.examQuestion
//                                         .options![j]
//                                         .optionE
//                                         .toString()),
//                                 style: GoogleFonts.dmSans(
//                                     fontSize: 16,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600),
//                               )),
//                         ),
//                       ],
//                     )),
//               );
//             })))
//         : Container(
//         margin: const EdgeInsets.only(top: 10),
//         padding: const EdgeInsets.only(left: 5, right: 5),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: List.generate(
//                 widget.examQuestion.options!.length, (j) {
//               return InkWell(
//                 onTap: () {},
//                 child: Container(
//                     margin: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: getGoToOptionColor(j, 1),
//                             offset: const Offset(0.0, 1.0), //(x,y)
//                             blurRadius: 4.0,
//                           ),
//                         ],
//                         border: Border.all(
//                             color: getGoToOptionColor(j, 0), width: 2),
//                         color: whiteColor,
//                         borderRadius: BorderRadius.circular(10)),
//                     padding: const EdgeInsets.only(
//                         left: 10, top: 5, bottom: 5, right: 10),
//                     child: Row(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                               color: whiteColor,
//                               borderRadius: BorderRadius.circular(50)),
//                           width: 30,
//                           height: 30,
//                           child: Center(
//                             child: Text(chars[j],
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     color: greyColor,
//                                     fontWeight: FontWeight.w600)),
//                           ),
//                         ),
//                         (widget.examQuestion
//                             .options![j]
//                             .optionE ==
//                             null)
//                             ? const Text("")
//                             : Expanded(
//                           child: Container(
//                               padding: const EdgeInsets.only(
//                                   left: 5, right: 5),
//                               child: /*CustomDmSans(
//                                 text: _htmlConverter
//                                     .removeAllHtmlTags(_examQuestion[
//                                 selectedQuestion]
//                                     .options![j]
//                                     .optionE
//                                     .toString()),
//                               )*/
//                               Text(
//                                 _htmlConverter.removeAllHtmlTags(
//                                     widget.examQuestion
//                                         .options![j]
//                                         .optionE
//                                         .toString()),
//                                 style: GoogleFonts.dmSans(
//                                     fontSize: 16,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600),
//                               )),
//                         ),
//                       ],
//                     )),
//               );
//             })));
//   }
//   // Give Answer
//   giveAnswer( int optionIndex) async {
//     if (optionIndex < widget.examQuestion.options!.length &&
//         optionIndex >= 0) {
//       for (int k = 0; k < widget.examQuestion.options!.length; k++) {
//         widget.examQuestion.options![k].checked = 0;
//       }
//       widget.examQuestion.options![optionIndex].checked = 1;
//       setState(() {
//         selectedOption = widget.examQuestion.options![optionIndex].id!;
//         selectedOptionIndex=optionIndex;
//
//         print(
//             "_examQuestion[questionIndex].isSelect == ${widget.examQuestion.options![optionIndex].id}");
//       });
//     } else {
//       Fluttertoast.showToast(msg: "Option not exist");
//       cancel();
//     }
//   }
// }
