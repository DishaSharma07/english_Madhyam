import 'package:english_madhyam/resrc/models/model/all_category.dart';
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeController.dart';
import 'package:english_madhyam/src/screen/practice/page/practiceExamListlPage.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import '../../../custom/toolbarTitle.dart';
import '../../../skeletonView/agendaSkeletonList.dart';
import '../controller/praticeExamListController.dart';

class PraticeListPage extends StatefulWidget {
  var subCategoryId="";
   PraticeListPage({Key? key,required this.subCategoryId}) : super(key: key);

  @override
  State<PraticeListPage> createState() => _PraticeListPageState();
}
class _PraticeListPageState extends State<PraticeListPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  final _controller = Get.put(PraticeController(), permanent: true);

  final PraticeExamListController _praticeExamListController =
  Get.put(PraticeExamListController());

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> _refreshKey1 =
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
    tabController = TabController(length: 2, vsync: this);
  }

  void loadData() async {
    _controller.getPracticeChildListData(subCategoryId: widget.subCategoryId??"",isRefresh: true);
    await Future.delayed(const Duration(milliseconds: 1000));
  }
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
          title: 'Practice List',
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: GetX<PraticeController>(
          builder: (controller) {
            return Column(
              children: [
                _controller.previousExamList.isNotEmpty?buildTabWidget():const SizedBox(),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [getMockTestCategories(), getMockPreviousCategories()]),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildTabWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      child: TabBar(
          //unselectedLabelColor: blackColor,
          indicatorSize: TabBarIndicatorSize.label,
          controller: tabController,
          dividerColor: Colors.transparent,
          onTap: (index){
            _controller.tabIndex(index);
            loadData();
          },
          tabs: [
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Mock Test",
                    style: GoogleFonts.roboto(fontSize: 18),
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
                  child: Text("Previous Years", style: GoogleFonts.roboto(fontSize: 18)),
                ),
              ),
            ),
          ]),
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
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _controller.practiceListList.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      var praticeQuizData = _controller.practiceListList[index];
                      return buildCategoryItem(praticeQuizData, false, index);
                    }),)
          ),
          _progressEmptyWidget(true, _controller.practiceListList)
        ],
      ),
    );
  }

  Widget getMockPreviousCategories() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
      child: Stack(
        children: [
          RefreshIndicator(
            key: _refreshKey1,
            onRefresh: () async {
              return Future.delayed(
                const Duration(seconds: 1),
                    () {
                      loadData();
                },
              );
            },
            child:  Skeleton(
              themeMode: ThemeMode.light,
              isLoading: _controller.isFirstLoadRunning.value,
              skeleton: const ListAgendaSkeleton(),
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _controller.previousExamList.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    var praticeQuizData = _controller.previousExamList[index];
                    return buildCategoryItem(praticeQuizData, true, index);
                  }),),
          ),
          _progressEmptyWidget(false, _controller.previousExamList)
        ],
      ),
    );
  }


  Widget buildCategoryItem(PracticeQuizData practiceQuizData, isPaid, index) {
    return InkWell(
      onTap: () async {
        _praticeExamListController.getQuizListByCategory(cat: practiceQuizData.id!.toString(),isRefresh: false);
        Get.to(() => PracticeExamListDetailPage(
            title: practiceQuizData.name ?? "",
            id: practiceQuizData.id!.toString(),
          ),
        );
      },
      child: ListTile(
        leading: Image.network(practiceQuizData.image.toString(),width: 45,height: 45,),
        title: RegularTextView(text: practiceQuizData.name??"",color: labelColor,maxLine: 4,textSize: 14,),
        trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
      ),
    );
  }

  Widget _progressEmptyWidget(isMock, list) {
    return Center(
      child: _controller.isLoading.value
          ? const Loading()
          : list.isEmpty &&
          !_controller.isFirstLoadRunning.value
          ? ShowLoadingPage(refreshIndicatorKey: isMock? _refreshKey:_refreshKey1)
          : const SizedBox(),
    );

  }
}
