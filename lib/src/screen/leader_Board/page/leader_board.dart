import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:english_madhyam/resrc/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/screen/leader_Board/controller/leaderboardController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../resrc/widgets/boldTextView.dart';
import '../../../../resrc/widgets/loading.dart';
import '../../../custom/toolbarTitle.dart';
import '../model/LeadboardModel.dart';

class LeaderboardPage extends GetView<LeaderboardController> {
  LeaderboardPage({Key? key}) : super(key: key);

  static const routeName = "/LeaderboardPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final leaderboardController = Get.put(LeaderboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const ToolbarTitle(
          title: "Leader Board",
          color: Colors.black,
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(12),
          child: GetX<LeaderboardController>(builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      color: Colors.white,
                      backgroundColor: primaryColor,
                      strokeWidth: 4.0,
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      onRefresh: () async {
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            controller.getLeaderboardApi(isRefresh: true);
                          },
                        );
                      },
                      child: buildListView(context),
                    )),
                  ],
                ),
                // when the first load function is running
                _progressEmptyWidget()
              ],
            );
          })),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.leaderBoardData.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    return Skeleton(
        themeMode: ThemeMode.light,
        isLoading: controller.isFirstLoadRunning.value,
        skeleton: SkeletonListView(),
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 6,
              child: Container(
                color: Colors.transparent,
              ),
            );
          },
          itemCount: controller.leaderBoardData.length,
          itemBuilder: (context, index) {
            Leadboard leadboard = controller.leaderBoardData[index];

            return Container(
              decoration: const BoxDecoration(
                  color: homeColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              width: MediaQuery.of(context).size.width * 10,
              child: ListTile(
                leading:
                    avtarBuild(shortName: '# ${leadboard.rank ?? ""}', url: ""),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoldTextView(
                      text: leadboard.name.toString().capitalize ?? "",
                      color: primaryColor1,
                    ),
                    RegularTextDarkMode(
                      text:
                          "Marks: ${leadboard.marks ?? ""}/${leadboard.totalMarks ?? ""}",
                    ),
                  ],
                ),
                trailing: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Column(
                    children: [
                      BoldTextView(
                        text: "${leadboard.time.toString() ?? ""}",
                      ),
                      RegularTextDarkMode(text: "Time"),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget avtarBuild({url, shortName}) {
    return url.isNotEmpty
        ? FittedBox(
            fit: BoxFit
                .fill, // the picture will acquire all of the parent space.
            child: SizedBox(
                height: 40,
                width: 40,
                child: CircleAvatar(backgroundImage: NetworkImage(url))),
          )
        : Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor1,
            ),
            child: Center(
                child: BoldTextView(
              text: shortName,
              color: white,
              textAlign: TextAlign.center,
            )),
          );
  }

  Future<void> _launchInWebViewWithoutDomStorage(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      throw 'Could not launch $url';
    }
  }
}
