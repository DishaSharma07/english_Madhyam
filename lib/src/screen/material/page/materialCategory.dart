import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/material/controller/materialController.dart';
import 'package:english_madhyam/src/skeletonView/gridViewSkeleton.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import '../../pages/page/custom_dmsans.dart';
import 'materialPage.dart';

class MaterialCategoryListPage extends GetView<MaterialController> {
  String parentcateId="";
   MaterialCategoryListPage({Key? key,required this.parentcateId}) : super(key: key);

  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

  final GlobalKey<RefreshIndicatorState> _refreshKey =
  GlobalKey<RefreshIndicatorState>();

  final MaterialController _materialController =
      Get.find();

   List<String> color = [
     "#EDF6FF",
     "#FFDDDD",
     "#F6F4FF",
     "#EBFFE5",
   ];

  void _onRefresh() async {
    // monitor network fetch
    _materialController.getMaterialCategory(parentcateId);
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: purpleColor.withOpacity(0.15),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const ToolbarTitle(title: 'Reading Category',),
      ),
      body: GetX<MaterialController>(builder: (_controller){
        return  Stack(
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
                child: Skeleton(
                  themeMode: ThemeMode.light,
                  isLoading: _controller.isFirstLoadRunning.value,
                  skeleton: const GridViewSkeleton(),
                  child:  gridViewListWidget(context),)
            ),
            _progressEmptyWidget(false, _controller.materialCategoryList)
            /*Column(
              children: [
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: gridViewListWidget(context),
                  ),
                )
              ],
            ),
            _planDetailsController.isFirstLoadRunning.value
                ? const Loading()
                : const SizedBox()*/
          ],
        );
      },
      ),
    );
  }


  Widget gridViewListWidget(BuildContext context){
    return _materialController.materialCategoryList.isEmpty
        ? Container(
      alignment: Alignment.center,
      height:
      MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {
                _onRefresh();
              },
              child: Icon(
                Icons.refresh,
                size: context.height * 0.08,
              )),
          CustomDmSans(text: "Data not found."),
        ],
      ),
    )
        : Padding(
      padding: const EdgeInsets.only(
          left: 10.0, right: 10, top: 20),
      child: GridView.builder(
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              childAspectRatio: 0.7,
              crossAxisSpacing: 4),
          itemCount:
          _materialController.materialCategoryList.length,
          itemBuilder:
              (BuildContext ctx, int index) {
            return InkWell(
              onTap: () async {
                var subCateId=_materialController
                    .materialCategoryList[index].id.toString();

                var name=_materialController
                    .materialCategoryList[index].name.toString();

                controller.getMaterialList(page,subCateId);
                Get.to(MaterialList(subCateId: subCateId,name: name,));
              },
              child: buildCategoryWidget(index, _materialController
                  .materialCategoryList[index],context),
            );
          }),
    );
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

  Widget buildCategoryWidget(index,data,context){
    return Container(
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
    );
  }
}
