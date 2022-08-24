class SubmitExam {
  String ?result;
  String ?message;



  SubmitExam({this.result, this.message});

  SubmitExam.map(dynamic obj) {
    this.result = obj["result"];
    this.message = obj["message"];
  }
  SubmitExam.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];

  }
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["result"] = result;
    map["message"] = message;
    return map;
  }

}