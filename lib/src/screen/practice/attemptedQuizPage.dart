import 'dart:ui';
import 'package:english_madhyam/resrc/models/model/quiz_details.dart';
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeExamDetailController.dart';
import 'package:english_madhyam/src/screen/favorite/controller/favoriteController.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../resrc/utils/ui_helper.dart';
import '../pages/page/converter.dart';
import '../profile/controller/profile_controllers.dart';

class AttemptedQuizPage extends StatefulWidget {
  final ExamDetails examDetails;
  final String title;
  final bool reviewExam;
  final int type;

  const AttemptedQuizPage(
      {Key? key,
      required this.title,
      required this.type,
      required this.examDetails,
      required this.reviewExam})
      : super(key: key);

  @override
  _AttemptedQuizPageState createState() => _AttemptedQuizPageState();
}

class _AttemptedQuizPageState extends State<AttemptedQuizPage> {

  final PraticeExamDetailController _quizDetailsController =
      Get.put(PraticeExamDetailController());
  final HtmlConverter _htmlConverter = HtmlConverter();
  final FavoriteController _favoriteController = Get.find();
  final ProfileControllers _profileControllers = Get.find();

  bool valueUpdated = false;
  bool isRe_attempted = true;

  //checked set Colors for question position
  Color getGoToColor(int questionIndex) {
    var questionList = widget.examDetails.content!.examQuestion ?? [];
    if (widget.reviewExam == true) {
      if (questionList[questionIndex].isAttempt == 1) {
        for (int i = 0; i < questionList[questionIndex].options!.length; i++) {
          var optionData = questionList[questionIndex].options![i];
          if (optionData.checked == 1 && optionData.correct == 1) {
            return lightGreenColor;
          } else if (optionData.checked == 1 && optionData.correct != 1) {
            return redColor;
          }
        }
      }
    }
    //default color for un answered
    return greyColor;
  }

  //done by mukesh initialize question index in var
  goToQuestion(int i) {
    if (i < _examQuestion.length && i >= 0) {
      setState(() {
        selectedQuestion = i;
      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

// Give Answer
  giveAnswer(int questionIndex, int optionIndex) async {
    if (optionIndex < _examQuestion[questionIndex].options!.length &&
        optionIndex >= 0 && _examQuestion[questionIndex].options!.contains(_examQuestion[questionIndex].options![optionIndex])) {
      for (int k = 0; k < _examQuestion[questionIndex].options!.length; k++) {
        _examQuestion[questionIndex].options![k].attempted = 0;
      }
      _examQuestion[questionIndex].options![optionIndex].attempted = 1;
      setState(() {
        selectedOption = _examQuestion[questionIndex].options![optionIndex].id!;
        //TODO check here the selected option
        _examQuestion[questionIndex].isSelect =
            _examQuestion[questionIndex].options![optionIndex].id;
        _examQuestion[selectedQuestion].isAttempt = 1;
        _examQuestion[selectedQuestion].ansType = 1;
        _examQuestion[selectedQuestion].isREAttmpted = 1;
        print(
            "_examQuestion[questionIndex].isSelect == ${_examQuestion[questionIndex].options![optionIndex].id}");
      });
    } else {
      Fluttertoast.showToast(msg: "Option not exist");
      cancel();
    }
  }

//View Next Questiojn
  nextAndSubmitExam({required String option}) async {
    if ((selectedQuestion + 1) < _examQuestion.length) {
      setState(() {
        selectedQuestion += 1;
      });
    } else {
      //if question is last the exam is submit by clicking on this button
      await UiHelper.showConfirmDialog(
          title: "Re-Attempted Exam",
          content: "Are you sure, You want to exit from Quiz Exam");

      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    }
  }

//View Prev Question
  viewPrevQuestion() {
    if ((selectedQuestion) > 0) {
      setState(() {
        selectedQuestion -= 1;
      });
    } else {
      Fluttertoast.showToast(msg: "No previous question found");
      cancel();
    }
  }

//Remove Answer
  removeAnswer(int i) async {
    if (i < _examQuestion.length && i >= 0) {
      for (int k = 0; k < _examQuestion[i].options!.length; k++) {
        _examQuestion[i].options![k].checked = 0;
      }
      setState(() {
        _examQuestion[i].isAttempt = 0;
        _examQuestion[i].ansType = 0;
      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

//Mark for review
  markForReview(int i) async {
    if (i < _examQuestion.length && i >= 0) {
      await _favoriteController.saveQuestionToList(
          context: context, questionId: _examQuestion[i].id.toString());
      setState(() {
        _examQuestion[i].mark = 1;
      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

  //UnMark Review
  unMarkForReview(int i) async {
    if (i < _examQuestion.length && i >= 0) {
      await _favoriteController.removeQuestionFromList(
          context: context, questionId: _examQuestion[i].id.toString());
      setState(() {
        _examQuestion[i].mark = 0;
      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

  late List<ExamQuestion> _examQuestion;
  final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  int selectedQuestion = 0;
  int selectedOption = 0;
  @override
  void initState() {
    _examQuestion = widget.examDetails.content!.examQuestion ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: whiteColor,
      appBar: AppBar(
        //backgroundColor: whiteColor,
        centerTitle: false,
        elevation: 0.0,
        title:  ToolbarTitle(
          title: widget.title??"",
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: _examQuestion.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                        child: Column(
                      children: [
                        Image.asset("assets/img/norecord.jpg"),
                        CustomDmSans(
                          text: "Solution is no longer available!!",
                          fontSize: 20,
                        )
                      ],
                    )),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      indicateMarks(),
                      reportMarkRow(),
                      questionWidget(),
                      optionsWidget(),
                      _examQuestion[selectedQuestion].isREAttmpted==0 && isRe_attempted
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  child: Column(
                                children: [
                                  CustomDmSans(
                                    text: "Solutions :",
                                    color: greenColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Html(
                                      data: _examQuestion[selectedQuestion]
                                              .solutions!
                                              .eSolutions ??
                                          "",
                                      style: {
                                        "body": Style(
                                          fontSize: FontSize(14.0),
                                        ),
                                        "p": Style(fontSize: FontSize(16.0))
                                      },
                                    ),
                                  ),
                                ],
                              )),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                    ],
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: bottomButtons(),
          ),

        ],
      ),
      endDrawer: endDrawerWidget(context),
    );
  }

  endDrawerWidget(BuildContext context) {
    return Stack(
      children: [
        Align(alignment: Alignment.centerRight,
        child: Container(
          width: context.width*.70,
          decoration: const BoxDecoration(color: homeColor),
          padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(

                // isThreeLine: true,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      _profileControllers.profileGet.value.user!.image.toString()),
                ),
                title:RegularTextDarkMode(
                  text: _profileControllers.profileGet.value.user!.name.toString(),
                  textSize: 16,
                  maxLine: 2,
                  textAlign: TextAlign.start,


                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: Colors.blueGrey),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Topic:",
                      style: TextStyle(
                          color: white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Flexible(

                      child: Text(
                        widget.title ?? "",
                        style: const TextStyle(color: white, fontSize: 14,overflow: TextOverflow.ellipsis),
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  labelCreate(Colors.grey,"Not Answered"),
                  labelCreate(Colors.red,"Wrong answered"),
                ],),
              const SizedBox(height: 6,),
              labelCreate(Colors.green,"Answered"),
              const Divider(),
              Expanded(child: questionIndexWidget()),
            ],
          ),
        ),),
        Align(alignment:Alignment.topRight,child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 40.0,right: 20),
            child: Icon(Icons.cancel_presentation,color: Colors.red,),
          ),
        ),),
      ],
    );
  }


  Widget indicateMarks(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Que No.${selectedQuestion+1}",
          style: TextStyle(fontWeight: FontWeight.bold),),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Marks:"),
            const SizedBox(width: 6,),
            Container(
              //width: 50,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child:  Text("+ ${widget.examDetails.content?.mark.toString()??""}"),
            ),
            const SizedBox(width: 6,),
            Container(
              //width: 50,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child:  Text("- ${widget.examDetails.content?.negativeMark.toString()??""}"),
            )
          ],
        )
      ],
    );
  }
  //check by mukesh
  Widget labelCreate(MaterialColor materialColor,String title){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: materialColor,borderRadius: BorderRadius.circular(5)
          ),
        ),
        const SizedBox(width: 6,),
        FittedBox(
            child: RegularTextDarkMode(text:title,textSize: 12,))
      ],
    );
  }

  //check by mukesh
  Widget questionIndexWidget() {
    return GridView(
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, crossAxisSpacing: 1),
      children:
          List.generate(widget.examDetails.content!.examQuestion!.length, (i) {
        return Container(
          padding: const EdgeInsets.all(5),
          width: 40,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  goToQuestion(i);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: getGoToColor(i),
                      borderRadius: BorderRadius.circular(5)),
                  width: 30,
                  height: 30,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          (i + 1).toString(),
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (i != selectedQuestion)
                  ? Container()
                  : Divider(
                      color: greyColor,
                      height: 10,
                      thickness: 2,
                    )
            ],
          ),
        );
      }),
    );
  }

  //check by mukesh
  Widget reportMarkRow() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () {
              if (_examQuestion[selectedQuestion].mark == 0) {
                markForReview(selectedQuestion);
              } else {
                unMarkForReview(selectedQuestion);
              }
            },
            child: Container(
              width: 100,
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: (_examQuestion[selectedQuestion].mark == 0)
                          ? Colors.grey
                          : purpleColor,
                      width: 1)),
              child: Row(
                children: [
                  CustomDmSans(
                      text: (_examQuestion[selectedQuestion].mark == 0)
                          ? "Save"
                          : "Saved",
                      fontSize: 14,
                      color: (_examQuestion[selectedQuestion].mark == 0)
                          ? Colors.grey
                          : purpleColor,
                      fontWeight: FontWeight.w500),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    (_examQuestion[selectedQuestion].mark == 0)
                        ? Icons.star_border
                        : Icons.star,
                    size: 20,
                    color: (_examQuestion[selectedQuestion].mark == 0)
                        ? Colors.grey
                        : purpleColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //check by mukesh
  Widget questionWidget() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Html(
          data: _examQuestion[selectedQuestion].eQuestion.toString(),
          style: {
            "body": Style(
              fontSize: FontSize(18.0),
            ),
            "p": Style(fontSize: FontSize(18.0))
          },
        ));
  }

//check by mukesh
  Widget optionsWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
                _examQuestion[selectedQuestion].options!.length, (j) {
              return InkWell(
                onTap: () {
                  if (_quizDetailsController.loadingQuestion.value) {
                    return;
                  }
                  else if(_examQuestion[selectedQuestion].isREAttmpted==1){
                    return;
                  }
                  else{
                    if(isRe_attempted){
                      giveAnswer(selectedQuestion, j);
                    }
                  }
                  //
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: _examQuestion[selectedQuestion]
                                            .isREAttmpted ==
                                        1 &&  isRe_attempted
                                    ? getAttemptedColor(j, 1)
                                    : !isRe_attempted?getNotAttemptedColor(j, 1):greyColor,
                                offset: const Offset(0.0, 1.0), //(x,y)
                                blurRadius: 4.0,
                              ),
                            ],
                            border: Border.all(
                                color: _examQuestion[selectedQuestion]
                                            .isREAttmpted ==
                                        1 &&  isRe_attempted
                                    ? getAttemptedColor(j, 0)
                                    : !isRe_attempted?getNotAttemptedColor(j, 0):greyColor,
                                width: 2),
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(
                            left: 10, top: 5, bottom: 5, right: 10),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Text(chars[j],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: greyColor,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                (_examQuestion[selectedQuestion]
                                            .options![j]
                                            .optionE ==
                                        null)
                                    ? const Text("")
                                    : Expanded(
                                        child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text(
                                              _htmlConverter.removeAllHtmlTags(
                                                  _examQuestion[
                                                          selectedQuestion]
                                                      .options![j]
                                                      .optionE
                                                      .toString()),
                                              style: GoogleFonts.dmSans(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                      ),
                              ],
                            ),
                            _examQuestion[selectedQuestion].isREAttmpted == 1 && isRe_attempted
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: showAttemptedIcon(j),
                                  )
                                : const SizedBox()
                          ],
                        )),
                    _examQuestion[selectedQuestion].isREAttmpted == 1 && isRe_attempted
                        ? Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: showAttemptedText(j),
                          )
                        : const SizedBox(),
                  ],
                ),
              );
            })));
  }

  Color getAttemptedColor(int j, int type) {
    var data =
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j];

    ///correct
    if (data.correct == 1 && (data.checked == 1 && data.attempted == 1)) {
      return lightGreenColor;
    }

    ///wrong
    else if (data.correct == 0 && (data.checked == 1 || data.attempted == 1)) {
      return redColor;
    }
    //default
    else if (data.correct == 0 && (data.checked == 0 || data.attempted == 0)) {
      ///border color
      if (type == 1) {
        return greyColor;
      }
      //container color
      else {
        return whiteColor;
      }
    } else if (data.correct == 1) {
      return lightGreenColor;
    }
    return greyColor;
  }

  Color getNotAttemptedColor(int j, int type) {
    var data =
    widget.examDetails.content!.examQuestion![selectedQuestion].options![j];

    ///correct
    if (data.correct == 1 && (data.checked == 1)) {
      return lightGreenColor;
    }
    ///wrong
    else if (data.correct == 0 && data.checked == 1) {
      return redColor;
    }
    //default
    else if (data.correct == 0 && data.checked == 0 ) {
      ///border color
      if (type == 1) {
        return greyColor;
      }
      //container color
      else {
        return whiteColor;
      }
    } else if (data.correct == 1) {
      return lightGreenColor;
    }
    return greyColor;
  }

  Widget showAttemptedIcon(int j) {
    var data =
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j];

    ///correct
    if (data.correct == 1 && data.attempted == 1) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
      );
    }

    ///wrong
    else if (data.correct == 0 && data.checked == 1) {
      return const Icon(
        Icons.close,
        color: Colors.red,
      );
    } else if (data.correct == 0 && data.attempted == 1) {
      return const Icon(
        Icons.replay,
        color: Colors.red,
      );
    } else
      return const SizedBox();
  }

  Widget showAttemptedText(int j) {
    var data =
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j];

    ///correct
    if (data.correct == 1 && data.attempted == 1) {
      return const SizedBox();
    }

    ///wrong
    else if (data.correct == 0 && data.checked == 1) {
      return const Text(
        "Your first attempt",
        style: TextStyle(color: Colors.red, fontSize: 12),
      );
    } else {
      return const SizedBox();
    }
  }
//check by mukesh
  Widget bottomButtons() {
    return Container(
        height: 70,
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ], color: whiteColor),
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(top: 0),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: (selectedQuestion <= 0)
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: Colors.black,
                                side:
                                    const BorderSide(color: Colors.purple, width: 1),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                              ),
                              onPressed: () {
                                viewPrevQuestion();
                              },
                              child: const Text(
                                "Previous",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))
                        ],
                      ),
              ),
              Switch(
                value: isRe_attempted,
                onChanged: (value) {
                  if (value) {
                    isRe_attempted = true;
                  } else {
                    isRe_attempted = false;
                  }
                  setState(() {});
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: (selectedQuestion == null
                      ? const SizedBox()
                      : Container(
                          margin: const EdgeInsets.all(0),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: greenColor,
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                              ),
                              onPressed: () {
                                nextAndSubmitExam(
                                    option: selectedOption.toString());
                              },
                              child: Text(
                                selectedQuestion + 1 < _examQuestion.length
                                    ? "Next"
                                    : "End",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold),
                              )))))
            ],
          ),
        ));
  }
}
