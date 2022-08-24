import 'package:english_madhyam/src/helper/model/video_cat_model.dart';
import 'package:english_madhyam/src/helper/model/youtube_list.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoListProvider extends GetConnect{
  HttpService _httpService=HttpService();
  static ApiBaseHelper _apiBaseHelper=ApiBaseHelper();

  Future<YoutubeListModel?> videolistPro({required String id}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "category_id":id


    };
    final response = await _apiBaseHelper.post('getYoutubeLinks',requestBody);
    try {


      return YoutubeListModel.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }
  Future<VideoCategoriesModel?> videoCatPro(String page) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      // "page":page



    };
    final response = await _apiBaseHelper.post('getAllCategoriesVideoCount',requestBody);
    try {


      return VideoCategoriesModel.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}