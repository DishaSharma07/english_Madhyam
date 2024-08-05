import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:english_madhyam/resrc/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeController.dart';
import 'package:english_madhyam/src/screen/practice/page/praticeListPage.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../resrc/widgets/loading.dart';
import '../../../../resrc/utils/routes/my_constant.dart';
import '../../../custom/toolbarTitle.dart';
import '../../../skeletonView/agendaSkeletonList.dart';

class MaterialSubCategoriesPage
 extends GetView<PraticeController> {

  String parentcateId="";
  MaterialSubCategoriesPage
({Key? key,required this.parentcateId}) : super(key: key);


  final PraticeController _controller = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  void loadData() async {
    // monitor network fetch
    _controller.getSubCategories(parentcateId);
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  List<String> color = [
    "#DBDDFF",
    "#FFECE7",
    "#EDF6FF",
    "#EBFFE5",
    "#F6F4FF",
    "#EBFFE5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: purpleColor.withOpacity(0.15),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: true,
        shape: const Border(
            bottom:
            BorderSide(color: indicatorColor)),
        title: const ToolbarTitle(
          title: 'Practice category',
        ),
      ),
      body: GetX<PraticeController>(
        builder: (_controller) {
          return Column(
            children: [
              Expanded(
                child: loadPraticeCategory(context),
              )
            ],
          );
        },
      )
    );
  }

  Widget loadPraticeCategory(BuildContext context) {
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
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _controller.practiceCategoryList.length,
                itemBuilder: (BuildContext ctx, int index) {
                  var praticeQuizData = _controller.practiceCategoryList[index];
                  return buildCategoryItem(praticeQuizData,index);
                },)),
          ),
          _progressEmptyWidget(false, _controller.practiceCategoryList)
        ],
      ),
    );
  }

  Widget buildCategoryItem(dynamic practiceQuizData,index) {
    return InkWell(
      onTap: () async {
        _controller.getPracticeChildListData(subCategoryId: practiceQuizData.id.toString(),isRefresh: false);
        Get.to(MaterialChildCategoriesPage
(subCategoryId: practiceQuizData.id.toString(),));
      },
      child: Container(
        decoration: BoxDecoration(
          color:
          Color(hexStringToHexInt(color[index % 6])),
          boxShadow: [
            BoxShadow(
                color: greyColor.withOpacity(0.4),
                blurRadius: 2,
                spreadRadius: 1,
                offset: const Offset(1, 2)),
          ],
          borderRadius: BorderRadius.circular(6),
        ),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: Image.network(practiceQuizData.image??MyConstant.banner_image,width: 45,height: 45,),
          title: RegularTextDarkMode(
            text: practiceQuizData.name!.length > 20
                ? "${practiceQuizData.name!.substring(0, 18)}.."
                : practiceQuizData.name!,maxLine: 2,color: primaryColor1,
          ),
          subtitle:const  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text("English",style: TextStyle(color: Colors.blue),),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
        ),
      ),
    );
  }

  Widget _progressEmptyWidget(isPaid, list) {
    return Center(
      child: _controller.isLoading.value
          ? const Loading()
          : list.isEmpty &&
          !_controller.isFirstLoadRunning.value
          ? ShowLoadingPage(refreshIndicatorKey: _refreshKey)
          : const SizedBox(),
    );
  }
}
