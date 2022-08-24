import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/profile_model/profile_model.dart';
import 'package:english_madhyam/src/helper/providers/profile_providers/profile_providers.dart';
import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StateCityControllers extends GetxController {
  var loading = true.obs;
  ProfileGet _profileGet = ProfileGet();

  @override
  void onInit() async {
    super.onInit();
    profileDataFetch();
  }

  // Profile data fetch editorial_controller
  Future<void> profileDataFetch() async {
    try {
      loading(true);
      var response = await ProfileProvider().profileGetApi();
      if (response!.result == "success") {
        _profileGet.user = response.user;
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
}
