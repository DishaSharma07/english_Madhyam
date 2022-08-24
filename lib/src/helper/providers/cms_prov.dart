import 'package:english_madhyam/src/helper/model/cms.dart';
import 'package:english_madhyam/src/helper/model/quiz_list/quiz_list.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CmssProvider extends GetConnect{
  HttpService _httpService=HttpService();
  static ApiBaseHelper _apiBaseHelper=ApiBaseHelper();

  Future<CMSPAGES?> CmsPages() async {

    final response = await _apiBaseHelper.get('cms_pages');
    try {


      return CMSPAGES.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}