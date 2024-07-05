import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/favorite/controller/attemptedExamController.dart';
import 'package:english_madhyam/src/screen/favorite/model/attemptedExamData.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../resrc/widgets/boldTextView.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeController.dart';
import 'package:english_madhyam/src/screen/practice/page/practiceExamListlPage.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../resrc/utils/ui_helper.dart';
import '../../../skeletonView/agendaSkeletonList.dart';
import '../../../utils/progress_bar_report/progress_bar.dart';
import '../../practice/controller/praticeExamListController.dart';
import '../../practice/performance_report.dart';

class AttemptedExampList extends StatefulWidget {
  const AttemptedExampList({Key? key}) : super(key: key);

  @override
  State<AttemptedExampList> createState() => _AttemptedExampListState();
}

class _AttemptedExampListState extends State<AttemptedExampList> {
  final AttemptedExamController _controller =
      Get.put(AttemptedExamController());

  final PraticeExamListController _praticeExamListController =
      Get.put(PraticeExamListController());

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  List<String> color = [
    "#EDF6FF",
    "#FFDDDD",
    "#F6F4FF",
    "#EBFFE5",
  ];
  @override
  void initState() {
    super.initState();
  }

  void loadData() async {
    _controller.getAttemptedExam(isRefresh: true);
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const ToolbarTitle(
          title: 'Attempted Exam',
        ),
      ),
      body: GetX<PraticeController>(
        builder: (_controller) {
          return getMockTestCategories();
        },
      ),
    );
  }

  Widget getMockTestCategories() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
      child: Stack(
        children: [
          RefreshIndicator(
              key: _refreshKey,
              onRefresh: () async {
                return Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    loadData();
                  },
                );
              },
              child: Skeleton(
                themeMode: ThemeMode.light,
                isLoading: _controller.isFirstLoadRunning.value,
                skeleton: const ListAgendaSkeleton(),
                child: ListView.builder(
                  controller: _controller.preScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _controller.previousExamList.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      var praticeQuizData = _controller.previousExamList[index];
                      return buildCategoryItem(praticeQuizData, false, index);
                    }),
              )),
          _progressEmptyWidget(true, _controller.previousExamList)
        ],
      ),
    );
  }

  Widget buildCategoryItem(ExamParent examData, isPaid, index) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: homeColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Row(
              children: [
                examData.categoryDetails?.type == 0
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
                RegularTextDarkMode(
                  text: examData.categoryDetails?.name ?? "",
                  color: labelColor,
                  textSize: 12,
                  textAlign: TextAlign.start,
                )
              ],
            ),
            subtitle: BoldTextView(
              text: examData.examDetails?.title ?? "",
              color: labelColor,
              textSize: 16,
              textAlign: TextAlign.start,
            ),
          ),
          attemptedWidget(examData, context)
        ],
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

  Widget attemptedWidget(ExamParent data, BuildContext contxt) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RegularTextDarkMode(
                  text:
                      "${data?.marks.toString()}/${data?.totalMarks.toString()} Score",
                  color: labelColor,
                ),
                TextButton(
                    onPressed: () {
                      openExamDetailPage(data);
                    },
                    child: const BoldTextView(
                      text: "View Result",color: Colors.blue,
                    ))
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
                      (data!.incorrectQuestion! / data.totalQuestion!)
                          .toString()),
                  greenSize: double.parse(
                      (data!.correctQuestion! / data.totalQuestion!)
                          .toString())),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      openDetailPage(
                          name: data.categoryDetails?.name ?? "",
                          id: data.categoryDetails?.id);
                    },
                    child: const BoldTextView(
                      text: "More test",color: Colors.blue,
                    )),
                RegularTextDarkMode(
                  text:
                      "Attempted on ${UiHelper.getFormattedChatDate(date: data.createdAt)}",
                  textSize: 14,
                ),
              ],
            )
          ],
        ));
  }

  openDetailPage({name, id}) {
    _praticeExamListController.getQuizListByCategory(
        cat: id.toString(), isRefresh: false);
    Get.to(
      () => PracticeExamListDetailPage(
        title: name,
        id: id.toString(),
      ),
    );
  }

  Widget _progressEmptyWidget(isMock, list) {
    return Center(
      child: _controller.isLoading.value
          ? const Loading()
          : list.isEmpty && !_controller.isFirstLoadRunning.value
              ? ShowLoadingPage(
                  refreshIndicatorKey: isMock ? _refreshKey : _refreshKey)
              : const SizedBox(),
    );
  }

  openExamDetailPage(ExamParent data) {
    Get.to(() => PerformanceReport(
          id: data.examId.toString(),
          catId: data.categoryDetails?.id.toString(),
          eId: "",
          title: data.examDetails?.title.toString(),
          route: 1,
        ));
  }
}
