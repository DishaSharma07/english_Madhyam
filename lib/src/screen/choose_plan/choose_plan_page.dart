import 'package:english_madhyam/src/helper/controllers/choose_plan_detail_controller/choose_plan_detail_contr.dart';
import 'package:english_madhyam/src/helper/controllers/profile_controllers/profile_controllers.dart';
import 'package:english_madhyam/src/screen/choose_plan/choose_plan_details.dart';
import 'package:english_madhyam/src/screen/contents/cntentsfile.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChoosePlan extends StatefulWidget {
  const ChoosePlan({Key? key}) : super(key: key);

  @override
  _ChoosePlanState createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> with TickerProviderStateMixin {
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  final ProfileControllers _subcontroller = Get.put(ProfileControllers());

  bool isLoading = false;
  int page = 1;
  int freepage = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final PlanDetailsController _planDetailsController =
      Get.put(PlanDetailsController());

  void _onRefresh() async {
    // monitor network fetch
    _subcontroller.profileDataFetch();
    _planDetailsController.lstTask.clear();
    _planDetailsController.lstTask2.clear();
    _planDetailsController.getTask(page);
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  List<String> color = [
    "#EDF6FF",
    "#FFDDDD",
    "#F6F4FF",
    "#EBFFE5",
  ];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor.withOpacity(0.15),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          "Choose Plan",
          style: GoogleFonts.lato(
              color: blackColor, fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            tabstile(),
            Obx(() {
              if (_planDetailsController.isDataProcessing.value) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  child: Lottie.asset("assets/animations/loader.json",
                      height: MediaQuery.of(context).size.height * 0.2),
                );
              } else {
                return Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: TabBarView(controller: tabController, children: [
                      _planDetailsController.lstTask.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Lottie.asset(
                                  "assets/animations/49993-search.json",
                                  height:
                                      MediaQuery.of(context).size.height * 0.2),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 20),
                              child: GridView.builder(
                                  controller: _planDetailsController
                                      .freeScrollController,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 20,
                                          childAspectRatio: 0.7,
                                          crossAxisSpacing: 4),
                                  itemCount:
                                      _planDetailsController.lstTask.length,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    if (index ==
                                            _planDetailsController
                                                    .lstTask.length -
                                                1 &&
                                        _planDetailsController
                                                .isMoreDataAvailable.value ==
                                            true) {
                                      return Center(
                                          child:
                                              const CircularProgressIndicator());
                                    }
                                    return InkWell(
                                      onTap: () {
                                        Get.to(() => AllContents(
                                              catid: _planDetailsController
                                                  .lstTask[index].id
                                                  .toString(),
                                              type: "1",
                                              title: _planDetailsController
                                                  .lstTask[index].name!,
                                            ));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    greyColor.withOpacity(0.8),
                                                blurRadius: 2,
                                                spreadRadius: 1,
                                                offset: const Offset(-4, 4))
                                          ],
                                          color: Color(hexStringToHexInt(
                                              color[index % 4])),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: greyColor
                                                            .withOpacity(0.7),
                                                        spreadRadius: 0.0,
                                                        blurRadius: 5,
                                                        offset:
                                                            const Offset(-3, 3))
                                                  ],
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          _planDetailsController
                                                              .lstTask[index]
                                                              .image
                                                              .toString()),
                                                      fit: BoxFit.cover)),
                                              padding: const EdgeInsets.only(
                                                  left: 4.0, right: 4),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.13,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              _planDetailsController
                                                  .lstTask[index].name
                                                  .toString(),
                                              maxLines: 2,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                      _planDetailsController.lstTask2.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Lottie.asset(
                                  "assets/animations/49993-search.json",
                                  height:
                                      MediaQuery.of(context).size.height * 0.2),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 20),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: GridView.builder(
                                        controller: _planDetailsController
                                            .paidScrollController,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 20,
                                                childAspectRatio: 0.7,
                                                crossAxisSpacing: 4),
                                        itemCount: _planDetailsController
                                            .lstTask2.length,
                                        itemBuilder:
                                            (BuildContext ctx, int index) {
                                          if (index ==
                                                  _planDetailsController
                                                          .lstTask2.length -
                                                      1 &&
                                              _planDetailsController
                                                      .isMoreDataAvailable
                                                      .value ==
                                                  true) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          return InkWell(
                                            onTap: () {
                                              if (_subcontroller
                                                      .profileGet
                                                      .value
                                                      .user!
                                                      .isSubscription ==
                                                  "Y") {
                                                Get.to(() => AllContents(
                                                      catid:
                                                          _planDetailsController
                                                              .lstTask2[index]
                                                              .id
                                                              .toString(),
                                                      type: "2",
                                                      title:
                                                          _planDetailsController
                                                              .lstTask2[index]
                                                              .name!,
                                                    ));
                                              } else {
                                                _subcontroller.profileDataFetch();
                                                Get.to(() =>
                                                    const ChoosePlanDetails());
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(4),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: greyColor
                                                          .withOpacity(0.8),
                                                      blurRadius: 2,
                                                      spreadRadius: 1,
                                                      offset:
                                                          const Offset(-4, 4))
                                                ],
                                                color: Color(hexStringToHexInt(
                                                    color[index % 4])),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: greyColor
                                                                  .withOpacity(
                                                                      0.7),
                                                              spreadRadius: 0.0,
                                                              blurRadius: 5,
                                                              offset:
                                                                  const Offset(
                                                                      -3, 3))
                                                        ],
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                _planDetailsController
                                                                    .lstTask2[
                                                                        index]
                                                                    .image
                                                                    .toString()),
                                                            fit: BoxFit.cover)),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0,
                                                            right: 4),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.13,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    _planDetailsController
                                                        .lstTask2[index].name
                                                        .toString(),
                                                    maxLines: 2,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  _subcontroller.profileGet.value.user!
                                              .isSubscription ==
                                          "N"
                                      ? InkWell(
                                          onTap: () {
                                            Get.to(() =>
                                                const ChoosePlanDetails());
                                          },
                                          child: Center(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 30,
                                                  right: 30,
                                                  top: 10,
                                                  bottom: 10),
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: purplegrColor,
                                                    width: 2),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: greyColor,
                                                      blurRadius: 2,
                                                      spreadRadius: 1,
                                                      offset:
                                                          const Offset(1, 2))
                                                ],
                                                gradient: RadialGradient(
                                                  center:
                                                      const Alignment(0.0, 0.0),
                                                  colors: [
                                                    purpleColor,
                                                    purplegrColor
                                                  ],
                                                  radius: 3.0,
                                                ),
                                              ),
                                              child: Text(
                                                'Subscribe',
                                                style: GoogleFonts.roboto(
                                                    color: whiteColor,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    shadows: [
                                                      Shadow(
                                                        offset: const Offset(
                                                            1.0, 4),
                                                        blurRadius: 3.0,
                                                        color: greyColor
                                                            .withOpacity(0.5),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                    ]),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget tabstile() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      child: TabBar(
          unselectedLabelColor: blackColor,
          indicatorSize: TabBarIndicatorSize.label,
          controller: tabController,
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
                    "Free Plan",
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
                  child: Text("Paid  Courses",
                      style: GoogleFonts.roboto(fontSize: 12)),
                ),
              ),
            ),
          ]),
    );
  }
}
