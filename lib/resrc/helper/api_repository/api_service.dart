import 'dart:convert';
import 'package:english_madhyam/resrc/models/model/NotificationModel.dart';
import 'package:english_madhyam/resrc/models/model/all_category.dart';
import 'package:english_madhyam/resrc/models/model/apply_coupon_model.dart';
import 'package:english_madhyam/resrc/models/model/birthdayModel.dart';
import 'package:english_madhyam/resrc/models/model/categoryEditorial.dart';
import 'package:english_madhyam/resrc/models/model/choose_plan_model/choose_plan_model.dart';
import 'package:english_madhyam/resrc/models/model/cms.dart';
import 'package:english_madhyam/resrc/models/model/coupon_list_ldel.dart';
import 'package:english_madhyam/resrc/models/model/deviceinfo_model.dart';
import 'package:english_madhyam/resrc/models/model/editorial_detail_model/editorial_detail.dart';
import 'package:english_madhyam/resrc/models/model/editorials_model/getcoursesmodel.dart';
import 'package:english_madhyam/resrc/models/model/feed_model/feed_model.dart';
import 'package:english_madhyam/resrc/models/model/graph_data/graph_data_model.dart';
import 'package:english_madhyam/resrc/models/model/home_model/home_model.dart';
import 'package:english_madhyam/resrc/models/model/mandatoryupdate_model.dart';
import 'package:english_madhyam/resrc/models/model/meaning_list.dart';
import 'package:english_madhyam/resrc/models/model/meaning_model.dart';
import 'package:english_madhyam/resrc/models/model/pdf_list_model.dart';
import 'package:english_madhyam/resrc/models/model/plan_detail/plan_detial.dart';
import 'package:english_madhyam/resrc/models/model/profile_model/profile_model.dart';
import 'package:english_madhyam/resrc/models/model/purchase_history_model.dart';
import 'package:english_madhyam/resrc/models/model/quiz_details.dart';
import 'package:english_madhyam/resrc/models/model/quiz_list/quiz_list.dart';
import 'package:english_madhyam/resrc/models/model/secondarywarning_model.dart';
import 'package:english_madhyam/resrc/models/model/submit_exam/submit_exam.dart';
import 'package:english_madhyam/resrc/models/model/succes.dart';
import 'package:english_madhyam/resrc/models/model/updateprofileModel.dart';
import 'package:english_madhyam/resrc/models/model/video_cat_model.dart';
import 'package:english_madhyam/resrc/models/model/youtube_list.dart';
import 'package:english_madhyam/src/screen/category/model/subCategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../../../src/commonController/authenticationController.dart';
import '../../../src/auth/log_out/log_out_model.dart';
import '../../../src/auth/login/model/login_model.dart';
import '../../../src/auth/login/model/new_usermodel.dart';
import '../../../src/auth/otp/send_otp_model/send_otp.dart';
import '../../../src/auth/sign_up/model/signup_model.dart';
import '../../../src/chatGpt/model/chatGptModel.dart';
import '../../../src/screen/category/model/parentCategoryModel.dart';
import '../../../src/screen/favorite/model/attemptedExamData.dart';
import '../../../src/screen/favorite/model/questionDataModel.dart';
import '../../../src/screen/favorite/model/wardDataModel.dart';
import '../../../src/screen/favorite/saveDataModel.dart';
import '../../../src/screen/leader_Board/model/LeadboardModel.dart';
import 'app_url.dart';
import 'base_client.dart';
import 'package:dio/src/form_data.dart' as Form;
import 'package:dio/src/multipart_file.dart' as Multi;
import 'package:dio/dio.dart' as dIo;
import 'package:http_parser/http_parser.dart';
import 'exceptions.dart';

ApiService apiService = Get.find<ApiService>();

class ApiService extends GetxService {
  late RestClient _restClient;
  Map<String, dynamic>? headers;
  late final AuthenticationManager _authManager;

  Future<ApiService> init() async {
    _authManager = Get.find();
    if (_authManager.getToken() != null) {
      headers = {
        "Accept": "application/json",
        "Authorization": "Bearer ${_authManager.getToken()!}",
      };
    } else {
      headers = {
        "Accept": "application/json",
      };
    }
    _restClient = RestClient();
    _restClient.init();
    return this;
  }

  Map<String, dynamic> getHeaders() {
    if (_authManager.getToken() != null) {
      headers = {
        "Accept": "application/json",
        "Authorization": "Bearer " + _authManager.getToken()!,
      };
    } else {
      headers = {
        "Accept": "application/json",
      };
    }
    return headers!;
  }

  Future<UserModel?> sendOtp(dynamic map) async {
    try {
      var response = await _restClient.postData(
          url: AppUrl.send_otp, payload: jsonEncode(map), headers: headers);
      return UserModel.fromJson(response);
    } catch (exception) {
      checkException(exception);
      rethrow;
    }
  }

  Future<SendOTP?> verifyOtp(dynamic map) async {
    try {
      var response = await _restClient.postData(
          url: AppUrl.verifyOtp, payload: jsonEncode(map), headers: headers);
      return SendOTP.fromJson(response);
    } catch (exception) {
      checkException(exception);
      rethrow;
    }
  }

  Future<NewUserModel?> socialLogin(dynamic map) async {
    try {
      var response = await _restClient.postData(
          url: AppUrl.is_new_user, payload: jsonEncode(map), headers: headers);
      return NewUserModel.fromJson(response);
    } catch (exception) {
      checkException(exception);
      rethrow;
    }
  }

  Future<UserModel?> login(dynamic map) async {
    try {
      var response = await _restClient.postData(
          url: AppUrl.login, payload: jsonEncode(map), headers: headers);
      return UserModel.fromJson(response);
    } catch (exception) {
      checkException(exception);
      rethrow;
    }
  }

  Future<SignUpModel?> signup(dynamic map) async {
    try {
      var response = await _restClient.postData(
          url: AppUrl.signup, payload: jsonEncode(map), headers: headers);
      return SignUpModel.fromJson(response);
    } catch (exception) {
      checkException(exception);
      rethrow;
    }
  }
  Future<SignUpModel>reportQuestion(dynamic map)async{
    try {
      var response = await _restClient.postData(
          url: AppUrl.reportQuestion, payload: jsonEncode(map), headers: headers);
      return SignUpModel.fromJson(response);
    } catch (exception) {
      checkException(exception);
      rethrow;
    }
  }

  Future<BirthDayModel?> birthDayData() async {
    Map requestBody = {
      "token": _authManager.getToken(),
    };
    var response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/birthday_details",
        payload: jsonEncode(requestBody),
        headers: headers);
    try {
      return BirthDayModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<LogOutModel?> logOutApi() async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "user_id": _authManager.getUsername(),
      "deviceID": "",
    };
    var response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/logout",
        payload: jsonEncode(requestBody),
        headers: headers);
    try {

      return LogOutModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  } //Log OUT

  Future<MandatoryUpdate?> mandatoryUpdate() async {
    Map requestBody = {"token": _authManager.getToken()};
    var response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/app_version", payload: jsonEncode(requestBody));
    try {
      return MandatoryUpdate.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  ///warning popUp
  Future<Success?> warningPop() async {
    var response = await _restClient.getData(url: "${AppUrl.baseUrl}/app_msg");
    try {
      return Success.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<DeviceInfo?> saveDeviceInfo(
      {required String deviceType,
      required String deviceName,
      required String ipAddress,
      required String osVersion,
      required String deviceToken}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "device_type": deviceType,
      "device_name": deviceName,
      "ip_address": ipAddress,
      "os_version": osVersion,
      "device_token": deviceToken
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/dev/device_info", payload: requestBody);

    try {
      return DeviceInfo.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<SecondaryWarningModel?> secondaryWarning() async {
    Map requestBody = {"package_id": "com.education.english_madhyam"};
    final response = await _restClient.postData(
        url: "https://www.teknikoglobal.com/home/get_application_status",
        payload: requestBody);
    try {
      return SecondaryWarningModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //plan list
  Future<ChoosePlanModel?> getCourseList(
      {required String page, required String subCateId}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "page": page,
      "sub_category": subCateId ?? ""
    };

    final response = await _restClient.postData(
        url: AppUrl.getChildCategory, payload: requestBody);
    try {
      return ChoosePlanModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ChoosePlanModel?> getCourseListOld(
      {required String page, required String subCateId}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "page": page,
      "sub_category": subCateId ?? ""
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/categoryTypeList", payload: requestBody);
    try {
      return ChoosePlanModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //plan list
  Future<PlanDetailModel?> getPlanDetails() async {
    Map requestBody = {
      "token": _authManager.getToken(),
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/subscription_plans", payload: requestBody);
    try {
      return PlanDetailModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<GetCoursesModel?> getCoursesList(
      {String? date, required String page}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "date": date,
      "page": page
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/get_editorials", payload: requestBody);
    try {
      return GetCoursesModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

// Start Exam
  Future<Success?> startExam({required int examId}) async {
    Map requestBody = {"token": _authManager.getToken(), "exam_id": examId};
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/startExam", payload: requestBody);

    try {
      return Success.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //Pause Exam
  Future<Success?> pauseExam(dynamic requestBody) async {
    jsonEncode(requestBody);
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/pause_exam", payload: requestBody);
    try {
      return Success.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //question Attempt
  Future<Success?> attemptQuestion(
      {required String examId,
      required String timeLeft,
      required String questionId,
      required String optionSelect}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "exam_id": examId,
      "time_left": timeLeft,
      "question_id": questionId,
      "selected_option": optionSelect
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/attempt_question", payload: requestBody);
    try {
      return Success.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<SubmitExam?> submitExam(
      {required String examId,
      required String examData,
      required String remainTime}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "examId": examId,
      "examData": examData,
      "time_left": remainTime,
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/submit_exam", payload: requestBody);
    try {
      return SubmitExam.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //
  Future<EditorialDetailsModel?> getEditorialDetails({String? courseId}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "editorial_id": courseId
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/editorial_details", payload: requestBody);

    try {
      return EditorialDetailsModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> downloadPdfFile(
      {dynamic filePath, dynamic savePath}) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    final response =
        await _restClient.downloadData(filePath: filePath, savePath: savePath);

    result['isSuccess'] = response.statusCode == 200;
    result['filePath'] = savePath;
    try {
      return result;
    } catch (e) {
      checkException(e);
      return result;
    }
  }

  Future<PdfList?> pdfListProv(
      {required String type, required String id}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "type": type,
      "category_id": id,
    };

    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/v3getPdfList", payload: requestBody);
    try {
      return PdfList.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //Editorials by category
  Future<EditorialCat?> getEditorialDetailsByCat(
      {String? catId, required String page}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "category_id": catId,
      "page": page,
      "version": 1
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/get_editorials_by_category",
        payload: requestBody);
    try {
      return EditorialCat.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //word meaning

  Future<MeaningModel?> wordMeaning({String? word, required String id}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "word": word,
      "editorial_id": id
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/editorial_vocab", payload: requestBody);
    try {
      return MeaningModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<TextCompletionModel?> wordMeaningGpt({dynamic body}) async {
    final encodedParams = json.encode(body);

    /*final response = await _restClient.postData(
        url: endPoint("completions"), payload: encodedParams,headers: headerBearerOption(OPEN_AI_KEY));
    try {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));

      return TextCompletionModel.fromJson(responseJson);
    } catch (e) {
      checkException(e);
      return null;
    }*/
  }

  // word meaning list
  Future<MeaningList?> wordMeaningList({String? id}) async {
    Map requestBody = {"token": _authManager.getToken(), "editorial_id": id};
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/editorial_vocabs_list", payload: requestBody);
    try {
      return MeaningList.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ExamDetails?> getQuizDetails({required int examId}) async {
    Map requestBody = {"token": _authManager.getToken(), "examId": examId};
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/exam_details", payload: requestBody);
    try {
      return ExamDetails.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<FeedModel?> getFeed({String? type, required String date}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "type": type,
      "date": date
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/daily_learnings", payload: requestBody);

    try {
      return FeedModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<FeedModel?> getFeedPagination({
    required int page,
  }) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "type": "word",
      "date": "2",
      "page": page
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/daily_learnings", payload: requestBody);

    try {
      return FeedModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<GraphData?> graphData({required String examId}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "examId": examId,
    };

    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/graphData", payload: requestBody);

    try {
      return GraphData.fromJson(response);
    } catch (e) {
      checkException(e);
    }
    return null;
  }

  Future<HomeApiModel?> homeApi() async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "device_id": (await PlatformDeviceId.getDeviceId)
    };

    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/home", payload: requestBody);

    try {
      return HomeApiModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<Success?> checkPAyment(
      {required String amount,
      required String pay,
      required planId,
      required paymentMethod}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "amount": amount,
      "txn_id": pay,
      "plan_id": planId,
      "payment_method": paymentMethod
    };

    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/check_payment", payload: requestBody);
    try {
      return Success.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //Apply Coupon
  Future<ApplyCoupon?> applyCoupon(
      {required String plan_id, required String coupon}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "coupon_code": coupon,
      "plan_id": plan_id,
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/apply_coupon", payload: requestBody);
    try {
      return ApplyCoupon.fromJson(response);
    } on dIo.DioError catch (e) {
      checkException(e);
      return null;
    }
  }

  //Coupon List
  Future<CouponList?> couponList() async {
    Map requestBody = {
      "token": _authManager.getToken(),
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/coupons_list", payload: requestBody);
    try {
      return CouponList.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<PurchaseHistoryModel?> purchaseHistory() async {
    Map requestBody = {
      "token": _authManager.getToken(),
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/purchase_history", payload: requestBody);
    try {
      return PurchaseHistoryModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ProfileGet?> profileGetApi() async {
    Map requestBody = {
      "token": _authManager.getToken(),
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/profile", payload: requestBody);
    try {
      return ProfileGet.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<LeadboardModel?> getLeaderboardPage({examId,cateId}) async {
    Map requestBody = {"token": _authManager.getToken(), "exam_id": examId,"category_id": cateId};
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/StudentsLeadboard", payload: requestBody);
    try {
      return LeadboardModel.fromJson(response);
    } catch (e) {
      print(e);
      checkException(e);
      return null;
    }
  }

  Future<UpdateProfileModel?> updateProfile(
      {String? name,
      String? username,
      String? dateBirthday,
      String? image,
      String? stateId,
      String? cityId,
      String? emailId}) async {
    var dio = dIo.Dio();
    if (image != null) {
      String fileName = image.split('/').last;
      Form.FormData formData = Form.FormData.fromMap({
        "token": _authManager.getToken(),
        "name": name,
        "date_of_birth": dateBirthday,
        "username": username,
        "email": emailId,
        "state_id": "",
        "city_id": "",
        "image": await Multi.MultipartFile.fromFile(image,
            filename: fileName, contentType: MediaType("image", "jpg")),
      });
      try {
        dIo.Response response = await dio.post(
            "https://englishmadhyam.info/api/update_profile",
            data: formData);

        return UpdateProfileModel.fromJson(response.data);
      } catch (e) {
        checkException(e);
        return null;
      }
    } else {
      Form.FormData formData = Form.FormData.fromMap({
        "token": _authManager.getToken(),
        "name": name,
        "date_of_birth": dateBirthday,
        "username": username,
        "email": emailId,
        "state_id": stateId,
        "city_id": cityId,
      });

      try {
        dIo.Response response = await dio.post(
            "https://englishmadhyam.info/api/update_profile",
            data: formData);

        return UpdateProfileModel.fromJson(response.data);
      } catch (e) {
        checkException(e);
      }
    }
  }

  Future<QuizListing?> getPracticeListExam(
      {required String type,
      int? editorialId,
      required String id,
      int? page}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "type": type,
      "editorial_id": editorialId,
      "category_id": id,
      "page": page
    };
    /*try {
      print(requestBody);
      final response = await _restClient.postData(
          url: AppUrl.baseUrl + "/dev/exam_list", payload: requestBody);
      print(response);
      return QuizListing.fromJson(response);
    } catch (e) {
      checkException(e);
      print(e.toString());
      return null;
    }*/
    try {
      final response = await _restClient.postData(
          url: "${AppUrl.baseUrl}/dev/exam_list", payload: requestBody);
      return QuizListing.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<SaveDataModel?> saveQuestionToListApi({questionId}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "question_id": questionId
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/save_question", payload: requestBody);
    try {
      return SaveDataModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<QuestionDataModel?> getSaveQuestionListApi() async {
    Map requestBody = {
      "token": _authManager.getToken(),
    };
//TODO SAVED question match the words
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/saved_questions_list", payload: requestBody);
    print(response);
    try {
      return QuestionDataModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<SaveDataModel?> removeQuestionFromListApi({questionId}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "question_id": questionId
    };

    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/remove_saved_question", payload: requestBody);
    try {
      return SaveDataModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<SaveDataModel?> saveWordsToListApi({wordId}) async {
    Map requestBody = {"token": _authManager.getToken(), "word_id": wordId};

    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/save_word", payload: requestBody);
    try {
      return SaveDataModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<WordDataModel?> getSaveWordsListApi() async {
    Map requestBody = {
      "token": _authManager.getToken(),
    };

    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/words_list", payload: requestBody);
    try {
      print("res of world list ${response}");
      return WordDataModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<SaveDataModel?> removeWordsFromListApi({wordId}) async {
    Map requestBody = {"token": _authManager.getToken(), "word_id": wordId};

    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/remove_word", payload: requestBody);
    try {
      return SaveDataModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<GetAllQuizCategory?> getQuizCategoryList(
      {required String page}) async {
    Map requestBody = {"token": _authManager.getToken(), "page": page};
    final response = await _restClient.postData(
        url: AppUrl.getAllCategories, payload: requestBody);
    try {
      return GetAllQuizCategory.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ParentCategoryModel> getParentCategory({required String page}) async {
    Map requestBody = {"token": _authManager.getToken(), "page": page};
    final response = await _restClient.postData(
        url: AppUrl.getParentCategories, payload: requestBody);
    try {
      return ParentCategoryModel.fromJson(response);
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SubCategoryModel> getSubcategory({required String parentId}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "parent_category": parentId
    };
    final response = await _restClient.postData(
        url: AppUrl.getSubcategory, payload: requestBody);
    try {
      return SubCategoryModel.fromJson(response);
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<GetAllQuizCategory?> getChildCategory(
      {required String page, required String subCategoryId}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "page": page,
      "sub_category": subCategoryId ?? ""
    };

    final response = await _restClient.postData(
        url: AppUrl.getChildCategory, payload: requestBody);
    try {
      return GetAllQuizCategory.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<GetAllQuizCategory?> getPreviousChildCategories(
      {required String page, required String subCategoryId}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "page": page,
      "sub_category": subCategoryId ?? ""
    };
    final response = await _restClient.postData(
        url: AppUrl.getPreviousChildCategory, payload: requestBody);
    try {
      return GetAllQuizCategory.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<AttemptedExamModel?> getAttemptedExam({required String page}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "page": page,
    };
    final response = await _restClient.postData(
        url: AppUrl.attemtedExams, payload: requestBody);
    try {
      return AttemptedExamModel.fromJson(response);
    } catch (e) {
      print(e);
      checkException(e);
      return null;
    }
  }

  Future<CMSPAGES?> cmsPages() async {
    final response =
        await _restClient.getData(url: "${AppUrl.baseUrl}/cms_pages");
    try {
      return CMSPAGES.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<YoutubeListModel?> videoListPro({required String id}) async {
    Map requestBody = {"token": _authManager.getToken(), "category_id": id};

    print(requestBody);
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/getYoutubeLinks", payload: requestBody);
    try {
      return YoutubeListModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<VideoCategoriesModel?> videoCatPro(String page) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      // "page":page
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/getAllCategoriesVideoCount",
        payload: requestBody);

    try {
      return VideoCategoriesModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<NotificationRespoModel?> notificationList() async {
    Map requestBody = {
      "token": _authManager.getToken(),
    };
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/notification_list", payload: requestBody);

    try {
      return NotificationRespoModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ReadedNotification?> notificationRead(
      {required String notificationId}) async {
    Map requestBody = {
      "token": _authManager.getToken(),
      "notification_id": notificationId
    };

    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/read_notification", payload: requestBody);
    try {
      return ReadedNotification.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ReadedNotification> clearALlNotificationProvider() async {
    Map requestBody = {"token": _authManager.getToken()};
    final response = await _restClient.postData(
        url: "${AppUrl.baseUrl}/clear_notification", payload: requestBody);
    return ReadedNotification.fromJson(response);
  }
}

void checkException(Object exception) {
  if (exception is ServerException) {
    Get.snackbar(
      "Http status error [500]",
      (exception).message.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else if (exception is ClientException) {
    Get.snackbar(
      "Http status error [500]",
      (exception as ServerException).message.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else if (exception is HttpException) {
    Get.snackbar(
      "Network",
      "Please check your internet connection.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
