import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/boldTextView.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:english_madhyam/resrc/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/material/controller/materialController.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';
import 'package:english_madhyam/src/screen/material/page/materialSubCategoryPage.dart';
import 'package:english_madhyam/src/skeletonView/gridViewSkeleton.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

class MaterialList extends GetView<MaterialController> {
   String subCateId="";
  String name="";
   MaterialList({Key? key,required this.subCateId,required this.name}) : super(key: key);

  late TabController tabController;
  ScrollController scrollController = ScrollController();
  final ProfileControllers _subcontroller = Get.put(ProfileControllers());

  bool isLoading = false;
  int page = 1;
  int freepage = 1;

  final GlobalKey<RefreshIndicatorState> _refreshKey =
  GlobalKey<RefreshIndicatorState>();

  final MaterialController materialController = Get.find();

  void _onRefresh() async {
    // monitor network fetch
    _subcontroller.profileDataFetch();
    materialController.getMaterialList(page,subCateId);
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  List<String> color = [
    "#EDF6FF",
    "#FFDDDD",
    "#F6F4FF",
    "#EBFFE5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: purpleColor.withOpacity(0.15),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        title:  ToolbarTitle(
          title: name??'Editorial',
        ),
      ),
      body: GetX<MaterialController>(builder: (controller) {
        return Stack(
          children: [
            RefreshIndicator(
              key: _refreshKey,
              onRefresh: () async {
                return Future.delayed(
                  const Duration(seconds: 1),
                      () {
                    _onRefresh();
                  },
                );
              },
              child: materialListView(context),
            ),
            _progressEmptyWidget(false,controller.materialChildList),
          ],
        );
      }),
    );
  }

  Widget materialListView(BuildContext context) {
    return Skeleton(
        isLoading: controller.isFirstLoadRunning.value,
        themeMode: ThemeMode.light,
        skeleton: const GridViewSkeleton(), child: Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
      child:GridView.builder(
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              childAspectRatio: 0.7,
              crossAxisSpacing: 4),
          controller: materialController.freeScrollController,
          itemCount: materialController.materialChildList.length,
          itemBuilder: (BuildContext ctx, int index) {
            if (index ==
                materialController.materialChildList.length -
                    1 &&
                materialController.isMoreDataAvailable.value ==
                    true) {
              return const Center(child: CircularProgressIndicator());
            }
            return InkWell(
              onTap: () {
                Get.to(() => MaterialSubCategoryPage(
                  catid: materialController
                      .materialChildList[index].id
                      .toString(),
                  subCateId: subCateId,
                  type: materialController.materialChildList[index].type.toString(),
                  title: materialController
                      .materialChildList[index].name!,
                ));
              },
              child: buildCategoryWidget(index,
                  materialController.materialChildList[index],context),
            );
          }),
    ));
  }

  Widget _progressEmptyWidget(isMock, list) {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : list.isEmpty &&
          !controller.isFirstLoadRunning.value
          ? ShowLoadingPage(refreshIndicatorKey: _refreshKey)
          : const SizedBox(),
    );

  }

  Widget buildHeaderWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Container(
        padding: const EdgeInsets.all(30),
        color:homeTopColor,
        child: Stack(
          children: [
            Column(
              children: [
                BoldTextView(
                    textSize: 24,
                    text:
                        "${materialController.materialChildList.length} Total Editorials"),
                BoldTextView(
                    textSize: 24,
                    text:
                        "${materialController.materialChildList.length} Free Editorials")
              ],
            ),
             const Align(
               alignment: Alignment.bottomCenter,
               child: ListTile(
                 contentPadding: EdgeInsets.all(0),
                 leading: Icon(Icons.language,color: menuIconColor,),
                 title:RegularTextView(
                 textSize: 18,
                 text: "Available In English",
                   color: menuIconColor,
               ),
               ),
             )
          ],
        ),
      ),
    );
  }

  Widget buildCategoryWidget(index, data,context) {
    return  Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: greyColor
                      .withOpacity(0.8),
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
            MainAxisAlignment
                .spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                        4),
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
                            data
                                .image
                                .toString()),
                        fit: BoxFit.cover)),
                padding:
                const EdgeInsets.only(
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
                data.name
                    .toString(),
                maxLines: 1,
                style: GoogleFonts.roboto(
                    fontSize: 12,color: blackColor,
                    fontWeight:
                    FontWeight.w600),
              )
            ],
          ),
        ),
        data.type!=null && data.type==1?const Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.star,color: primaryColor,size: 12,),
          ),
        ):const SizedBox()
      ],
    );
  }
}
