import 'dart:io';
import 'package:english_madhyam/resrc/models/model/video_cat_model.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:english_madhyam/resrc/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/screen/videos_screen/controller/videoController.dart';
import 'package:english_madhyam/src/screen/videos_screen/page/videoListPage.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../resrc/widgets/loading.dart';
import '../../../custom/toolbarTitle.dart';
import '../../profile/controller/profile_controllers.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';

class VideoDashboardPage extends StatefulWidget {
  VideoDashboardPage({Key? key}) : super(key: key);

  @override
  State<VideoDashboardPage> createState() => _VideoDashboardPageState();
}

class _VideoDashboardPageState extends State<VideoDashboardPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  final VideoController _videoController = Get.put(VideoController());
  final ProfileControllers _subcontroller = Get.put(ProfileControllers());

  final GlobalKey<RefreshIndicatorState> _refreshKey =
  GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> _refreshPaidKey =
  GlobalKey<RefreshIndicatorState>();

  List<String> color = [
    "#EDF6FF",
    "#FFDDDD",
    "#F6F4FF",
    "#EBFFE5",
  ];
  void loadData()  {
    _videoController.getVideoList();
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white70,
        appBar: AppBar(
          //backgroundColor: Colors.white70,
          elevation: 0.0,
          centerTitle: true,
          title: const ToolbarTitle(title: 'Videos',),
        ),
        body: DefaultTabController(
          length: 2,
          child: GetX<VideoController>(
            builder: (controller) {
              return Column(
                children: [
                  buildTabWidget(),
                  Expanded(
                    child: TabBarView(
                        controller: tabController,
                        children: [
                          loadFreeCategory(),
                          loadPaidCategory()
                        ]),
                  )
                ],
              );
            },
          ),
        ));
  }

  Widget buildTabWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      child: TabBar(
        //unselectedLabelColor: blackColor,
          indicatorSize: TabBarIndicatorSize.label,
          controller: tabController,
          labelColor: Colors.black,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: purpleColor),
          tabs: [
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Free",
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Paid",
                      style: GoogleFonts.roboto(fontSize: 12)),
                ),
              ),
            ),
          ]),
    );
  }

  loadFreeCategory() {
    return RefreshIndicator(
      key: _refreshKey,
        onRefresh: () async {
          return Future.delayed(
            const Duration(seconds: 1),
                () {
              loadData();
            },
          );
        },
        child: Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
      child: Stack(
        children: [
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 4),
              itemCount: _videoController.freeVideoList.length,
              itemBuilder: (BuildContext ctx, int index) {
                return loadVideoItemData(
                    _videoController.freeVideoList[index], index, false);
              }),
          _progressEmptyWidget(false,_videoController.freeVideoList),
        ],
      ),
    ));
  }

  loadPaidCategory() {
    return RefreshIndicator(
        key: _refreshPaidKey,
        onRefresh: () async {
          return Future.delayed(
            const Duration(seconds: 1),
                () {
              loadData();
            },
          );
        },
        child:  Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
          child:Stack(
            children: [
              GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 4),
                  itemCount: _videoController.paidVideoList.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return loadVideoItemData(
                        _videoController.paidVideoList[index], index, true);
                  }),
              _progressEmptyWidget(true,_videoController.paidVideoList),
            ],
          ),
        ),);
  }

  loadVideoItemData(VideoData videoData, index, bool isPaid) {
    return InkWell(
      onTap: () async {
        if(isPaid){
          if (_subcontroller.profileGet.value.user != null &&
              _subcontroller.profileGet.value.user!.isSubscription == "Y" &&
              isPaid) {
            var result =
            await _videoController.videoDetail(id: videoData.id.toString());
            if (result) {
              Get.to(() => VideoListPage(
                id: videoData.id.toString(),
                title: videoData.name ?? "",
              ));
            }
          } else {
            if (Platform.isAndroid) {
              Get.to(() =>
              const ChoosePlanDetails());
            } else {
              Get.to(() => InAppPlanDetail());
            }
          }
        }else{
          var result =
          await _videoController.videoDetail(id: videoData.id.toString());
          if (result) {
            Get.to(() => VideoListPage(
              id: videoData.id.toString(),
              title: videoData.name ?? "",
            ));
          }
        }
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
          color: Color(hexStringToHexInt(color[index % 4])),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                        color: greyColor.withOpacity(0.7),
                        spreadRadius: 0.0,
                        blurRadius: 5,
                        offset: const Offset(-3, 3))
                  ],
                  image: DecorationImage(
                      image: NetworkImage(videoData.image.toString()),
                      fit: BoxFit.cover)),
              padding: const EdgeInsets.only(left: 4.0, right: 4),
              height: MediaQuery.of(context).size.height * 0.128,
            ),
            RegularTextView(text:
              videoData.name!.length > 20
                  ? "${videoData.name!.substring(0, 18)}.."
                  : videoData.name!,
              maxLine: 1,textSize: 12,
            )
          ],
        ),
      ),
    );
  }

  Widget _progressEmptyWidget(isPaid,list) {
    return Center(
      child:_videoController.loading.value
          ? const Loading()
          : list.isEmpty
          ? ShowLoadingPage(refreshIndicatorKey: isPaid?_refreshPaidKey:_refreshKey)
          : const SizedBox(),
    );
  }
}
