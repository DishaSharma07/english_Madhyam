class QuizListing {
  String? result;
  String? message;
  List<Content>? content;

  QuizListing({this.result, this.message, this.content});

  QuizListing.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  int? id;
  int? categoryId;
  int? editorialId;
  String? title;
  String? image;
  double? mark;
  double? negativeMark;
  int? type;
  int? isDailyQuiz;
  String? duration;
  String? instruction;
  int? totalQuestions;
  String? publishAt;
  int? status;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  int? isBookmark;
  int? examQuestionCount;
  bool? attempted;
  bool? completed;

  Content(
      {this.id,
        this.categoryId,
        this.editorialId,
        this.title,
        this.image,
        this.mark,
        this.negativeMark,
        this.type,
        this.isDailyQuiz,
        this.duration,
        this.instruction,
        this.totalQuestions,
        this.publishAt,
        this.status,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.isBookmark,
        this.examQuestionCount,
        this.attempted,
        this.completed});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    editorialId = json['editorial_id'];
    title = json['title'];
    image = json['image'];
    mark = double.parse(json['mark'].toString());
    negativeMark = double.parse(json['negative_mark'].toString());
    type = json['type'];
    isDailyQuiz = json['is_daily_quiz'];
    duration = json['duration'];
    instruction = json['instruction'];
    totalQuestions = json['total_questions'];
    publishAt = json['publish_at'];
    status = json['status'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isBookmark = json['is_bookmark'];
    examQuestionCount = json['exam_question_count'];
    attempted = json['attempted'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['editorial_id'] = this.editorialId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['mark'] = this.mark;
    data['negative_mark'] = this.negativeMark;
    data['type'] = this.type;
    data['is_daily_quiz'] = this.isDailyQuiz;
    data['duration'] = this.duration;
    data['instruction'] = this.instruction;
    data['total_questions'] = this.totalQuestions;
    data['publish_at'] = this.publishAt;
    data['status'] = this.status;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['is_bookmark'] = this.isBookmark;
    data['exam_question_count'] = this.examQuestionCount;
    data['attempted'] = this.attempted;
    data['completed'] = this.completed;
    return data;
  }
}


