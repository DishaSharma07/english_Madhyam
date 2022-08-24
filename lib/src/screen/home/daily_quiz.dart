import 'package:english_madhyam/src/helper/controllers/exam_details/quiz_details.dart';
import 'package:english_madhyam/src/helper/model/home_model/home_model.dart';
import 'package:english_madhyam/src/screen/practice/instructions.dart';
import 'package:english_madhyam/src/screen/practice/performance_report.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class DailyQuiz extends StatefulWidget {
  final List<Quizz> quiz;
  const DailyQuiz({Key? key, required this.quiz}) : super(key: key);

  @override
  _DailyQuizState createState() => _DailyQuizState();
}

class _DailyQuizState extends State<DailyQuiz> {
  final QuizDetailsController Quizcontroller=Get.put(QuizDetailsController());

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.quiz.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext ctx, int index) {
          return InkWell(
            onTap: (){
             if(widget.quiz[index].completed==0){

               Quizcontroller.examids(
                   widget.quiz[index].id);
               Get.to(() =>  TestInstructions(examid: widget.quiz[index].id!,title: widget.quiz[index].title.toString(),catTitle:widget.quiz[index].category_name! ,type: 2,));
             }else{
               Get.to(()=>PerformanceReport(
                   id: widget.quiz[index].id.toString(),
                 eid: "",
                 Route: 2,

                ));
             }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.88,
              margin: const EdgeInsets.only(right: 10, bottom: 4),
              padding:
                  const EdgeInsets.only(top: 10, bottom: 8, left: 10, right: 8),
              decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                        color: greyColor.withOpacity(0.5),
                        blurRadius: 1,
                        offset: const Offset(2, 4))
                  ],
                  border: Border.all(color: greyColor.withOpacity(0.2), width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeYellowColor.withOpacity(0.15),
                    image:widget.quiz[index].image != ""? DecorationImage(image: NetworkImage( widget.quiz[index].image.toString(),),
                        scale: 1.2,
                        fit: BoxFit.cover):const DecorationImage(image: AssetImage("assets/img/place_holder.png"),scale: 1.2,fit: BoxFit.cover)),

                    // child: widget.quiz[index].image != ""
                    //     ? Image.network(
                    //         widget.quiz[index].image.toString(),
                    //         colorBlendMode: BlendMode.colorBurn,
                    //         scale: 1.2,
                    //     fit: BoxFit.cover
                    //       )
                    //     : Image.asset("assets/img/place_holder.png" ,),
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
                          widget.quiz[index].title!.length>25?widget.quiz[index].title!.substring(0,28)+"..":widget.quiz[index].title!,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: blackColor),
                        ),
                        Expanded(

                          child: Row(
                            children: [
                              Text(
                                widget.quiz[index].totalQuestion!.toString()+" Question.",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: greyColor),
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
                                          color: greyColor),
                                    )
                                  : const Text(""),
                              const SizedBox(
                                width: 8,
                              ),
                              widget.quiz[index].category_name!=null?Expanded(

                                child: Text(widget.quiz[index].category_name!.length>20?widget.quiz[index].category_name!.substring(0,12)+"..":widget.quiz[index].category_name.toString(),maxLines:2,style:  GoogleFonts.lato(
                                    fontSize: 12,

                                    fontWeight: FontWeight.w500,
                                    color: purpleColor),),
                              ):SizedBox()
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
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
                              )
                            ],
                          ),
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
