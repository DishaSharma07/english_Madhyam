import 'package:english_madhyam/src/helper/model/pdf_list_model.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFProvider extends GetConnect{
  HttpService _httpService=HttpService();
  static ApiBaseHelper _apiBaseHelper=ApiBaseHelper();

  Future<PdfList?> pdflistProv({required String type,required String id}) async {
    final prefs=await SharedPreferences.getInstance();
    Map requestBody = {
      "token": prefs.getString("token"),
      "type":type,
      "category_id":id

    };
    final response = await _apiBaseHelper.post('getPdfList',requestBody);
    try {


      return PdfList.fromJson(response);
    } catch (e) {
      _httpService.showExceptionToast();
      return null;
    }
  }

}