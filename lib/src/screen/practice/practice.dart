import 'package:english_madhyam/src/helper/controllers/exam_details/quiz_details.dart';
import 'package:english_madhyam/src/helper/controllers/quiz_list_controller/quiz_list.dart';
import 'package:english_madhyam/src/screen/practice/instructions.dart';
import 'package:english_madhyam/src/screen/practice/performance_report.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Practice extends StatefulWidget {
  final String title;
  final String id;
  const Practice({Key? key,required this.title,required this.id}) : super(key: key);

  @override
  _PracticeState createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  final QuizDetailsController Quizcontroller=Get.put(QuizDetailsController());

  final QuizListController controller=Get.find();

  List<String> color = [
    "#DBDDFF",
    "#FFDDDD",
    "#F5E8FF",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller.quizzesList(cat: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPurpleColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,leading: BackButton(color: blackColor,),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomDmSans(
            text: widget.title,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
        ),
      ),
      body: Obx((){
        if(controller.isDataProcessing.value==false){
          if(controller.quizListingQuiz.isEmpty){

            Future.delayed(const Duration(seconds: 3)).then((value) {
              return SizedBox(
                height: MediaQuery.of(context).size.height*0.8,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/animations/49993-search.json',
                          height: MediaQuery.of(context).size.height * 0.2),
                      CustomDmSans(text: "No Editorials ",color: blackColor,)
                    ],
                  ),
                ),
              );
            });
            return Center(
              child: Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.2,),
            );

          }else{
            return   ListView.builder(
                controller: controller.quizListScroll,
                itemCount: controller.quizListingQuiz.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(controller.quizListingQuiz[index].completed==true){
                            Get.to(()=>PerformanceReport(
                              id: controller.quizListingQuiz[index].id!.toString(),
                              catid: widget.id.toString(),
                              eid: "",
                              title: widget.title.toString(),
                              Route: 1,
                            )
                            );
                          }else{
                            Quizcontroller.examids( controller.quizListingQuiz[index].id!);

                            Get.to(() =>  TestInstructions(catTitle:widget.title ,examid: controller.quizListingQuiz[index].id!,title: controller.quizListingQuiz[index].title.toString(),type: 1,));
                          }

                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, top: 15, bottom: 0),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(hexStringToHexInt(color[index % 3])),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  color: Colors.grey.shade400,
                                  offset: const Offset(0, 5))
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: purpleColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: SvgPicture.asset("assets/icon/clock_timer.svg"),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomDmSans(
                                        text: controller.quizListingQuiz[index].title.toString(),
                                        color: blackColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(right: 20.0, top: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              controller.quizListingQuiz[index].totalQuestions.toString() + " Ques",
                                              style: GoogleFonts.dmSans(
                                                  color: darkGreyColor),
                                            ),
                                            CircleAvatar(
                                              backgroundColor: greyColor,
                                              maxRadius: 2,
                                            ),
                                            Text(
                                              controller.quizListingQuiz[index].duration.toString() + " Mins",
                                              style: GoogleFonts.dmSans(
                                                  color: darkGreyColor),
                                            ),
                                            CircleAvatar(
                                              backgroundColor: greyColor,
                                              maxRadius: 2,
                                            ),
                                            Text(

                                              controller.quizListingQuiz[index].mark.toString()+ " Marks",
                                              style: GoogleFonts.dmSans(
                                                  color: darkGreyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      controller.isMoreDataAvailable.value==true? Center(
                        child:
                        Lottie.asset("assets/animations/loader.json"),
                      ):const SizedBox(),
                    ],
                  );
                });
          }
        }else{
          return Center(
            child: Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.2,),
          );
        }
      }),
      // body: GetX<QuizListController>(
      //     init: QuizListController(),
      //   builder: (_) {
      //
      //   }
      // ),
    );
  }
}
