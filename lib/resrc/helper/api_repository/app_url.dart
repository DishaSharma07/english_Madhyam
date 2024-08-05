class AppUrl {

  static const String baseUrl = 'https://englishmadhyam.info/api';
  final aPPdOMAIN = 'https://englishmadhyam.info/';

  static const String send_otp = baseUrl + '/send_otp_v2';
  static const String verifyOtp = baseUrl + '/verify_otp';

  static const String signup = baseUrl + '/register_v2';

  static const String getCity=baseUrl+"/getCity";
  static const String getState=baseUrl+"/getState";

  static const String is_new_user = baseUrl + '/is_new_user';

  static const String login = baseUrl + '/login_v2';

  static const String getAllCategories = baseUrl + '/getAllCategories';


  static const String getParentCategories = baseUrl + '/getParentCategories';
  //get by post parent_category
  static const String getSubcategory = baseUrl + '/getSubCategories';
  //get by post sub_category
  static const String getChildCategory = baseUrl + '/getChildCategories';
  ////get by previous post sub_category
  static const String getPreviousChildCategory = baseUrl + '/getChildCategories';

  static const String attemtedExams = baseUrl + '/attemtedExams';

  static const String reportQuestion=baseUrl+"/report-question";
  static const String saveQuestionList  =baseUrl+"/saved_questions_list_v2";






}
