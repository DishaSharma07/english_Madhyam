class LeadboardModel {
  String? data;
  String? message;
  List<Leadboard>? leadboard;
  int? total;

  LeadboardModel({this.data, this.message, this.leadboard, this.total});

  LeadboardModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    if (json['leadboard'] != null) {
      leadboard = <Leadboard>[];
      json['leadboard'].forEach((v) {
        leadboard!.add(new Leadboard.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    if (this.leadboard != null) {
      data['leadboard'] = this.leadboard!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Leadboard {
  int? id;
  int? userId;
  int? examId;
  dynamic examData;
  int? totalQuestion;
  int? correctQuestion;
  int? incorrectQuestion;
  int? skipQuestion;
  dynamic totalMarks;
  dynamic marks;
  String? time;
  int? rank;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? username;
  String? email;
  dynamic wallet;
  String? password;
  String? slug;
  int? loginEnabled;
  String? phone;
  String? dateOfBirth;
  int? stateId;
  int? cityId;
  int? referredBy;
  int? isDelete;
  int? status;
  String? rememberToken;

  Leadboard(
      {this.id,
        this.userId,
        this.examId,
        this.examData,
        this.totalQuestion,
        this.correctQuestion,
        this.incorrectQuestion,
        this.skipQuestion,
        this.totalMarks,
        this.marks,
        this.time,
        this.rank,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.username,
        this.email,
        this.wallet,
        this.password,
        this.slug,
        this.loginEnabled,
        this.phone,
        this.dateOfBirth,
        this.stateId,
        this.cityId,
        this.referredBy,
        this.isDelete,
        this.status,
        this.rememberToken});

  Leadboard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    examId = json['exam_id'];
    examData = json['exam_data'];
    totalQuestion = json['total_question'];
    correctQuestion = json['correct_question'];
    incorrectQuestion = json['incorrect_question'];
    skipQuestion = json['skip_question'];
    totalMarks = json['total_marks'];
    marks = json['marks'];
    time = json['time'];
    rank = json['rank'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    wallet = json['wallet'];
    password = json['password'];
    slug = json['slug'];
    loginEnabled = json['login_enabled'];
    phone = json['phone'];
    dateOfBirth = json['date_of_birth'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    referredBy = json['referredBy'];
    isDelete = json['is_delete'];
    status = json['status'];
    rememberToken = json['remember_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['exam_id'] = this.examId;
    data['exam_data'] = this.examData;
    data['total_question'] = this.totalQuestion;
    data['correct_question'] = this.correctQuestion;
    data['incorrect_question'] = this.incorrectQuestion;
    data['skip_question'] = this.skipQuestion;
    data['total_marks'] = this.totalMarks;
    data['marks'] = this.marks;
    data['time'] = this.time;
    data['rank'] = this.rank;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['wallet'] = this.wallet;
    data['password'] = this.password;
    data['slug'] = this.slug;
    data['login_enabled'] = this.loginEnabled;
    data['phone'] = this.phone;
    data['date_of_birth'] = this.dateOfBirth;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['referredBy'] = this.referredBy;
    data['is_delete'] = this.isDelete;
    data['status'] = this.status;
    data['remember_token'] = this.rememberToken;
    return data;
  }
}
