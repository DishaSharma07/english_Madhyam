import 'dart:io';
import 'package:english_madhyam/resrc/models/model/quiz_list/quiz_list.dart';
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/boldTextView.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:english_madhyam/resrc/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeExamDetailController.dart';
import 'package:english_madhyam/src/screen/practice/instructions.dart';
import 'package:english_madhyam/src/screen/practice/performance_report.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../resrc/utils/ui_helper.dart';
import '../../../custom/loadMoreItem.dart';
import '../../../skeletonView/agendaSkeletonList.dart';
import '../../../utils/progress_bar_report/progress_bar.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';
import '../../profile/controller/profile_controllers.dart';
import '../controller/praticeExamListController.dart';

class PracticeExamListDetailPage extends GetView<PraticeExamListController> {
  final String title;
  final String id;
  PracticeExamListDetailPage({Key? key, required this.title, required this.id})
      : super(key: key);

  final PraticeExamDetailController praticeExamDetailController =
      Get.put(PraticeExamDetailController());

  final PraticeExamListController controller = Get.find();

  final GlobalKey<RefreshIndicatorState> _refreshTab1Key =
      GlobalKey<RefreshIndicatorState>();

  final ProfileControllers _subcontroller = Get.put(ProfileControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
        shape: const Border(
            bottom:
            BorderSide(color: indicatorColor)),
        title: ToolbarTitle(
          title: title,
        ),
      ),
      body: buildTabFirst(context),
    );
  }

  Widget buildTabFirst(BuildContext context) {
    return GetX<PraticeExamListController>(builder: (controller) {
      return Container(
        color: Colors.transparent,
        width: context.width,
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: RefreshIndicator(
                  key: _refreshTab1Key,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () async {
                        callUserList(isRefresh: true);
                      },
                    );
                  },
                  child: buildChildList(context),
                )),
                // when the _loadMore function is running
                controller.isLoadMoreRunning.value
                    ? const LoadMoreLoading()
                    : const SizedBox()
              ],
            ),
            _progressEmptyWidget()
          ],
        ),
      );
    });
  }

  Widget buildChildList(context) {
    return  Skeleton(
      themeMode: ThemeMode.light,
      isLoading: controller.isFirstLoadRunning.value,
      skeleton: const ListAgendaSkeleton(),
      child: ListView.builder(
        controller: controller.scrollCtr,
        itemCount: controller.praticeExamList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) =>
            buildListViewBody(controller.praticeExamList[index], context),
      ),);
  }

  Widget buildListViewBody(data, context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: homeColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: data.completed == true
          ? attemptedWidget(data, context)
          : notAttemptedWidget(data, context),
    );
  }

  Widget notAttemptedWidget(data, BuildContext contxt) {
    return GestureDetector(
      onTap: (){
        if(data.type == 1){
          if (_subcontroller
              .profileGet.value.user!.isSubscription ==
              "Y") {
            startAndResumeExam(data);
          } else {
            _subcontroller.profileDataFetch();
            if (Platform.isAndroid) {
              startAndResumeExam(data);

              // Get.to(() => const ChoosePlanDetails());
            } else {
              startAndResumeExam(data);

              // Get.to(() => InAppPlanDetail());
            }
          }
        }else{
          startAndResumeExam(data);
        }

      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                data.type == 0
                    ? freeWidget()
                    : paidWidget(),
                const SizedBox(
                  width: 6,
                ),
                Icon(
                  Icons.category,
                  color: greyColor,
                  size: 15,
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(child: RegularTextDarkMode(
                  text: data.title ?? "",
                  color: labelColor,
                  textSize: 12,maxLine: 3,
                  textAlign: TextAlign.start,
                ))
              ],
            ),
            Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BoldTextView(
                        text:data.attempted == true? "Resume":"Start",color: primaryColor,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RegularTextDarkMode(
                      text: "${data.totalQuestions} Ques",
                      color: labelColor,
                    ),
                    CircleAvatar(
                      backgroundColor: greyColor,
                      maxRadius: 2,
                    ),
                    RegularTextDarkMode(
                      text: "${data.duration} Mins",
                      color: labelColor,
                    ),
                    CircleAvatar(
                      backgroundColor: greyColor,
                      maxRadius: 2,
                    ),
                    RegularTextDarkMode(
                      text: "${data.mark} Marks",
                      color: labelColor,
                    ),
                  ],
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

  Widget attemptedWidget(ExamData data, BuildContext contxt) {
    return GestureDetector(
      onTap: (){
        viewResultPage(data);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                data.type == 0
                    ? freeWidget()
                    : paidWidget(),
                const SizedBox(
                  width: 6,
                ),
                const SizedBox(
                  width: 6,
                ),
                RegularTextDarkMode(
                  text: data.title ?? "",
                  color: labelColor,
                  textSize: 12,maxLine: 3,
                  textAlign: TextAlign.start,
                )
              ],
            ),
            /*BoldTextView(
              text: data.title.toString(),
              textAlign: TextAlign.start,
            ),*/
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //${data.marks}/${data.totalMarks}
                    RegularTextDarkMode(
                      text:
                      "${data.examResult?.marks.toString()}/${data.examResult?.totalMarks.toString()} Score",
                      color: labelColor,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: BoldTextView(
                        text:"View Result",color: Colors.blue,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 10,
                  width: contxt.width * .85,
                  child: ProgressBar(
                      redSize: double.parse(
                          (data.examResult?.incorrectQuestion / data.examResult?.totalQuestion).toString()),
                      greenSize: double.parse(
                          (data.examResult?.correctQuestion / data.examResult?.totalQuestion).toString())),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RegularTextDarkMode(
                      text:
                      "Attempted on ${UiHelper.getFormattedChatDate(date: data.examResult.createdAt)}",
                      textSize: 14,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget freeWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: Colors.blue),
      child: const RegularTextDarkMode(
        text: "FREE",
        color: white,
        textSize: 12,
      ),
    );
  }

  Widget paidWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: Colors.green),
      child: const RegularTextDarkMode(
        text: "PAID",
        color: white,
        textSize: 12,
      ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.praticeExamList.isEmpty &&
          !controller.isFirstLoadRunning.value
          ? ShowLoadingPage(refreshIndicatorKey: _refreshTab1Key)
          : const SizedBox(),
    );
  }

  viewResultPage(data) {
    if (data.type == 1) {
      if (_subcontroller.profileGet.value.user != null &&
          _subcontroller.profileGet.value.user!.isSubscription == "Y") {
        Get.to(() => PerformanceReport(
          id: data.id.toString(),
          catId: id.toString(),
          eId: "",
          title: title.toString(),
          route: 1,
        )
        );
      } else {
        if (Platform.isAndroid) {
          Get.to(() => PerformanceReport(
            id: data.id.toString(),
            catId: id.toString(),
            eId: "",
            title: title.toString(),
            route: 1,
          ));
          // Get.to(() => const ChoosePlanDetails());
        } else {
          Get.to(() => PerformanceReport(
            id: data.id.toString(),
            catId: id.toString(),
            eId: "",
            title: title.toString(),
            route: 1,
          ));
          // Get.to(() => InAppPlanDetail());
        }
      }
    } else {
      Get.to(() => PerformanceReport(
        id: data.id!.toString(),
        catId: id.toString(),
        eId: "",
        title: title.toString(),
        route: 1,
      ));
    }

  }

  //start and resume the exam quiz
  startAndResumeExam(data){
    praticeExamDetailController.getQuizDetailApi(data.id!);
    Get.to(() => TestInstructions(
      catTitle: title,
      examid: data.id!,
      title: data.title.toString(),
      type: 1,
    ));
  }

  callUserList({required bool isRefresh}) {
    controller.getQuizListByCategory(cat: id, isRefresh: isRefresh);
  }
}
