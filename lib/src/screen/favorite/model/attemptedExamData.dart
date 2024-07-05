
class AttemptedExamModel {
  String? result;
  String? message;
  Data? data;

  AttemptedExamModel({this.result, this.message, this.data});

  AttemptedExamModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<ExamParent>? examParent;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
        this.examParent,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      examParent = <ExamParent>[];
      json['data'].forEach((v) {
        examParent!.add(new ExamParent.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.examParent != null) {
      data['data'] = this.examParent!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class ExamParent {
  int? examId;
  int? totalQuestion;
  int? correctQuestion;
  int? incorrectQuestion;
  int? skipQuestion;
  dynamic totalMarks;
  dynamic marks;
  String? time;
  String? createdAt;
  ExamDetail? examDetails;
  CategoryDetails? categoryDetails;

  ExamParent(
      {this.examId,
        this.totalQuestion,
        this.correctQuestion,
        this.incorrectQuestion,
        this.skipQuestion,
        this.totalMarks,
        this.marks,
        this.time,
        this.createdAt,
        this.examDetails,
        this.categoryDetails});

  ExamParent.fromJson(Map<String, dynamic> json) {
    examId = json['exam_id'];
    totalQuestion = json['total_question'];
    correctQuestion = json['correct_question'];
    incorrectQuestion = json['incorrect_question'];
    skipQuestion = json['skip_question'];
    totalMarks = json['total_marks'];
    marks = json['marks'];
    time = json['time'];
    createdAt = json['created_at'];
    examDetails = json['exam_details'] != null
        ? new ExamDetail.fromJson(json['exam_details'])
        : null;
    categoryDetails = json['category_details'] != null
        ? new CategoryDetails.fromJson(json['category_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exam_id'] = this.examId;
    data['total_question'] = this.totalQuestion;
    data['correct_question'] = this.correctQuestion;
    data['incorrect_question'] = this.incorrectQuestion;
    data['skip_question'] = this.skipQuestion;
    data['total_marks'] = this.totalMarks;
    data['marks'] = this.marks;
    data['time'] = this.time;
    data['created_at'] = this.createdAt;
    if (this.examDetails != null) {
      data['exam_details'] = this.examDetails!.toJson();
    }
    if (this.categoryDetails != null) {
      data['category_details'] = this.categoryDetails!.toJson();
    }
    return data;
  }
}

class ExamDetail {
  int? categoryId;
  String? title;

  ExamDetail({this.categoryId, this.title});

  ExamDetail.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    return data;
  }
}

class CategoryDetails {
  int? id;
  String? name;
  dynamic type;

  CategoryDetails({this.id, this.name, this.type});

  CategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}
