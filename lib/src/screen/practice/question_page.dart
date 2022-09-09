import 'dart:ui';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/controllers/exam_details/quiz_details.dart';
import 'package:english_madhyam/src/helper/controllers/quiz_list_controller/quiz_list.dart';
import 'package:english_madhyam/src/helper/controllers/submit_exam/submit_exam.dart';
import 'package:english_madhyam/src/helper/model/quiz_details.dart';
import 'package:english_madhyam/src/screen/bottom_nav/bottom_nav.dart';
import 'package:english_madhyam/src/screen/editorials_page/editorials_page.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/converter.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
class QuestionPage extends StatefulWidget {
  final ExamDetails examdetails;
  final Title;
  final bool ReviewExam;
  final int type;

  const QuestionPage({Key? key,required this.Title,required this.type, required this.examdetails,required this.ReviewExam}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {

  final SubmitExamController _submitExamController = Get.put(SubmitExamController());
  final QuizDetailsController _quizDetailsController =
      Get.put(QuizDetailsController());
  final HtmlConverter _htmlConverter = HtmlConverter();
  final QuizListController _controller=Get.put(QuizListController());

  int _takenTime = 0;
  StateSetter? _set;
  String cattitle="";


  late Timer _timer;

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  //Colors for question list
  Color getGoToColor(int j) {
    if(widget.ReviewExam==false){
      //color for marked question
      if (widget.examdetails.content!.examQuestion![j].mark == 1) {
        return purpleColor;
      }
      // color for attempted question
      if (widget.examdetails.content!.examQuestion![j].ansType == 1 || widget.examdetails.content!.examQuestion![j].isAttempt==1) {
        return lightGreenColor;
      }
      //default color for un answered
      return greyColor;
    }
    else if(widget.ReviewExam==true){
      if(widget.examdetails.content!.examQuestion![j].isAttempt==1){
        for(int i=0;i<widget.examdetails.content!.examQuestion![j].options!.length;i++){
          if(widget.examdetails.content!.examQuestion![j].options![i].correct==1 && widget.examdetails.content!.examQuestion![j].options![i].checked==1){
            return lightGreenColor;
          }else if(widget.examdetails.content!.examQuestion![j].options![i].correct==1 && widget.examdetails.content!.examQuestion![j].options![i].checked==0){
            return redColor;
          }

        }
      }

    }
    //default color for un answered
    return greyColor;



  }

// to Select the Questiuon
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
  giveAnswer(int i, int option) async {
    if (option < _examQuestion[i].options!.length && option >= 0) {
      for (int k = 0; k < _examQuestion[i].options!.length; k++) {
        _examQuestion[i].options![k].checked = 0;
      }
      _examQuestion[i].options![option].checked = 1;
      _examQuestion[i].ansType = 1;
      setState(() {
        selectedOption = _examQuestion[i].options![option].id!;
        _examQuestion[i].isSelect =  _examQuestion[i].options![option].id ;
        _examQuestion[selectedQuestion].isAttempt =  1 ;


      });
    } else {
      Fluttertoast.showToast(msg: "Option not exist");
      cancel();

    }
  }

//Total Answered number
  int _getAnsweredNumber() {
    int _answered = 0;
    widget.examdetails.content!.examQuestion!.forEach((examQuestion) {
        if (examQuestion.ansType == 1) {
          _answered += 1;

      }
    });
    return _answered;
  }

  //Total Review Question

  int _getReviewNumber() {
    int _answered = 0;
    widget.examdetails.content!.examQuestion!.forEach((examQuestion) {
        if (examQuestion.mark == 1) {
          _answered += 1;
        }

    });
    return _answered;
  }

  //Total not Answeres QUESTION

  int _getNotAnsweredNumber() {
    int _answered = 0;
    widget.examdetails.content!.examQuestion!.forEach((examQuestion) {
        if (examQuestion.ansType != 1) {
          _answered += 1;

      }
    });
    return _answered;
  }

//View Next Questiojn
  viewNextQuestion({required String Option}) {
    //Exam started
   if (widget.ReviewExam==false){
     //if selected question is less than total questions
     if ((selectedQuestion + 1) < _examQuestion.length) {
       setState(() {
         selectedQuestion += 1;
       });
       // if option is selected
       if(selectedOption!=0){
         _quizDetailsController.QuestionAttemptContr(
             id: widget.examdetails.content!.id!.toString(),
             left: _remainingTime.toString(),
             QId: widget.examdetails.content!.examQuestion![selectedQuestion-1].id.toString(),
             OId: Option);
         _examQuestion[selectedQuestion-1].isSelect =  int.parse(Option) ;
         _examQuestion[selectedQuestion-1].isAttempt =  1 ;

       }
       //other wise select an option
       else{
         Fluttertoast.showToast(msg: "Select an Option");
         cancel();

       }
       setState(() {
         selectedOption = 0;
       });
     } else {
       //if question is last the exam is submit by clicking on this button


           _timer.cancel();
           _openSubmitDialog(type: "submit");
           setState(() {
             selectedOption = 0;
           });



     }
   }
   //Exam Reviewing
   else{
     if ((selectedQuestion + 1) < _examQuestion.length) {
       setState(() {
         selectedQuestion += 1;
       });

     } else {
       //if question is last the exam is submit by clicking on this button

         Fluttertoast.showToast(msg: "No next question found");
         cancel();
          // Get.offAll(()=> PerformanceReport(id: widget.examdetails.content!.id!.toString(),
          //   Route: widget.type,catid: widget.examdetails.content!.isDailyQuiz==1?widget.examdetails.content!.categoryId.toString():
          //   widget.examdetails.content!.editorialId!.toString(),title:  widget.Title,));
         // Navigator.of(context).pushAndRemoveUntil(
         //     MaterialPageRoute(builder: (ctx)=>
         //        ),
         //         (Route<dynamic>route) => true);


     }
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
setState(() {
  _examQuestion[i].options![k].checked = 0;
  _examQuestion[i].isAttempt=0;
});

      }
      setState(() {
        _examQuestion[i].ansType = 0;

      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();

    }
  }

//Mark for review
  markForReview(int i) {
    if (i < _examQuestion.length && i >= 0) {
      setState(() {
        _examQuestion[i].mark = 1;
      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();

    }
  }

  //UnMark Review

  unMarkForReview(int i) {
    if (i < _examQuestion.length && i >= 0) {
      setState(() {
        _examQuestion[i].mark = 0;
      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();

    }
  }

//Submit Report
//   _submitReport({ required int value,required int index}){
//     setState(() {
//       _examQuestion[index].re=value;
//     });
//   }

  Future<bool>exitdialog() async{
    String title="";
    return await Get.defaultDialog(
      title: "Do you really want to exit?",
      textCancel: "Cancel",
      textConfirm: "Confirm",
      barrierDismissible: false,
      onConfirm: (){
        // if its came from home daily Quiz
       if(widget.type==2){
         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=>const BottomWidget()), (route) => false);
       }
       // if its came from daily Quiz Category
       else if(widget.type==1){
         Navigator.of(context).pushAndRemoveUntil(

           MaterialPageRoute(
               builder: (context) =>
                   const BottomWidget(index: 2,)
           ), (route) => false);

         // Navigator.of(context).pop();
       }
       //from editorials
       else {
         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=>EditorialsPage()), (route) => false);
       }
      },
      onCancel: () {
      },
      buttonColor: redColor,
      cancelTextColor: redColor,
      confirmTextColor: whiteColor,
      contentPadding: const EdgeInsets.all(12),
      content:  Text(_quizDetailsController.pausemessage.value=="resume"?"By Confirm you are submitting your Exam":"Are You Confirm"),

    );
  }


//Start timer

  _startTimer() {
    _timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (Timer timer) {
        if (_remainingTime <= 0) {

          timer.cancel();
          _submitExamController.SubmitControl(
            eid: widget.examdetails.content!.editorialId!.toString(),
              id: widget.examdetails.content!.id.toString(),
              data: jsonEncode(widget.examdetails.content!.examQuestion),
              title: widget.Title,
              route: widget.type,
              catId:widget.examdetails.content!.categoryId.toString(),
              time: _remainingTime.toString());
        } else {
          if ((_remainingTime - 1) >= 0) {
     setState(() {
       _remainingTime -= 1;
     });
            _takenTime += 1;
          } else {
            _remainingTime = 0;
            _submitExamController.SubmitControl(
                title: widget.Title,
                eid: widget.examdetails.content!.editorialId.toString(),
                catId:widget.examdetails.content!.categoryId.toString(),
                id: widget.examdetails.content!.id.toString(),
                data: jsonEncode(widget.examdetails.content!.examQuestion),
                route: widget.type,
                time: _remainingTime.toString()
            );
          }
        }
        setState(() {});
      },
    );
  }

  void pauseTimer() {
    if (_timer != null)
    {
     setState(() {
       // _remainingTime=0;
       if(_timer.isActive){
         _timer.cancel();
       }else{

         _remainingTime=_remainingTime;
         _startTimer();

       }

     });
    };
  }

//submit dailog

  _openSubmitDialog({required String type}) {
    showDialog(
      barrierDismissible: type == "Pause"?false:true,
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (context,StateSetter _set) {
            _set=  setState;
            return AlertDialog(



                  title: Column(
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
                            color: blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
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
                              style: const TextStyle(
                                  color: Colors.black,
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
                               style:const TextStyle(
                                   color: Colors.black,
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
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      type == "Pause"
                          ? InkWell(
                              onTap: () {
                                // pauseTimer();
                                _set(() {

                                  _quizDetailsController.pauseExam(
                                      id: int.parse(widget.examdetails.content!.examQuestion![selectedQuestion].examId!),
                                      left: _remainingTime);
                                  _quizDetailsController.pausemessage.value=="resume"&&_quizDetailsController.pausemessage.value==""?
                                  _quizDetailsController.pausemessage.value="Exam Paused!":_quizDetailsController.pausemessage.value="resume";
                                  _quizDetailsController.pausemessage.value=="resume"&&_quizDetailsController.pausemessage.value==""? pauseTimer()
                                    :pauseTimer();
                                  Get.back();
                                });

                                // _quizDetailsController.message.value==""
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: purpleColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child:
                              Obx((){
                                if(_quizDetailsController.loading.value)
                                  {
                                    return  Center(
                                      child: Lottie.asset(
                                          "assets/animations/loader.json",
                                          height:
                                          MediaQuery.of(context).size.height * 0.05),
                                    );
                                  }
                                else{
                                  return Text(
                                    _quizDetailsController.pausemessage.value=="resume"||_quizDetailsController.pausemessage.value==""?"Pause":"Resume",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  );
                                }

                              })


                            ))
                          : InkWell(
                              onTap: () {
                                _submitExamController.SubmitControl(
                                    id: widget.examdetails.content!.id
                                        .toString(),
                                    eid: widget.examdetails.content!.editorialId.toString(),

                                    title: widget.Title,
                                    catId:widget.examdetails.content!.categoryId.toString(),
                                    data: jsonEncode(widget
                                        .examdetails.content!.examQuestion),
                                    route: widget.type,
                                    time: _remainingTime.toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: purpleColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Obx((){
                                  if(_submitExamController.loading.value){
                                    return Center(
                                      child: Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.04,),
                                    );
                                  }else{
                                    return Text(
                                      "SUBMIT",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                    );
                                  }
                                })
                              ),
                            )
                    ]),
                  ),
                );
          }
        ));
  }


  final bool _checkReview = false;
  late List<ExamQuestion> _examQuestion;
  final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  int selectedQuestion = 0;
  int selectedOption = 0;
  int _remainingTime = 0;

  // void is_paused(){
  //   if(_quizDetailsController.quizDetail.value.content!.isAttempt==1){
  //     _examQuestion.forEach((element) {
  //       if(element.isAttempt==1 && element.isSelect!=0){
  //         element.isSelect=element.
  //       }
  //     })
  //   }
  //
  // }

  @override
  void initState() {
    // TODO: implement initState

_examQuestion = widget.examdetails.content!.examQuestion!;

  if(widget.ReviewExam==false){

    if(widget.examdetails.content!.timeLeft==""){
      _remainingTime =
          int.parse(widget.examdetails.content!.duration!) * 60;
    }else{

      _remainingTime = int.parse(widget.examdetails.content!.timeLeft!.toString());
    }

    _startTimer();
  }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.ReviewExam==false?
    Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  _openSubmitDialog(type: "Pause");
                },
                child:  Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Obx((){
                    return  Icon(
                      // Icons.play_arrow_rounded,
                      _quizDetailsController.pausemessage.value=="resume"||_quizDetailsController.pausemessage.value==""? Icons.pause_circle_outline_outlined:Icons.play_arrow_rounded,
                      color: Colors.indigo,
                      size: 30,);
                  })
                )),
            const Text(
              "Time Left : ",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _printDuration(Duration(seconds: _remainingTime)),
              style: TextStyle(
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              _openSubmitDialog(type: "Submit");
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: purpleColor, borderRadius: BorderRadius.circular(6)),
              child: Text(
                "Submit Exam",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: whiteColor),
              ),
            ),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: exitdialog,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 50,
                decoration: BoxDecoration(color: whiteColor, boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 3),
                      color: greyColor.withOpacity(0.5),
                      blurRadius: 2)
                ]),
                child: questionlist(),
              ),
              reportMarkRow(),
              Question(),
              Options(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),


              bottomButtons(),
            ],
          ),
        ),
      ),
    ):
    Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: _examQuestion.isEmpty?
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(child: Column(
                children: [
                  Image.asset("assets/img/norecord.jpg"),
                  CustomDmSans(
                    text: "Solution is no longer available!!",
                    fontSize: 20,
                    )
                ],
              )),
            ):
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: 50,
              decoration: BoxDecoration(color: whiteColor, boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 3),
                    color: greyColor.withOpacity(0.5),
                    blurRadius: 2)
              ]),
              child: questionlist(),
            ),
            reportMarkRow(),
            Question(),
            Options(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(child: Column(
                children: [
                  CustomDmSans(text: "Solutions :",color: greenColor,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomDmSans(text: _htmlConverter.parseHtmlString(_examQuestion[selectedQuestion].solutions!.eSolutions!)),
                  ),
                ],
              )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            bottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget questionlist() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
          widget.examdetails.content!.examQuestion!.length, (i) {
        return Container(
          padding: const EdgeInsets.all(5),
          width: 40,
          child: InkWell(
              onTap: () {},
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
              )),
        );
      }),
    );
  }

  Widget reportMarkRow() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          // InkWell(
          //   onTap: (){
          //     _openReportDialog();
          //   },
          //   child: Container(
          //     padding: EdgeInsets.only(
          //         left: 10,
          //         right: 10,
          //         top: 2,
          //         bottom: 2),
          //     decoration: BoxDecoration(
          //         borderRadius:
          //         BorderRadius.circular(100),
          //         border: Border.all(
          //             color: Colors.grey, width: 1)),
          //     child: Row(
          //       children: [
          //         CustomDmSans(
          //          text: "Report",
          //
          //               fontSize: 14,
          //               color: Colors.grey,
          //               fontWeight: FontWeight.w500),
          //
          //         SizedBox(
          //           width: 5,
          //         ),
          //         Icon(
          //           Icons.warning_amber_outlined,
          //           size: 20,
          //           color: Colors.grey,
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          Spacer(),
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
              padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
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
                          ? "Mark"
                          : "UnMark",
                      fontSize: 14,
                      color: (_examQuestion[selectedQuestion].mark == 0)
                          ? Colors.grey
                          : purpleColor,
                      fontWeight: FontWeight.w500),
                  SizedBox(
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

  Widget Question() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Html(
data:   _examQuestion[selectedQuestion].eQuestion.toString(),
        style:{
          "body": Style(
            fontSize: const FontSize(18.0),
          ),
          "p":Style(fontSize: const FontSize(18.0))
    },)
      // child: CustomDmSans(
      //   text: (selectedQuestion + 1).toString() +
      //       " . " +
      //       _htmlConverter.parseHtmlString(
      //           _examQuestion[selectedQuestion].eQuestion.toString().replaceAll("&ndash;", "").replaceAll("&rsquo;", "'")),
      //   color: blackColor,
      //   fontWeight: FontWeight.w500,
      // ),
    );
  }

  Widget Options() {
    return widget.ReviewExam==false?Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
                _examQuestion[selectedQuestion].options!.length, (j) {
              return InkWell(
                onTap: () {
                  giveAnswer(selectedQuestion, j);

                },
                child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: (_examQuestion[selectedQuestion]
                                .options![j]
                                .checked ==
                                1)?
                            greenColor: Colors.grey,
                            offset: const Offset(0.0, 1.0), //(x,y)
                            blurRadius: 4.0,
                          ),
                        ],
                        border: Border.all(
                            color: (_examQuestion[selectedQuestion]
                                        .options![j]
                                        .checked ==
                                    1)?
                                 greenColor
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
                          child: Center(
                            child: Text(chars[j],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: greyColor,
                                    fontWeight: FontWeight.w600)),
                          ),
                          width: 30,
                          height: 30,
                        ),
                        (_examQuestion[selectedQuestion].options![j].optionE ==
                                null)
                            ? const Text("")
                            : Expanded(

                              child: Container(
                                  padding: const EdgeInsets.only(left: 5, right: 5),
                                  child: CustomDmSans(
                                    text: _htmlConverter.removeAllHtmlTags(
                                        _examQuestion[selectedQuestion]
                                            .options![j]
                                            .optionE
                                            .toString()),
                                  )),
                            ),
                      ],
                    )),
              );
            }))):Container(
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
                            color: getGoToOptionColor(j,1),
                            offset: const Offset(0.0, 1.0), //(x,y)
                            blurRadius: 4.0,
                          ),
                        ],
                        border: Border.all(
                            color: getGoToOptionColor(j,0),
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
                          child: Center(
                            child: Text(chars[j],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: greyColor,
                                    fontWeight: FontWeight.w600)),
                          ),
                          width: 30,
                          height: 30,
                        ),
                        (_examQuestion[selectedQuestion].options![j].optionE ==
                            null)
                            ? const Text("")
                            : Expanded(

                          child: Container(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: CustomDmSans(
                                text: _htmlConverter.removeAllHtmlTags(
                                    _examQuestion[selectedQuestion]
                                        .options![j]
                                        .optionE
                                        .toString()),
                              )),
                        ),
                      ],
                    )),
              );
            })));
  }
  Color getGoToOptionColor(int j,int Type) {


//correct
    if(widget.examdetails.content!.examQuestion![selectedQuestion].options![j].correct==1 && widget.examdetails.content!.examQuestion![selectedQuestion].options![j].checked==1){

      return lightGreenColor;
    }
    //wrong
    else if(widget.examdetails.content!.examQuestion![selectedQuestion].options![j].correct==0 && widget.examdetails.content!.examQuestion![selectedQuestion].options![j].checked==1)
    {
      return redColor;
    }
    //defalt
    else if(widget.examdetails.content!.examQuestion![selectedQuestion].options![j].correct==0 && widget.examdetails.content!.examQuestion![selectedQuestion].options![j].checked==0){
      //border color
      if(Type==1){
        return greyColor;
      }
      //container color
      else{
        return whiteColor;
      }

    }else if(widget.examdetails.content!.examQuestion![selectedQuestion].options![j].correct==1){
      return lightGreenColor;
    }
return Colors.transparent;



    // if(widget.examdetails.content!.examQuestion![selectedQuestion].options![j].correct == 1){
    //   if(widget.examdetails.content!.examQuestion![selectedQuestion].options![j].checked == 1){
    //     return lightGreenColor;
    //   }else{
    //     return lightGreenColor;
    //   }
    // }else{
    //   if(widget.examdetails.content!.examQuestion![selectedQuestion].options![j].checked == 1){
    //     return redColor;
    //   }else{
    //     return Type==1?greyColor:whiteColor;
    //   }
    // }
    // if (widget.examdetails.content!.examQuestion![selectedQuestion].options![j].correct == 1&&widget.examdetails.content!.examQuestion![selectedQuestion].options![j].checked==1) {
    //   return lightGreenColor;
    // }
    // if (widget.examdetails.content!.examQuestion![selectedQuestion].options![j].correct == 1&&widget.examdetails.content!.examQuestion![selectedQuestion].options![j].checked==0) {
    //   return redColor;
    // }if (widget.examdetails.content!.examQuestion![selectedQuestion].options![j].correct == 1) {
    //   return lightGreenColor;
    // }
    // if (widget.examdetails.content!.examQuestion![selectedQuestion].options![j].correct == 0&&widget.examdetails.content!.examQuestion![selectedQuestion].options![j].checked==1) {
    //   return redColor;
    // }
    // return Type==1?greyColor:whiteColor;
  }
  Widget bottomButtons() {
    return Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ], color: whiteColor),
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: (selectedQuestion == null || selectedQuestion <= 0)
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              viewPrevQuestion();
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(02),
                                  border:
                                      Border.all(color: purpleColor, width: 2)),
                              child: const Text(
                                "Previous",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              widget.ReviewExam==false?InkWell(
                onTap: () {
                  removeAnswer(selectedQuestion);
                },
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: seaGreenColor, width: 2)),
                  child: const Text(
                    "Clear",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ):SizedBox(),
              Expanded(
                  child: (selectedQuestion == null
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                viewNextQuestion(
                                    Option: selectedOption.toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 2, bottom: 2),
                                decoration: BoxDecoration(
                                    color: purpleColor,
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                        color: purpleColor, width: 2)),
                                child: widget.ReviewExam==false?Text(
                                  selectedQuestion+1<_examQuestion.length?"Save & Next":"Submit Exam",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold),
                                ):Text(
                                  selectedQuestion+1<_examQuestion.length?"Next":"End",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        )))
            ],
          ),
        ));
  }
}
