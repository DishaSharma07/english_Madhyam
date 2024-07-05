class EditorialDetailsModel {
  bool? result;
  String? message;
  EditorialDetails? editorialDetails;

  EditorialDetailsModel({this.result, this.message, this.editorialDetails});

  EditorialDetailsModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    editorialDetails = json['editorial_details'] != null
        ? new EditorialDetails.fromJson(json['editorial_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.editorialDetails != null) {
      data['editorial_details'] = this.editorialDetails!.toJson();
    }
    return data;
  }
}

class EditorialDetails {
  int? id;
  String? title;
  String? description;
  String? type;
  int? quizAvailable;
  String? isSubscription;
  String? image;
  int? examId;
  int? isAttempt;
  int? isCompleted;
  int? isPause;
  List<Pdf>? pdf;
  List<Audio>? audio;

  EditorialDetails(
      {this.id,
        this.title,
        this.description,
        this.type,
        this.quizAvailable,
        this.isSubscription,
        this.image,
        this.examId,
        this.isAttempt,
        this.isCompleted,
        this.isPause,
        this.pdf,
        this.audio});

  EditorialDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    quizAvailable = json['quiz_available'];
    isSubscription = json['is_subscription'];
    image = json['image'];
    examId = json['exam_id'];
    isAttempt = json['is_attempt'];
    isCompleted = json['is_completed'];
    isPause = json['is_pause'];
    if (json['pdf'] != null) {
      pdf = <Pdf>[];
      json['pdf'].forEach((v) {
        pdf!.add(new Pdf.fromJson(v));
      });
    }
    if (json['audio'] != null) {
      audio = <Audio>[];
      json['audio'].forEach((v) {
        audio!.add(new Audio.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['type'] = this.type;
    data['quiz_available'] = this.quizAvailable;
    data['is_subscription'] = this.isSubscription;
    data['image'] = this.image;
    data['exam_id'] = this.examId;
    data['is_attempt'] = this.isAttempt;
    data['is_completed'] = this.isCompleted;
    data['is_pause'] = this.isPause;
    if (this.pdf != null) {
      data['pdf'] = this.pdf!.map((v) => v.toJson()).toList();
    }
    if (this.audio != null) {
      data['audio'] = this.audio!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pdf {
  int? id;
  int? editorialId;
  int? type;
  String? file;

  Pdf({this.id, this.editorialId, this.type, this.file});

  Pdf.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    editorialId = json['editorial_id'];
    type = json['type'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['editorial_id'] = this.editorialId;
    data['type'] = this.type;
    data['file'] = this.file;
    return data;
  }
}
class Audio {
  int? id;
  int? editorialId;
  int? type;
  String? file;

  Audio({this.id, this.editorialId, this.type, this.file});

  Audio.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    editorialId = json['editorial_id'];
    type = json['type'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['editorial_id'] = this.editorialId;
    data['type'] = this.type;
    data['file'] = this.file;
    return data;
  }
}



