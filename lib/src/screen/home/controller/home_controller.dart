import 'dart:io';
import 'package:english_madhyam/resrc/models/model/birthdayModel.dart';
import 'package:english_madhyam/resrc/models/model/home_model/home_model.dart';
import 'package:english_madhyam/resrc/models/model/mandatoryupdate_model.dart';
import 'package:english_madhyam/resrc/utils/ui_helper.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';

const PLAY_STORE_URL =
    'https://play.google.com/store/apps/details?id=com.education.english_madhyam';

const APP_STORE_URL =
    'https://apps.apple.com/us/app/english-madhyam/id6443469637';

class HomeController extends GetxController {
  var loading = false.obs;
  var birthLoading = false.obs;
  Rx<BirthDayModel> birthDayModel = BirthDayModel().obs;
  Rx<MandatoryUpdate> mandatoryUpdateRx = MandatoryUpdate().obs;
  final AuthenticationManager authController = Get.find();

  List<Banners> banner = <Banners>[].obs;
  List<Quizz> dailyQuizList = <Quizz>[].obs;
  List<Achievers> achievers = <Achievers>[].obs;
  List<Editorials> courses = <Editorials>[].obs;
  var mentors = "".obs;
  var isSubscribed = false.obs;
  var successRate = "".obs;
  var greeting = "".obs;

  RxString students = "".obs;

  var _currAppVersion = "";
  get currAppVersion => _currAppVersion;

  Future<void> homeApiFetch() async {
    loading(true);
    HomeApiModel? response = await apiService.homeApi();
    loading(false);
    if (response != null) {
      banner = response.homeDetails!.banners!;
      dailyQuizList = response.homeDetails!.quizz!;
      achievers = response.homeDetails!.achievers!;
      courses = response.homeDetails!.editorials!;
      isSubscribed.value = response.homeDetails!.isSubscribed!;
      mentors.value = response.homeDetails!.mentors.toString();
      successRate.value = response.homeDetails!.successRate.toString();
      students.value = response.homeDetails!.students.toString();
      //birthdayData();
    }
  }

  Future<void> birthdayData() async {
    try {
      var response = await apiService.birthDayData();
      if (response != null) {
        birthDayModel.value = response;
        if (response.result == true) {
          authController.setBirthdayAndShowed(true, false);
        } else {
          authController.setBirthdayAndShowed(false, true);
        }
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> versionCheck() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      double currentAppVersion =
          double.parse(info.buildNumber.trim().replaceAll(".", ""));

      var response = await apiService.mandatoryUpdate();
      if (response != null) {
        mandatoryUpdateRx.value = response;
        if (response.version!.androidMan! > currentAppVersion) {
          var result = await UiHelper.showInfoDialog();
          if (result) {
            _launchURL(PLAY_STORE_URL);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  var iosAppVersion = 10;
  Future<void> versionCheckIOs() async {
    try {
      var response = await apiService.mandatoryUpdate();
      if (response != null) {
        mandatoryUpdateRx.value = response;
        if (response.version!.iosMan! > iosAppVersion) {
          var result = await UiHelper.showInfoDialog();
          if (result) {
            _launchURL(PLAY_STORE_URL);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      var result = await launchUrl(Uri.parse(url));
      if (Platform.isAndroid) {
        versionCheck();
      } else {
        versionCheckIOs();
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      if (Platform.isAndroid) {
        //versionCheck();
      } else {
        //versionCheckIOs();
      }
    });
    greetings();
  }
  greetings() {
    DateTime now = DateTime.now();
    int hours = now.hour;
    if (hours >= 1 && hours <= 12) {
      greeting.value = "Good Morning";
    } else if (hours >= 12 && hours <= 16) {
      greeting.value = "Good Afternoon";
    } else if (hours >= 16 && hours <= 21) {
      greeting.value = "Good Evening";
    } else if (hours >= 21 && hours <= 24) {
      greeting.value = "Good Night";
    }
    return "";
  }
}
