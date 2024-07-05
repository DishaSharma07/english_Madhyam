class QuestionDataModel {
  bool? result;
  List<QuestionData>? questionsList;

  QuestionDataModel({this.result, this.questionsList});

  QuestionDataModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['questions_list'] != null) {
      questionsList = <QuestionData>[];
      json['questions_list'].forEach((v) {
        questionsList!.add(new QuestionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.questionsList != null) {
      data['questions_list'] =
          this.questionsList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class QuestionData {
  int? id;
  String? examId;
  String? eQuestion;
  int? chapter;
  int? topic;
  int? marks;
  String? createdAt;
  String? updatedAt;
  int? savedQId;
  List<Options>? options;
  Solutions? solutions;

  QuestionData(
      {this.id,
        this.examId,
        this.eQuestion,
        this.chapter,
        this.topic,
        this.marks,
        this.createdAt,
        this.updatedAt,
        this.savedQId});

  QuestionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    examId = json['exam_id'];
    eQuestion = json['e_question'];
    chapter = json['chapter'];
    topic = json['topic'];
    marks = json['marks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    savedQId = json['saved_q_id'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    solutions = json['solution'] != null
        ? new Solutions.fromJson(json['solution'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['exam_id'] = this.examId;
    data['e_question'] = this.eQuestion;
    data['chapter'] = this.chapter;
    data['topic'] = this.topic;
    data['marks'] = this.marks;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['saved_q_id'] = this.savedQId;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.solutions != null) {
      data['solution'] = this.solutions!.toJson();
    }

    return data;
  }
}

class Options {
  int? id;
  int? qId;
  dynamic optionH;
  String? optionE;
  int? correct;
  dynamic image;
  int? del;
  String? createdAt;
  String? updatedAt;
  int? checked;

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
        this.checked});

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
    return data;
  }
}

class Solutions {
  int? id;
  int? qId;
  String? eSolutions;
  int? del;
  String? createdAt;
  String? updatedAt;

  Solutions(
      {this.id,
        this.qId,
        this.eSolutions,
        this.del,
        this.createdAt,
        this.updatedAt});

  Solutions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qId = json['q_id'];
    eSolutions = json['e_solutions'];
    del = json['del'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['q_id'] = this.qId;
    data['e_solutions'] = this.eSolutions;
    data['del'] = this.del;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
