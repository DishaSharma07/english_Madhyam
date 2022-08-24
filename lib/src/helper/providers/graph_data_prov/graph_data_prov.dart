import 'package:english_madhyam/src/helper/model/graph_data/graph_data_model.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class GraphDataProv extends GetConnect{
  HttpService _httpService=HttpService();
  ApiBaseHelper _apiBaseHelper=ApiBaseHelper();
  
  Future<GraphData>graphData({required String examid})async{
    final _pref=await SharedPreferences.getInstance();
    Map requestBody={
      "token":_pref.getString("token"),
      "examId":examid,
    };
    var response=await _apiBaseHelper.post('graphData', requestBody);
    try{
      return GraphData.fromJson(response);
    }catch(e){
      return _httpService.showExceptionToast();

    }
    


  }
}