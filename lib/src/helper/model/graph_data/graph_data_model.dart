class GraphData {
  String? result;
  String? message;
  Content? content;

  GraphData({this.result, this.message, this.content});

  GraphData.fromJson(Map<String, dynamic> json) {
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
  int? totalMarks;
  double? marks;
  int? time;
  int? totalQuestion;
  int? correctQuestion;
  int? incorrectQuestion;
  int? skipQuestion;
  int? rank;
  int? totalStudents;

  Content(
      {this.totalMarks,
        this.marks,
        this.time,
        this.totalQuestion,
        this.correctQuestion,
        this.incorrectQuestion,
        this.skipQuestion,
        this.rank,
        this.totalStudents});

  Content.fromJson(Map<String, dynamic> json) {
    totalMarks = json['total_marks'];
    marks = double.parse(json['marks'].toString());
    time = int.parse(json['time'].toString());
    totalQuestion = json['total_question'];
    correctQuestion = json['correct_question'];
    incorrectQuestion = json['incorrect_question'];
    skipQuestion = json['skip_question'];
    rank = json['rank'];
    totalStudents = json['total_students'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_marks'] = this.totalMarks;
    data['marks'] = this.marks;
    data['time'] = this.time;
    data['total_question'] = this.totalQuestion;
    data['correct_question'] = this.correctQuestion;
    data['incorrect_question'] = this.incorrectQuestion;
    data['skip_question'] = this.skipQuestion;
    data['rank'] = this.rank;
    data['total_students'] = this.totalStudents;
    return data;
  }
}


