import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/profile_model/profile_model.dart';
import 'package:english_madhyam/src/helper/model/updateprofileModel.dart';
import 'package:english_madhyam/src/network/api_heper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart'as dIo;
import 'package:dio/src/form_data.dart' as Form;
import 'package:dio/src/multipart_file.dart' as Multi;
import 'package:http_parser/http_parser.dart';
class ProfileProvider extends GetConnect {
  static ApiBaseHelper _apiHelper = ApiBaseHelper();

//Exception Toast
  static showExceptionToast() {
    Fluttertoast.showToast(msg: 'Something Went Wrong', timeInSecForIosWeb: 10);
    cancel();

  }

  //Fetch Profile data

  Future<ProfileGet?> profileGetApi() async {
    final _prefs = await SharedPreferences.getInstance();

    Map requestBody = {
      "token": _prefs.getString('token'),
    };
    final response = await _apiHelper.post('profile', requestBody);
    try {

      return ProfileGet.fromJson(response);
    } catch (e) {
      showExceptionToast();
      return null;
    }
  }

   Future<UpdateProfileModel?> updateprofile({String? name,String? username, String? dateob, String? image, String? State, String? City, String? Email}) async {
    final pref = await SharedPreferences.getInstance();
    var dio = dIo.Dio();
    if(image!=null){
      String fileName = image.split('/').last;
      Form.FormData formData = Form.FormData.fromMap(
          {
            "token":pref.getString("token"),
            "name":name,
            "date_of_birth":dateob,
            "username":username,
            "email":Email,
            "state_id":State,
            "city_id":City,
            "image": await Multi.MultipartFile.fromFile(
              image,
              filename: fileName,
              contentType: MediaType("image","jpg")
            ),
          }
      );

      try{
        dIo.Response response =await dio.post("https://englishmadhyam.info/api/update_profile",data: formData);


        return UpdateProfileModel.fromJson(response.data);
      }
      catch(e){


        Fluttertoast.showToast(msg: e.toString());
        cancel();

        return null;
      }
    }
    else{
      Form. FormData formData = Form.FormData.fromMap(
          {
            "token":pref.getString("token"),
            "name":name,
            "date_of_birth":dateob,
            "username":username,
            "email":Email,
            "state_id":State,
            "city_id":City,

          }
      );


      try{
        dIo.Response response =await dio.post("https://englishmadhyam.info/api/update_profile",data: formData);



        return UpdateProfileModel.fromJson(response.data);}
      catch(e){

         Fluttertoast.showToast(msg: e.toString());
        cancel();

      }
    }


  }
}
