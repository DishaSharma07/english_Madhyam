import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/resrc/models/model/profile_model/profile_model.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';

class ProfileControllers extends GetxController {
  var loading = true.obs;
  var updateLoading = true.obs;
  Rx<ProfileGet> profileGet = ProfileGet().obs;
  var globalsubscription = "".obs;

  // It is mandatory initialize with one value from listType
  final selected = "Select city".obs;

  void setSelected(String? value) {
    selected.value = value!;
  }

  @override
  void onInit() async {
    super.onInit();
    profileDataFetch();
  }
  // Profile data fetch editorial_controller
  Future<bool?> profileDataFetch() async {
    try {
      loading(true);
      var response = await apiService.profileGetApi();
      loading(false);
      if (response != null) {
        profileGet.value.user = response.user;
        globalsubscription.value = response.user!.isSubscription.toString();
        return true;
      }
    } catch (e) {
      loading(false);
    }
  }


// Refresh Profile
  void refreshList() async {
    try {
      profileDataFetch();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      cancel();
    }
  }

  void updateProfile(
      {String? name,
      String? birthDay,
      String? image,
      String? state,
      String? city,
      String? email,
      String? userName}) async {
    try {
      updateLoading(true);
      var updateProfile = await apiService.updateProfile(
          name: name,
          dateBirthday: birthDay,
          image: image,
          stateId: state,
          emailId: email,
          cityId: city,
          username: userName);
      if (updateProfile?.result=="success") {
        Fluttertoast.showToast(msg: updateProfile?.message??"");
        cancel();
        refreshList();
      } else {
        Fluttertoast.showToast(msg: updateProfile!.message.toString());
        cancel();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      cancel();
    } finally {
      updateLoading(false);
    }
  }
}
