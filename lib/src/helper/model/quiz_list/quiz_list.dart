class QuizListing {
  String? result;
  String? message;
  Content? content;

  QuizListing({this.result, this.message, this.content});

  QuizListing.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    return data;
  }
}

class Content {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Content(
      {this.currentPage,
        this.data,
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

  Content.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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

class Data {
  int? id;
  int? categoryId;
  int? editorialId;
  String? title;
  String? image;
  int? mark;
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    editorialId = json['editorial_id'];
    title = json['title'];
    image = json['image'];
    mark = json['mark'];
    negativeMark = json['negative_mark'];
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