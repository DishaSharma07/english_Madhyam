import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:english_madhyam/src/helper/controllers/quiz_list_controller/quiz_list.dart';
import 'package:english_madhyam/src/screen/practice/practice.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class DailyQuizCategory extends StatefulWidget {
  const DailyQuizCategory({Key? key}) : super(key: key);

  @override
  State<DailyQuizCategory> createState() => _DailyQuizCategoryState();
}

class _DailyQuizCategoryState extends State<DailyQuizCategory> {
  final QuizListController _controller=Get.find();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  List<String> color = [
    "#EDF6FF",
    "#FFDDDD",
    "#F6F4FF",
    "#EBFFE5",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
backgroundColor: purpleColor,
        title: CustomDmSans(text: "Daily Quizzes",fontSize: 16,),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx((){
          if(_controller.isDataProcessing.value==true){
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              alignment: Alignment.center,
              child: Lottie.asset("assets/animations/loader.json",
                  height: MediaQuery.of(context).size.height * 0.2),
            );
          }
          else{
            if(_controller.quizListing.isEmpty){
              return Container(
                height: MediaQuery.of(context).size.height * 0.5,
                alignment: Alignment.center,
                child: Lottie.asset('assets/animations/49993-search.json',
                    height: MediaQuery.of(context).size.height * 0.2),
              );
            }
            else{
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: _controller.getTask,
                child: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 4),
                    itemCount: _controller.quizListing.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return InkWell(
                        onTap: () {

                          Get.to(
                                ()=> Practice(
                            title: _controller.quizListing[index].name! ,
                            id: _controller.quizListing[index].id!.toString(),),
                            );
                          _controller.quizListingQuiz.clear();
                          _controller.page=1;
                          _controller.getTaskQuiz(cat: _controller.quizListing[index].id!.toString(),);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: greyColor.withOpacity(0.8),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  offset: const Offset(-4, 4))
                            ],
                            color: Color(
                                hexStringToHexInt(color[index % 4])),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                          greyColor.withOpacity(0.7),
                                          spreadRadius: 0.0,
                                          blurRadius: 5,
                                          offset: const Offset(-3, 3))
                                    ],
                                    image: DecorationImage(image: NetworkImage(_controller.quizListing[index].image.toString()),fit: BoxFit.cover)
                                ),

                                padding: const EdgeInsets.only(
                                    left: 4.0, right: 4),
                                height: MediaQuery.of(context).size.height*0.123,
                              ),

                              Text(
                              _controller.quizListing[index].name!.length>20?_controller.quizListing[index].name!.substring(0,18)+"..":_controller.quizListing[index].name!,
                                maxLines:2,

                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );

            }
          }
        })));



  }
}
