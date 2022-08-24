import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/profile_model/profile_model.dart';
import 'package:english_madhyam/src/helper/providers/profile_providers/profile_providers.dart';
import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileControllers extends GetxController {
  var loading = true.obs;
  var updateloading = true.obs;
  Rx<ProfileGet> profileGet = ProfileGet().obs;
  var globalsubscription = "".obs;

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
      if (response != null) {
        profileGet.value.user = response.user;
        globalsubscription.value = response.user!.isSubscription.toString();

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

  // It is mandatory initialize with one value from listType
  final selected = "Select city".obs;

  void setSelected(String? value) {
    selected.value = value!;
  }

// Refresh Profile
  void refreshList() async {
    profileDataFetch();
  }

  void updateprofile(
      {
      String? name,
      String? dateob,
      String? image,
       String? State,
       String ?City,
      String? Email,
      String? userName
      }) async {
    try {
      updateloading(true);
      var updateprofile = await ProfileProvider().updateprofile(
          name: name,
          dateob: dateob,
          image: image,
          State: State,
          Email: Email,
          City: City,
          username: userName);
      if (updateprofile!=null) {
        Fluttertoast.showToast(msg: updateprofile.message.toString());
          cancel();

          refreshList();
      } else {
        Fluttertoast.showToast(msg: updateprofile!.message.toString());
        cancel();

      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    cancel();

    } finally {
      updateloading(false);
    }
  }
}
