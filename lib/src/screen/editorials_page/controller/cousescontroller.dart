import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import 'package:english_madhyam/resrc/models/model/editorials_model/getcoursesmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CoursesController extends GetxController {
  var loading = true.obs;
  var _datenow = DateTime.now();
  var NowDate = "";
  var select_date = "".obs;
  Rx<GetCoursesModel> getcourselist = GetCoursesModel().obs;

  var editorialListing = List<dynamic>.empty(growable: true).obs;
  var nextPage = true.obs;
  var firstLoading = false.obs;
  var loadMore = false.obs;
  int page = 1;
  ScrollController? editorialList;

  @override
  void onInit() {
    NowDate = "${_datenow.year}-${_datenow.month}-${_datenow.day}";
    selectDate(date: NowDate,isRefresh: true);
    editorialList = ScrollController()..addListener(_loadMore);
    super.onInit();
  }

  @override
  void dispose() {
    editorialList!.removeListener(_loadMore);
    super.dispose();
  }

  selectDate({required String date,required isRefresh}) {
    select_date.value = date;
    if (select_date != null) {
      firstLoad(isRefresh);
      update();
    }
  }

  // This function will be called when the app launches (see the initState function)
  void firstLoad(isRefresh) async {
    page = 1;
    firstLoading(isRefresh);
    try {
      GetCoursesModel? res = await apiService.getCoursesList(
          date: select_date.value, page: page.toString());
      getcourselist.value = res!;
      firstLoading(false);

      update();
      if (getcourselist.value.editorials!.data!.isNotEmpty) {
        editorialListing.clear();
        editorialListing.addAll(getcourselist.value.editorials!.data!);
      }
    } catch (err) {
      firstLoading(false);

      print(err.toString());
    } finally {
      firstLoading(false);
    }
  }



  void _loadMore() async {
    if (getcourselist.value.editorials!.currentPage! <
        getcourselist.value.editorials!.lastPage!) {
      if (nextPage.value == true &&
          firstLoading.value == false &&
          loadMore.value == false &&
          editorialList!.position.extentAfter < 300) {
        loadMore(true); // Display a progress indicator at the bottom
        page += 1; // Increase _page by 1
        try {
          GetCoursesModel? res = await apiService.getCoursesList(
              date: select_date.value, page: page.toString());
          final List fetchedPosts = res!.editorials!.data!;
          if (fetchedPosts.isNotEmpty) {
            editorialListing.addAll(fetchedPosts);
            update();
          } else {
            nextPage(false);
            update();
          }
        } catch (err) {
          print(err.toString());
        }
        loadMore(false);
        update();
      }
    } else {
      nextPage(false);
      loadMore(false);
      update();
    }
  }
}
