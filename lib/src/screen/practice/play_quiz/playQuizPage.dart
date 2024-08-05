import 'package:english_madhyam/resrc/models/model/quiz_details.dart';
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeExamDetailController.dart';
import 'package:english_madhyam/src/screen/practice/controller/submit_exam.dart';
import 'package:english_madhyam/src/screen/bottom_nav/dashboard_page.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/editorials_page.dart';
import 'package:english_madhyam/src/screen/favorite/controller/favoriteController.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:english_madhyam/src/widgets/question_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import '../../pages/page/converter.dart';
import '../../profile/controller/profile_controllers.dart';

const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

class PlayQuizPage extends StatefulWidget {
  final ExamDetails examDetails;
  final String title;
  final bool reviewExam;
  final int type;

  const PlayQuizPage(
      {Key? key,
      required this.title,
      required this.type,
      required this.examDetails,
      required this.reviewExam})
      : super(key: key);

  @override
  _PlayQuizPageState createState() => _PlayQuizPageState();
}

class _PlayQuizPageState extends State<PlayQuizPage> {
  TextEditingController reportQuestionController = TextEditingController();
  final SubmitExamController _submitExamController =
      Get.put(SubmitExamController());
  final PraticeExamDetailController _quizDetailsController =
      Get.put(PraticeExamDetailController());
  final HtmlConverter _htmlConverter = HtmlConverter();
  final FavoriteController _favoriteController = Get.find();
  final ProfileControllers _profileControllers = Get.find();
  List<String> reportIssues = [
    "Wrong Question",
    "Wrong Answer",
    "Formatting Issue",
    "No Solution",
    "Wrong Transiation",
    "Copyright issue",
    "Others"
  ];
  late Timer _timer;
  bool valueUpdated = false;

  late List<ExamQuestion> _examQuestion;

  int selectedQuestion = 0;
  int selectedOption = 0;
  int selectedOptionIndex = 0;
  int _remainingTime = 0;

  @override
  void initState() {
    _examQuestion = widget.examDetails.content!.examQuestion ?? [];
    if (widget.reviewExam == false) {
      if (widget.examDetails.content!.timeLeft == "") {
        _remainingTime = int.parse(widget.examDetails.content!.duration!) * 60;
      } else {
        _remainingTime =
            int.parse(widget.examDetails.content!.timeLeft!.toString());
      }
      _startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: whiteColor,
      appBar: AppBar(
        //backgroundColor: whiteColor,
        centerTitle: false,
        //automaticallyImplyLeading: false,
        elevation: 0.0,
        title: const ToolbarTitle(
          title: 'Play Exam',
        ),
      ),
      body: WillPopScope(
        onWillPop: exitDialog,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  indicateMarks(),
                  saveRow(),
                  headerTimerWidget(),
                  questionWidget(),
                  optionsWidget(),
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
            Obx(() => _quizDetailsController.loadingQuestion.value
                ? const Loading()
                : const SizedBox())
          ],
        ),
      ),
      endDrawer: endDrawerWidget(),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  //checked set Colors for question position
  Color getGoToColor(int questionIndex) {
    var questionList = widget.examDetails.content!.examQuestion ?? [];
    if (widget.reviewExam == false) {
      //color for marked question
      if (questionList[questionIndex].mark == 1) {
        return purpleColor;
      }
      // color for attempted question
      if (questionList[questionIndex].ansType == 1 ||
          questionList[questionIndex].isAttempt == 1) {
        return lightGreenColor;
      } else {
        //default color for un answered
        return greyColor;
      }
    }
    else if (widget.reviewExam == true) {
      if (questionList[questionIndex].isAttempt == 1) {
        for (int i = 0; i < questionList[questionIndex].options!.length; i++) {
          var optionData = questionList[questionIndex].options![i];

          print({"checked-:${optionData.checked}"});
          print({"correct${optionData.correct}"});

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
        optionIndex >= 0) {
      for (int k = 0; k < _examQuestion[questionIndex].options!.length; k++) {
        _examQuestion[questionIndex].options![k].checked = 0;
      }
      _examQuestion[questionIndex].options![optionIndex].checked = 1;
      setState(() {
        selectedOption = _examQuestion[questionIndex].options![optionIndex].id!;
        selectedOptionIndex = optionIndex;

        print(
            "_examQuestion[questionIndex].isSelect == ${_examQuestion[questionIndex].options![optionIndex].id}");
      });
    } else {
      Fluttertoast.showToast(msg: "Option not exist");
      cancel();
    }
  }

//Total Answered number
  int _getAnsweredNumber() {
    int _answered = 0;
    widget.examDetails.content!.examQuestion!.forEach((examQuestion) {
      if (examQuestion.isAttempt == 1) {
        _answered += 1;
      }
    });
    return _answered;
  }

  //Total Review Question
  int _getReviewNumber() {
    int _answered = 0;
    widget.examDetails.content!.examQuestion!.forEach((examQuestion) {
      if (examQuestion.mark == 1) {
        _answered += 1;
      }
    });
    return _answered;
  }

  //Total not Answeres QUESTION
  int _getNotAnsweredNumber() {
    int _answered = 0;
    widget.examDetails.content!.examQuestion!.forEach((examQuestion) {
      if (examQuestion.isAttempt != 1) {
        _answered += 1;
      }
    });
    return _answered;
  }

//View Next Questiojn
  viewNextQuestion({required String option}) async {
    //Exam started
    if (widget.reviewExam == false) {
      //if selected question is less than total questions
      if ((selectedQuestion + 1) < _examQuestion.length) {
        // if option is selected
        if (selectedOption != 0) {
          if (_examQuestion[selectedQuestion]
                  .options![selectedOptionIndex]
                  .id ==
              int.parse(option)) {
            setState(() {
              _examQuestion[selectedQuestion].isSelect = int.parse(option);

              _examQuestion[selectedQuestion].isAttempt = 1;
              _examQuestion[selectedQuestion].ansType = 1;
              selectedQuestion = selectedQuestion + 1;
              print(
                  "_examQuestion[selectedQuestion - 1].isSelect == ${int.parse(option)}");
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Option not found"),
            ));
          }
        }
        //other wise select an option
        else {
          setState(() {
            selectedQuestion += 1;
          });
        }
        setState(() {
          selectedOption = 0;
          selectedOptionIndex = 0;
        });
      } else {
        //if question is last the exam is submit by clicking on this button
        _openSubmitDialog(type: "Submit");
        setState(() {
          selectedOption = 0;
        });
      }
    }
    //Exam Reviewing
    else {
      if ((selectedQuestion + 1) < _examQuestion.length) {
        setState(() {
          selectedQuestion += 1;
        });
      } else {
        //if question is last the exam is submit by clicking on this button
        Fluttertoast.showToast(msg: "No next question found");
        cancel();
      }
    }
  }

//View Prev Question
  viewPrevQuestion() {
    if ((selectedQuestion) > 0) {
      setState(() {
        selectedQuestion -= 1;
        selectedOption = 0;
        selectedOptionIndex = 0;
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
        selectedOption = 0;
        selectedOptionIndex = 0;
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

  // reportQuestion(int i) async {
  //
  // }

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

  Future<bool> exitDialog() async {
    String title = "";
    return await Get.defaultDialog(
      title: "Do you really want to exit?",
      textCancel: "Cancel",
      textConfirm: "Confirm",
      barrierDismissible: false,
      onConfirm: () {
        //Get.back(result: true);
        Navigator.pop(context, true);
      },
      onCancel: () {},
      buttonColor: redColor,
      cancelTextColor: redColor,
      confirmTextColor: whiteColor,
      contentPadding: const EdgeInsets.all(12),
      content: Text(_quizDetailsController.pauseMessage.value == "resume"
          ? "By Confirm you are submitting your Exam"
          : "Are You Confirm"),
    );
  }

//Start timer
  _startTimer() {
    _timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (Timer timer) {
        // print(_remainingTime.toString()+"REMAINING TIME");
        if (_remainingTime == 0) {
          timer.cancel();
          _submitExamController.submitControl(
              id: widget.examDetails.content!.id.toString(),
              eid: widget.examDetails.content!.editorialId.toString(),
              title: widget.title,
              catId: widget.examDetails.content!.categoryId.toString(),
              data: jsonEncode(widget.examDetails.content!.examQuestion),
              route: widget.type,
              time: _remainingTime.toString());
        } else {
          if ((_remainingTime - 1) >= 0) {
            setState(() {
              _remainingTime -= 1;
            });
          } else {
            _remainingTime = 0;
            _submitExamController.submitControl(
                title: widget.title,
                eid: widget.examDetails.content!.editorialId.toString(),
                catId: widget.examDetails.content!.categoryId.toString(),
                id: widget.examDetails.content!.id.toString(),
                data: jsonEncode(widget.examDetails.content!.examQuestion),
                route: widget.type,
                time: _remainingTime.toString());
          }
        }
        setState(() {});
      },
    );
  }

  void pauseTimer() {
    if (_timer != null) {
      setState(() {
        // _remainingTime=0;
        if (_timer.isActive) {
          _timer.cancel();
        } else {
          _remainingTime = _remainingTime;
          _startTimer();
        }
      });
    }
    ;
  }

//submit dailog
  _openSubmitDialog({required String type}) async {
    var examId = int.parse(
        widget.examDetails.content!.examQuestion![selectedQuestion].examId!);

    for (int i = 0; i < widget.examDetails.content!.examQuestion!.length; i++) {
      var element = widget.examDetails.content!.examQuestion![i];
      //   print("========== START $i==========");
      List<int> availableOptions = [];
      element.options?.forEach((options) {
        availableOptions.add(options.id ?? 0);
      });
      if (element.isAttempt == 1 &&
          !availableOptions.contains(element.isSelect)) {
        Fluttertoast.showToast(
            msg:
                "Please select your answer for question number ${i + 1} again.");
        selectedQuestion = i;
        goToQuestion(i);
        removeAnswer(selectedQuestion);
        return;
      }
    }

    var response = await Get.dialog(
        AlertDialog(
          title: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Text(
                    "Time Remaining",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: purpleColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    // "",
                    _printDuration(Duration(seconds: _remainingTime)),
                    style: TextStyle(
                        color: purpleColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          content: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Answered",
                      style: TextStyle(
                          color: greenColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _getAnsweredNumber().toString(),
                      style: TextStyle(
                          color: greenColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Not Answered",
                      style: TextStyle(
                          color: redColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _getNotAnsweredNumber().toString(),
                      style: TextStyle(
                          color: redColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Marked For Review",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _getReviewNumber().toString(),
                      style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              type == "Pause"
                  ? InkWell(
                      onTap: () async {
                        pauseTimer();
                        var result = await _quizDetailsController.pauseExam(
                            id: examId,
                            left: _remainingTime,
                            listData:
                                widget.examDetails.content!.examQuestion ?? []);
                        print("aaa--now is back");
                        Future.delayed(const Duration(seconds: 0), () {
                          Navigator.pop(context, result);
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                              color: purpleColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Obx(() {
                            if (_quizDetailsController.loading.value) {
                              return Center(
                                child: Lottie.asset(
                                    "assets/animations/loader.json",
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
                              );
                            } else {
                              return Text(
                                _quizDetailsController.pauseMessage.value ==
                                            "resume" ||
                                        _quizDetailsController
                                                .pauseMessage.value ==
                                            ""
                                    ? "Pause"
                                    : "Resume",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              );
                            }
                          })))
                  : InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        _timer?.cancel();
                        _submitExamController.submitControl(
                            id: widget.examDetails.content!.id.toString(),
                            eid: widget.examDetails.content!.editorialId
                                .toString(),
                            title: widget.title,
                            catId: widget.examDetails.content!.categoryId
                                .toString(),
                            data: jsonEncode(
                                widget.examDetails.content!.examQuestion),
                            route: widget.type,
                            time: _remainingTime.toString());
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                              color: purpleColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Obx(() {
                            if (_submitExamController.loading.value) {
                              return Center(
                                child: Lottie.asset(
                                  "assets/animations/loader.json",
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                ),
                              );
                            } else {
                              return const Text(
                                "SUBMIT",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              );
                            }
                          })),
                    )
            ]),
          ),
        ),
        barrierDismissible: false);
    print("aaa----$response");
    if (response != null) Navigator.pop(context);
  }

  endDrawerWidget() {
    return Stack(
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: context.width * .70,
              decoration: const BoxDecoration(color: homeColor),
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_profileControllers
                          .profileGet.value.user!.image
                          .toString()),
                    ),
                    title: RegularTextDarkMode(
                      text: _profileControllers.profileGet.value.user!.name
                          .toString(),
                      textSize: 18,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: Colors.blueGrey),
                    child: Row(
                      children: [
                        const Text(
                          "Topic:",
                          style: TextStyle(
                              color: white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            widget.title.toString().capitalize ?? "",
                            maxLines: 4,
                            style: const TextStyle(color: white, fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      labelCreate(Colors.grey, "Not Answered"),
                      labelCreate(Colors.green, "Answered"),
                    ],
                  ),
                  const Divider(),
                  Expanded(child: questionIndexWidget()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: purpleColor,
                            side: BorderSide(color: purpleColor, width: 1),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onPressed: () {
                            _openSubmitDialog(type: "Submit");
                          },
                          child: Text(
                            "Submit Exam",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: whiteColor),
                          )),
                    ),
                  )
                ],
              ),
            )),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 40.0, right: 20),
              child: Icon(
                Icons.cancel_presentation,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget labelCreate(MaterialColor materialColor, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: materialColor, borderRadius: BorderRadius.circular(5)),
        ),
        const SizedBox(
          width: 6,
        ),
        RegularTextDarkMode(
          text: title,
          textSize: 14,
          color: Colors.black,
        )
      ],
    );
  }

  Widget indicateMarks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Que No.${selectedQuestion + 1}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Marks:"),
            const SizedBox(
              width: 6,
            ),
            Container(
              //width: 50,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                  "+ ${widget.examDetails.content?.mark.toString() ?? ""}"),
            ),
            const SizedBox(
              width: 6,
            ),
            Container(
              //width: 50,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                  "- ${widget.examDetails.content?.negativeMark.toString() ?? ""}"),
            )
          ],
        )
      ],
    );
  }

//check by mukesh
  Widget saveRow() {
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
          reportQuestion(),
        ],
      ),
    );
  }

  String? dropdownValue;

  Widget reportQuestion() {
    print("Report Issues $dropdownValue");

    return Container(
      height: 30,
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0), // Border
        // Background color of the dropdown
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          padding: EdgeInsets.zero,
          hint: Text("Report"),
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              print("New Value $newValue");
              dropdownValue = newValue!;
              showDialog(
                  context: context,
                  builder: (context) {
                    return reportDialog();
                  });
              print("New Value $dropdownValue");
            });
          },
          items: reportIssues.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget reportDialog() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dropdownValue.toString(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 30,
                      ))
                ],
              ),
              TextFormField(
                controller: reportQuestionController,
                maxLines: 5,
                // expands: true,
                // maxLines: null,
                // minLines: null,
                decoration: InputDecoration(
                  hintText:
                      "Please Tell us more about the issue (at least 7-8 words) for the quick resolutions",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Divider(
                height: 40,
                color: Colors.grey,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purpleColor,
                      // primary: purpleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      var requestBody = {
                        "exam_id": widget.examDetails.content!.id.toString(),
                        "report_type": dropdownValue.toString(),
                        "message": reportQuestionController.text,
                        "q_id": widget.examDetails.content!
                            .examQuestion![selectedQuestion].id
                            .toString()
                      };
                      _quizDetailsController.reportQuiz(requestBody);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  headerTimerWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
                onTap: () {
                  _openSubmitDialog(type: "Pause");
                },
                child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Obx(() {
                      return Icon(
                        // Icons.play_arrow_rounded,
                        _quizDetailsController.pauseMessage.value == "resume" ||
                                _quizDetailsController.pauseMessage.value == ""
                            ? Icons.pause_circle_outline_outlined
                            : Icons.play_arrow_rounded,
                        color: Colors.indigo,
                        size: 30,
                      );
                    }))),
            const Text(
              "Time Left : ",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _printDuration(Duration(seconds: _remainingTime)),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
                  Get.back();
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
  Widget questionWidget() {
    return QuestionWidget(questionString:_examQuestion[selectedQuestion].eQuestion.toString() ,);

  }

//check by mukesh
  Widget optionsWidget() {
    return widget.reviewExam == false
        ? Container(
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
                      giveAnswer(selectedQuestion, j);
                    },
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                /// check wheter selected option is selected or not
                                color: (_examQuestion[selectedQuestion]
                                            .options![j]
                                            .id ==
                                        _examQuestion[selectedQuestion].isSelect)
                                    ? greenColor
                                    : Colors.grey,
                                offset: const Offset(0.0, 1.0), //(x,y)
                                blurRadius: 4.0,
                              ),
                            ],
                            border: Border.all(
                                color: (_examQuestion[selectedQuestion]
                                            .options![j]
                                            .id ==
                                        selectedOption)
                                    ? greenColor
                                    : whiteColor,
                                width: 2),
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(
                            left: 10, top: 5, bottom: 5, right: 10),
                        child: Row(
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
                                        color: blackColor,
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
                                        child: /* CustomDmSans(
                                fontSize: 16,
                                color: blackColor,
                                text: _htmlConverter
                                    .removeAllHtmlTags(_examQuestion[
                                selectedQuestion]
                                    .options![j]
                                    .optionE
                                    .toString()),
                              )*/
                                            Text(
                                          _htmlConverter.removeAllHtmlTags(
                                              _examQuestion[selectedQuestion]
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
                        )),
                  );
                })))
        : Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                    _examQuestion[selectedQuestion].options!.length, (j) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: getGoToOptionColor(j, 1),
                                offset: const Offset(0.0, 1.0), //(x,y)
                                blurRadius: 4.0,
                              ),
                            ],
                            border: Border.all(
                                color: getGoToOptionColor(j, 0), width: 2),
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(
                            left: 10, top: 5, bottom: 5, right: 10),
                        child: Row(
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
                                        child: /*CustomDmSans(
                                text: _htmlConverter
                                    .removeAllHtmlTags(_examQuestion[
                                selectedQuestion]
                                    .options![j]
                                    .optionE
                                    .toString()),
                              )*/
                                            Text(
                                          _htmlConverter.removeAllHtmlTags(
                                              _examQuestion[selectedQuestion]
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
                        )),
                  );
                })));
  }

  Color getGoToOptionColor(int j, int Type) {
    ///correct
    if (widget.examDetails.content!.examQuestion![selectedQuestion].options![j]
                .correct ==
            1 &&
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j]
                .checked ==
            1) {
      return lightGreenColor;
    }

    ///wrong
    else if (widget.examDetails.content!.examQuestion![selectedQuestion]
                .options![j].correct ==
            0 &&
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j]
                .checked ==
            1) {
      return redColor;
    }

    ///default
    else if (widget.examDetails.content!.examQuestion![selectedQuestion]
                .options![j].correct ==
            0 &&
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j]
                .checked ==
            0) {
      ///border color
      if (Type == 1) {
        return greyColor;
      }
      //container color
      else {
        return whiteColor;
      }
    } else if (widget.examDetails.content!.examQuestion![selectedQuestion]
            .options![j].correct ==
        1) {
      return lightGreenColor;
    }
    return Colors.transparent;
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
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                side: const BorderSide(
                                    color: Colors.purple, width: 1),
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
              widget.reviewExam == false
                  ? Container(
                      margin: const EdgeInsets.all(0),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: redColor,
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                          ),
                          onPressed: () {
                            removeAnswer(selectedQuestion);
                          },
                          child: const Text(
                            "Clear",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )))
                  : const SizedBox(),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: (selectedQuestion == null
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.all(0),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: greenColor,
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                              ),
                              onPressed: () {
                                viewNextQuestion(
                                    option: selectedOption.toString());
                              },
                              child: widget.reviewExam == false
                                  ? Text(
                                      selectedQuestion + 1 <
                                              _examQuestion.length
                                          ? "Save & Next"
                                          : "Submit Exam",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: whiteColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      selectedQuestion + 1 <
                                              _examQuestion.length
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

  backToQuiz() {
    if (widget.type == 2) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => DashboardPage()),
          (route) => false);
    }
    // if its came from daily Quiz Category
    else if (widget.type == 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => DashboardPage(
                    index: 2,
                  )),
          (route) => false);

      // Navigator.of(context).pop();
    }
    //from editorials
    else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => EditorialsPage()),
          (route) => false);
    }
  }
}
