import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/src/custom/semiBoldTextView.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/favorite/controller/favoriteController.dart';
import 'package:english_madhyam/src/screen/favorite/model/questionDataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';

import 'package:english_madhyam/resrc/widgets/regularTextView.dart';


import '../../../utils/colors/colors.dart';
import '../../../widgets/question_widget.dart';
import '../../pages/page/converter.dart';
import '../../pages/page/custom_dmsans.dart';

class SaveQuestionList extends GetView<FavoriteController> {
  static const name = "SaveQuestionList";
  final String categoryId;
  SaveQuestionList({Key? key,required this.categoryId}) : super(key: key);

  final FavoriteController favoriteController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final HtmlConverter _htmlConverter = HtmlConverter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ToolbarTitle(title: "My Questions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetX<FavoriteController>(builder: (contr) {
          return Stack(
            children: [
              listBodyWidget(saveWordsList: contr.saveQuestionList),
              contr.loading.value ? const Loading() : const SizedBox(),
              !contr.loading.value && contr.saveQuestionList.isEmpty
                  ? const Center(
                      child: Text("No Data Found"),
                    )
                  : const SizedBox()
            ],
          );
        }),
      ),
    );
  }

  Widget listBodyWidget({required List<dynamic> saveWordsList}) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: saveWordsList.length,
          itemBuilder: (context, index) {
            QuestionData questionData = saveWordsList[index];
            return Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0,1),
                  blurRadius: 3
                )],
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,

              ),


              margin: const EdgeInsets.only(
                  left: 10, right: 0, bottom: 5, top: 10),

              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text("Que.",style: TextStyle(
                                  fontSize:18.0,


                              ),),
                              Expanded(
                              child: QuestionWidget(questionString:questionData.eQuestion.toString(),)


            // child: Html(
            //
            //                       data: questionData.eQuestion.toString(),
            //                       style: {
            //                         "body": Style(
            //                             fontSize: FontSize(18.0),
            //                             textAlign: TextAlign.justify
            //
            //                         ),
            //                         "p": Style(fontSize: FontSize(18.0),
            //                             textAlign: TextAlign.justify
            //                         )
            //                       },
            //                     ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: GestureDetector(
                            onTap: () async {
                              await controller.removeQuestionFromList(
                                  context: context,
                                  questionId: questionData.id.toString() ?? "");
                              saveWordsList.removeAt(index);
                              controller.update();
                            },
                            child: const Icon(
                              Icons.bookmark,
                              color: primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // ListTile(
                  //   title: Html(
                  //
                  //     data: questionData.eQuestion.toString(),
                  //     style: {
                  //       "body": Style(
                  //         fontSize: FontSize(18.0),
                  //         textAlign: TextAlign.justify
                  //
                  //       ),
                  //       "p": Style(fontSize: FontSize(18.0),
                  //           textAlign: TextAlign.justify
                  //       )
                  //     },
                  //   ),
                  //   trailing: GestureDetector(
                  //     onTap: () async {
                  //       await controller.removeQuestionFromList(
                  //           context: context,
                  //           questionId: questionData.id.toString() ?? "");
                  //       saveWordsList.removeAt(index);
                  //       controller.update();
                  //     },
                  //     child: Icon(
                  //       Icons.bookmark,
                  //       color: primaryColor,
                  //     ),
                  //   ),
                  // ),
                  optionBody(questionData.options ?? []),
                  CustomDmSans(
                    text: "Solutions :",
                    color: greenColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      data: questionData.solution!.eSolutions ?? "",
                      style: {
                        "body": Style(
                          fontSize: FontSize(14.0),
                        ),
                        "p": Style(fontSize: FontSize(16.0))
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget optionBody(List<Options> optionsList) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: optionsList.length,
            itemBuilder: (context, index) {
              Options optionData = optionsList[index];
              return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: optionData.correct == 1
                              ? lightGreenColor
                              : Colors.grey,
                          offset: const Offset(0.0, 1.0), //(x,y)
                          blurRadius: 4.0,
                        ),
                      ],
                      border: Border.all(
                          color:
                              optionData.correct == 1 ? greenColor : whiteColor,
                          width: 2),
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.only(
                      left: 10, top: 5, bottom: 5, right: 10),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: RegularTextDarkMode(
                        text: _htmlConverter.removeAllHtmlTags(
                          optionData.optionE.toString(),
                        ),textAlign: TextAlign.start,)),);
            }));
  }

  void _onRefresh() async {
    // monitor network fetch
    favoriteController.getSaveQuestionList(categoryId);

    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}

