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
  int? isParagraph;
  String? paragraphQuestion;
  int? savedQId;
  List<Options>? options;
  Solution? solution;

  QuestionData(
      {this.id,
        this.examId,
        this.eQuestion,
        this.isParagraph,
        this.paragraphQuestion,
        this.savedQId,
        this.options,
        this.solution});

  QuestionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    examId = json['exam_id'];
    eQuestion = json['e_question'];
    isParagraph = json['is_paragraph'];
    paragraphQuestion = json['paragraph_question'];
    savedQId = json['saved_q_id'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    solution = json['solution'] != null
        ? new Solution.fromJson(json['solution'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['exam_id'] = this.examId;
    data['e_question'] = this.eQuestion;
    data['is_paragraph'] = this.isParagraph;
    data['paragraph_question'] = this.paragraphQuestion;
    data['saved_q_id'] = this.savedQId;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.solution != null) {
      data['solution'] = this.solution!.toJson();
    }
    return data;
  }
}

class Options {
  String? optionE;
  int? correct;

  Options({this.optionE, this.correct});

  Options.fromJson(Map<String, dynamic> json) {
    optionE = json['option_e'];
    correct = json['correct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_e'] = this.optionE;
    data['correct'] = this.correct;
    return data;
  }
}

class Solution {
  String? eSolutions;

  Solution({this.eSolutions});

  Solution.fromJson(Map<String, dynamic> json) {
    eSolutions = json['e_solutions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['e_solutions'] = this.eSolutions;
    return data;
  }
}
