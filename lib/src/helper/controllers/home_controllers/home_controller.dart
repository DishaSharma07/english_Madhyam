import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/birthdayModel.dart';
import 'package:english_madhyam/src/helper/model/home_model/home_model.dart';
import 'package:english_madhyam/src/helper/providers/home_providers/task_provider.dart';
import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var loading = true.obs;
  var Birthloading = true.obs;

  Rx<BirthDayModel> birthDayModel=BirthDayModel().obs;

  @override
  void onInit() async {
    super.onInit();
  }

  HttpService _httpService = HttpService();
  List<Banners> banner = <Banners>[].obs;
  List<Quizz> quizs = <Quizz>[].obs;
  List<Achievers> achievers = <Achievers>[].obs;
  List<Editorials> courses = <Editorials>[].obs;
  RxString Mentors = "".obs;
  RxBool is_subscribed = false.obs;
  RxString succesRate = "".obs;
  RxString students = "".obs;
  Future<void> homeApiFetch() async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      loading(true);
      var response = await TaskProvider().HomeApi(DeviceId:_prefs.getString("device_id")! );
      if (response != null) {
        banner = response.homeDetails!.banners!;
        quizs = response.homeDetails!.quizz!;
        achievers = response.homeDetails!.achievers!;
        courses = response.homeDetails!.editorials!;
        is_subscribed.value = response.homeDetails!.isSubscribed!;
        Mentors.value = response.homeDetails!.mentors.toString();
        succesRate.value = response.homeDetails!.successRate.toString();
        students.value = response.homeDetails!.students.toString();
        BirthDayContr();
        return;
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry");
      cancel();

    } finally {
      loading(false);
    }
  }
  Future<void> BirthDayContr() async {
    final _prefs = await SharedPreferences.getInstance();

    try {
      Birthloading(true);
      var response = await _httpService.BirthDay();
      if (response != null) {
        birthDayModel.value=response;
        if(response.result==true){
          _prefs.setBool("Birthday", true);
        }else{
          _prefs.setBool("Birthday", false);

        }

        return;
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry");
      cancel();

    } finally {
      Birthloading(false);
    }
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
