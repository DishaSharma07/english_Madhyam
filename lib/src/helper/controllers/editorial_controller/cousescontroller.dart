import 'package:english_madhyam/src/helper/providers/editorial_provider/editorial_provider.dart';
import 'package:english_madhyam/src/helper/model/editorials_model/getcoursesmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CoursesController extends GetxController {
  var loading = true.obs;
  EditorialProvider _editorialProvider = EditorialProvider();
  DateTime _datenow = DateTime.now();
  String NowDate = "";
  RxString select_date = "".obs;
  Rx<GetCoursesModel> getcourselist = GetCoursesModel().obs;

  var editorialListing = List<dynamic>.empty(growable: true).obs;
  var nextPage = true.obs;
  var firstLoading = false.obs;
  var loadMore = false.obs;
  int page = 1;
  ScrollController? editorialList ;

  @override
  void onInit() {
    // TODO: implement onInit
    NowDate = "${_datenow.year}-${_datenow.month}-${_datenow.day}";
    selectDate(date: NowDate);
    editorialList = ScrollController()..addListener(_loadMore);
    super.onInit();
  }
  @override
  void dispose() {
    editorialList!.removeListener(_loadMore);
    super.dispose();
  }

  selectDate({required String date}) {

    select_date.value = date;
    if (select_date != null) {
      firstLoad();
      update();
    }
  }


  // This function will be called when the app launches (see the initState function)
  void firstLoad() async {
    editorialListing.clear();
  page=1;
    firstLoading (true);
    try {
       var res =
         await _editorialProvider
             .getcourses(date: select_date.value, page: page.toString());

      getcourselist.value=res!;
      update();
        if(getcourselist.value.editorials!.data!.isNotEmpty){
       editorialListing.addAll(getcourselist.value.editorials!.data!);
        }
    } catch (err) {
    }

finally {
  firstLoading(false);
}
  }

  void _loadMore() async {
    if(getcourselist.value.editorials!.currentPage!<getcourselist.value.editorials!.lastPage!)
    {
      if (nextPage.value == true &&
          firstLoading.value == false &&
          loadMore.value == false &&
          editorialList!.position.extentAfter < 300) {
        loadMore  (true); // Display a progress indicator at the bottom
        page += 1; // Increase _page by 1
        try {
          var res=await _editorialProvider
              .getcourses(date: select_date.value, page: page.toString()) ;
          final List fetchedPosts = res!.editorials!.data!;
          if (fetchedPosts.isNotEmpty) {
            editorialListing.addAll(fetchedPosts);
            update();
          } else {

            nextPage  (false);
            update();
          }
        } catch (err) {

        }
        loadMore  (false);
        update();

      }
    }
    else{
      nextPage(false);
      loadMore  (false);
      update();
    }
  }

}
