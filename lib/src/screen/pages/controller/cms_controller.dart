import 'package:english_madhyam/resrc/models/model/cms.dart';
import 'package:get/get.dart';

import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';

class CMSSController extends GetxController {
  RxBool loading = false.obs;
  Rx<CMSPAGES> cmsData = CMSPAGES().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    cmssPagesController();
  }

  void cmssPagesController() async {
    try {
      loading(true);
      var response = await apiService.cmsPages();
      loading(false);
      if (response != null) {
        cmsData.value = response;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      loading(false);
    }
  }
}
