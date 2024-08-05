import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import 'package:english_madhyam/resrc/models/model/feed_model/feed_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class FeedController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var loading = true.obs;
  var wordOfDayList =<Dataum>[].obs;
  var phraseList =<Dataum>[].obs;
  Rx<int>pageCounter=1.obs;

 // Rx<FeedModel> feeds = FeedModel().obs;
  late AnimationController _feedAnimation;
  late Animation _animation;
  Animation get animation => _animation;
  late PageController _pageController;
  PageController get pageController => _pageController;

  //var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  late bool hasNextPage;
  //late int _pageNumber;
  int pageNumber = 1;
  ScrollController scrollController = ScrollController();


  @override
  void onInit() async {
    _feedAnimation =
        AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _animation = Tween<double>(begin: 0, end: 1).animate(_feedAnimation)
      ..addListener(() {
        update();
      });
    _pageController = PageController();
    _feedAnimation.forward();
    super.onInit();
  }

  //
  Future<void> feedApiFetch(
      {required String type, required String date,required int currentPage}) async {
    try {
      loading(true);
      FeedModel? response = await apiService.getFeed(type: type, date: date,currentPage: currentPage);
      loading(false);
      if (response != null) {
        if(type=="word" && response.data?.wordOfDay!=null){

          wordOfDayList.addAll(response.data!.wordOfDay!.data!);

        }else{
          phraseList.addAll(response.data?.phrase!.data??[]);


        }
      }
    } catch (e) {
      loading(false);
    }
    finally{
      loading(false);
    }
  }


  //start
  Future<void> getFeedListApi(
      {required bool isRefresh}) async {
    if (!isRefresh) {
      loading(true);
    }
    FeedModel? model =
    await apiService.getFeedPagination(page: pageNumber,);
    if (model!.result == true) {
      wordOfDayList.clear();
      wordOfDayList.addAll(model.data?.wordOfDay?.data??[]);
      if(model.data?.wordOfDay?.total!=null && pageNumber < model.data!.wordOfDay!.total!){
        pageNumber = pageNumber + 1;
        hasNextPage = true;
      }else{
        hasNextPage = false;
      }
      if (hasNextPage) {
        //getPracticeChildLoadMore();
      }
      loading(false);
    } else {
      loading(false);
    }
  }

  Future<void> getPracticeChildLoadMore() async {
    pageController.addListener(() async {
      if (hasNextPage == true &&
          loading.value == false &&
          isLoadMoreRunning.value == false &&
          pageController.position.maxScrollExtent ==
              pageController.position.pixels) {
        isLoadMoreRunning(true);
        try {
          FeedModel? model =
          await apiService.getFeedPagination(page: pageNumber);
          if (model!.result == true) {
            if(model.data?.wordOfDay?.total!=null && pageNumber < model.data!.wordOfDay!.total!){
              pageNumber = pageNumber + 1;
              hasNextPage = true;
            }else{
              hasNextPage = false;
            }
            print("has next page$hasNextPage");
            wordOfDayList.addAll(model.data?.wordOfDay?.data??[]);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }
//end

}
