import 'package:english_madhyam/src/helper/model/categoryEditorial.dart';
import 'package:english_madhyam/src/helper/model/editorial_detail_model/editorial_detail.dart';
import 'package:english_madhyam/src/helper/model/meaning_list.dart';
import 'package:english_madhyam/src/helper/model/meaning_model.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditorialDetailProvider extends GetConnect{
  HttpService _httpService=HttpService();
  static ApiBaseHelper _apiBaseHelper=ApiBaseHelper();

  //
  Future<EditorialDetailsModel?> getEditorialDetails({String? course_id}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "editorial_id":course_id
    };
    final response = await _apiBaseHelper.post('editorial_details', requestBody);
    try {


      return EditorialDetailsModel.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

  //Editorials by category
  Future<EditorialCat?> getEditorialDetailsByCat({String? cat_id,required String page}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "category_id":cat_id,
      "page":page
    };
    final response = await _apiBaseHelper.post('get_editorials_by_category', requestBody);
    try {
      return EditorialCat.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

  //word meaning

  Future<MeaningModel?> wordmeaning({String? word,required String Id}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "word":word,"editorial_id":Id
    };
    final response = await _apiBaseHelper.post('editorial_vocab', requestBody);
    try {


      return MeaningModel.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

  // word meaning list
  Future<MeaningList?> wordMeaningList({String? id}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "editorial_id":id
    };
    final response = await _apiBaseHelper.post('editorial_vocabs_list', requestBody);
    try {


      return MeaningList.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}