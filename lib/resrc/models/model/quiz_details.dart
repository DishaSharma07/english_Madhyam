class ExamDetails {
  String? result;
  String? message;
  Content? content;

  ExamDetails({this.result, this.message, this.content});

  ExamDetails.fromJson(Map<String, dynamic> json) {
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
  dynamic startDate;
  dynamic endDate;
  dynamic startTime;
  dynamic endTime;
  String? timeLeft;
  int? examQuestionCount;
  List<ExamQuestion>? examQuestion;
  int? isAttempt;
  int? isCompeleted;
  int? isPause;

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
        this.timeLeft,
        this.examQuestionCount,
        this.examQuestion,
        this.isAttempt,
        this.isCompeleted,
        this.isPause});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    editorialId = json['editorial_id'];
    title = json['title'];
    image = json['image'];
    mark =double.parse( json['mark'].toString());
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
    timeLeft = json['time_left'];
    examQuestionCount = json['exam_question_count'];
    if (json['exam_question'] != null) {
      examQuestion = <ExamQuestion>[];
      json['exam_question'].forEach((v) {
        examQuestion!.add(new ExamQuestion.fromJson(v));
      });
    }
    isAttempt = json['is_attempt'];
    isCompeleted = json['is_compeleted'];
    isPause = json['is_pause'];
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
    data['time_left'] = this.timeLeft;
    data['exam_question_count'] = this.examQuestionCount;
    if (this.examQuestion != null) {
      data['exam_question'] =
          this.examQuestion!.map((v) => v.toJson()).toList();
    }
    data['is_attempt'] = this.isAttempt;
    data['is_compeleted'] = this.isCompeleted;
    data['is_pause'] = this.isPause;
    return data;
  }
}

class ExamQuestion {
  int? id;
  dynamic hQuestion;
  String? examId;
  String? eQuestion;
  dynamic image;
  dynamic subjectName;
  int? boards;
  int? classId;
  String? subject;
  int? chapter;
  int? topic;
  String? marks;
  String? createdAt;
  String? updatedAt;
  int? qId;
  int? isAttempt;
  int? isSelect;
  List<Options>? options;
  Solutions? solutions;
  int? guess;
  int? mark;
  int? ansType;
  String? selectedOptionId;
  int isREAttmpted=0;
  bool?reported=false;

  ExamQuestion(
      {this.id,
        this.hQuestion,
        this.examId,
        this.eQuestion,
        this.image,
        this.subjectName,
        this.boards,
        this.classId,
        this.subject,
        this.chapter,
        this.topic,
this.reported,
        this.marks,

        this.createdAt,
        this.updatedAt,
        this.qId,
        this.isAttempt,
        this.isSelect,
        this.options,
        this.solutions,
        this.guess,
        this.mark,
        this.ansType,required this.isREAttmpted});

  ExamQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hQuestion = json['h_question'];
    examId = json['exam_id'];
    eQuestion = json['e_question'];
    image = json['image'];
    subjectName = json['subject_name'];
    boards = json['boards'];
    classId = json['class_id'];
    subject = json['subject'];
    chapter = json['chapter'];
    topic = json['topic'];

    marks = json['marks'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    qId = json['q_id'];
    isAttempt = json['is_attempt'];
    isSelect = json['is_select'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    solutions = json['solutions'] != null
        ? new Solutions.fromJson(json['solutions'])
        : null;
    guess = json['guess'];
    mark = json['mark'];
    ansType = json['ansType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['h_question'] = this.hQuestion;
    data['exam_id'] = this.examId;
    data['e_question'] = this.eQuestion;
    data['image'] = this.image;
    data['subject_name'] = this.subjectName;
    data['boards'] = this.boards;
    data['class_id'] = this.classId;
    data['subject'] = this.subject;
    data['chapter'] = this.chapter;
    data['topic'] = this.topic;

    data['marks'] = this.marks;

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['q_id'] = this.qId;
    data['is_attempt'] = this.isAttempt;
    data['is_select'] = this.isSelect;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.solutions != null) {
      data['solutions'] = this.solutions!.toJson();
    }
    data['guess'] = this.guess;
    data['mark'] = this.mark;
    data['ansType'] = this.ansType;
    return data;
  }
}

class Options {
  int? id;
  int? qId;
  dynamic? optionH;
  String? optionE;
  int? correct;
  dynamic? image;
  int? del;
  String? createdAt;
  String? updatedAt;
  int? checked;
  int attempted=0;

  Options(
      {this.id,
        this.qId,
        this.optionH,
        this.optionE,
        this.correct,
        this.image,
        this.del,
        this.createdAt,
        this.updatedAt,
        this.checked,required this.attempted});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qId = json['q_id'];
    optionH = json['option_h'];
    optionE = json['option_e'];
    correct = json['correct'];
    image = json['image'];
    del = json['del'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['q_id'] = this.qId;
    data['option_h'] = this.optionH;
    data['option_e'] = this.optionE;
    data['correct'] = this.correct;
    data['image'] = this.image;
    data['del'] = this.del;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['checked'] = this.checked;
    data['attempted'] = this.attempted;
    return data;
  }
}

class Solutions {
  int? id;
  int? qId;
  String? eSolutions;
  Null? hSolutions;
  Null? image;
  Null? admittedBy;
  int? del;
  String? createdAt;
  String? updatedAt;

  Solutions(
      {this.id,
        this.qId,
        this.eSolutions,
        this.hSolutions,
        this.image,
        this.admittedBy,
        this.del,
        this.createdAt,
        this.updatedAt});

  Solutions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qId = json['q_id'];
    eSolutions = json['e_solutions'];
    hSolutions = json['h_solutions'];
    image = json['image'];
    admittedBy = json['admitted_by'];
    del = json['del'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['q_id'] = this.qId;
    data['e_solutions'] = this.eSolutions;
    data['h_solutions'] = this.hSolutions;
    data['image'] = this.image;
    data['admitted_by'] = this.admittedBy;
    data['del'] = this.del;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}