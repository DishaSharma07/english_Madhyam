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
  List<ExamData>? data;
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
      data = <ExamData>[];
      json['data'].forEach((v) {
        data!.add(new ExamData.fromJson(v));
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

class ExamData {
  int? id;
  int? categoryId;
  dynamic editorialId;
  String? title;
  String? image;
  dynamic mark;
  dynamic negativeMark;
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
  dynamic startDate;
  dynamic endDate;
  dynamic startTime;
  dynamic endTime;
  dynamic examResult;
  UserRank? userRank;
  int? isBookmark;
  int? examQuestionCount;
  bool? attempted;
  bool? completed;

  ExamData(
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
        this.examResult,
        this.userRank,
        this.isBookmark,
        this.examQuestionCount,
        this.attempted,
        this.completed});

  ExamData.fromJson(Map<String, dynamic> json) {
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

    if(json['exam_result']!=null && json['exam_result'] is Object){
      examResult = json['exam_result'] != null
          ? new ExamResult.fromJson(json['exam_result'])
          : null;
    }else{
      examResult = <Null>[];
      json['exam_result'].forEach((v) {
        examResult!.add('');
      });
    }

    userRank = json['user_rank'] != null
        ? new UserRank.fromJson(json['user_rank'])
        : null;
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
    if (this.examResult != null && this.examResult is Object) {
      data['exam_result'] = this.examResult!.toJson();
    }else{
      if (this.examResult != null) {
        data['exam_result'] = this.examResult!.map((v) => v.toJson()).toList();
      }
    }
    if (this.userRank != null) {
      data['user_rank'] = this.userRank!.toJson();
    }
    data['is_bookmark'] = this.isBookmark;
    data['exam_question_count'] = this.examQuestionCount;
    data['attempted'] = this.attempted;
    data['completed'] = this.completed;
    return data;
  }
}

class ExamResult {
  int? id;
  int? userId;
  int? examId;
  dynamic examData;
  int? totalQuestion;
  int? correctQuestion;
  int? incorrectQuestion;
  int? skipQuestion;
  double? totalMarks;
  dynamic marks;
  String? time;
  int? rank;
  String? createdAt;
  String? updatedAt;

  ExamResult(
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
        this.updatedAt});

  ExamResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    examId = json['exam_id'];
    examData = json['exam_data'];
    totalQuestion = json['total_question'];
    correctQuestion = json['correct_question'];
    incorrectQuestion = json['incorrect_question'];
    skipQuestion = json['skip_question'];
    totalMarks = json.containsKey('total_marks') && json['total_marks']!=null?double.parse(json['total_marks'].toString()):null;
    marks = json['marks'];
    time = json['time'];
    rank = json['rank'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}

class UserRank {
  int? rank;
  int? totalStudents;

  UserRank({this.rank, this.totalStudents});

  UserRank.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    totalStudents = json['total_students'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['total_students'] = this.totalStudents;
    return data;
  }
}

/*class ExamData {
  int? id;
  int? categoryId;
  int? editorialId;
  String? title;
  String? image;
  int? mark;
  dynamic totalMarks;
  dynamic negativeMark;
  int? type;
  int? isDailyQuiz;
  String? duration;
  String? instruction;
  int? totalQuestions;
  int? correctQuestion;
  int? incorrectQuestion;
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
  dynamic userRank;

  ExamData(
      {this.id,
        this.categoryId,
        this.editorialId,
        this.title,
        this.image,
        this.mark,
        this.totalMarks,
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
        this.completed,this.userRank});

  ExamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    editorialId = json['editorial_id'];
    title = json['title'];
    image = json['image'];
    mark = json['mark'];
    totalMarks = json['total_marks'];
    negativeMark = json['negative_mark'];
    type = json['type'];
    isDailyQuiz = json['is_daily_quiz'];
    duration = json['duration'];
    instruction = json['instruction'];
    totalQuestions = json['total_questions'];
    correctQuestion = json['correct_question'];
    incorrectQuestion = json['incorrect_question'];
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
    userRank = json['user_rank'] != null
        ? new UserRank.fromJson(json['user_rank'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['editorial_id'] = this.editorialId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['mark'] = this.mark;
    data['total_marks'] = this.totalMarks;
    data['negative_mark'] = this.negativeMark;
    data['type'] = this.type;
    data['is_daily_quiz'] = this.isDailyQuiz;
    data['duration'] = this.duration;
    data['instruction'] = this.instruction;
    data['correct_question'] = this.correctQuestion;
    data['incorrect_question'] = this.incorrectQuestion;
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
    if (this.userRank != null) {
      data['user_rank'] = this.userRank!.toJson();
    }
    return data;
  }
}

class UserRank {
  int? rank;
  int? totalStudents;

  UserRank({this.rank, this.totalStudents});

  UserRank.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    totalStudents = json['total_students'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['total_students'] = this.totalStudents;
    return data;
  }
}*/
