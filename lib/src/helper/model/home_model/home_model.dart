class HomeApiModel {
  bool? result;
  String? message;
  HomeDetails? homeDetails;

  HomeApiModel({this.result, this.message, this.homeDetails});

  HomeApiModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    homeDetails = json['home_details'] != null
        ? new HomeDetails.fromJson(json['home_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.homeDetails != null) {
      data['home_details'] = this.homeDetails!.toJson();
    }
    return data;
  }
}

class HomeDetails {
  List<Banners>? banners;
  List<Editorials>? editorials;
  List<Quizz>? quizz;
  int? mentors;
  String? successRate;
  int? students;
  List<Achievers>? achievers;
  bool? isSubscribed;

  HomeDetails(
      {this.banners,
        this.editorials,
        this.quizz,
        this.mentors,
        this.successRate,
        this.students,
        this.achievers,
        this.isSubscribed});

  HomeDetails.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['editorials'] != null) {
      editorials = <Editorials>[];
      json['editorials'].forEach((v) {
        editorials!.add(new Editorials.fromJson(v));
      });
    }
    if (json['quizz'] != null) {
      quizz = <Quizz>[];
      json['quizz'].forEach((v) {
        quizz!.add(new Quizz.fromJson(v));
      });
    }
    mentors = json['mentors'];
    successRate = json['success_rate'];
    students = json['students'];
    if (json['achievers'] != null) {
      achievers = <Achievers>[];
      json['achievers'].forEach((v) {
        achievers!.add(new Achievers.fromJson(v));
      });
    }
    isSubscribed = json['is_subscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.editorials != null) {
      data['editorials'] = this.editorials!.map((v) => v.toJson()).toList();
    }
    if (this.quizz != null) {
      data['quizz'] = this.quizz!.map((v) => v.toJson()).toList();
    }
    data['mentors'] = this.mentors;
    data['success_rate'] = this.successRate;
    data['students'] = this.students;
    if (this.achievers != null) {
      data['achievers'] = this.achievers!.map((v) => v.toJson()).toList();
    }
    data['is_subscribed'] = this.isSubscribed;
    return data;
  }
}

class Banners {
  int? id;
  String? banner;
  Null? linkType;
  Null? link;
  Null? timerText;
  Null? timerEndOn;

  Banners(
      {this.id,
        this.banner,
        this.linkType,
        this.link,
        this.timerText,
        this.timerEndOn});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    banner = json['banner'];
    linkType = json['link_type'];
    link = json['link'];
    timerText = json['timer_text'];
    timerEndOn = json['timer_end_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['banner'] = this.banner;
    data['link_type'] = this.linkType;
    data['link'] = this.link;
    data['timer_text'] = this.timerText;
    data['timer_end_on'] = this.timerEndOn;
    return data;
  }
}

class Editorials {
  int? id;
  String? title;
  String? date;
  String? description;
  String? type;
  String? author;
  int? quizAvailable;
  Null? file;
  String? image;

  Editorials(
      {this.id,
        this.title,
        this.date,
        this.description,
        this.type,
        this.author,
        this.quizAvailable,
        this.file,
        this.image});

  Editorials.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    description = json['description'];
    type = json['type'];
    author = json['author'];
    quizAvailable = json['quiz_available'];
    file = json['file'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['description'] = this.description;
    data['type'] = this.type;
    data['author'] = this.author;
    data['quiz_available'] = this.quizAvailable;
    data['file'] = this.file;
    data['image'] = this.image;
    return data;
  }
}

class Quizz {
  int? id;
  String? title;
  String? category_name;
  String? image;
  String? publishAt;
  int? totalQuestion;
  Null? startDate;
  Null? endDate;
  Null? startTime;
  Null? endTime;
  String? duration;
  bool? attempted;
  int? completed;

  Quizz(
      {this.id,
        this.title,
        this.image,
        this.publishAt,
        this.startDate,
        this.endDate,
        this.totalQuestion,
        this.startTime,
        this.category_name,
        this.endTime,
        this.duration,
        this.attempted,
        this.completed});

  Quizz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    publishAt = json['publish_at'];
    startDate = json['start_date'];
    totalQuestion = json['total_questions'];
    category_name = json['category_name'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
    attempted = json['attempted'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['publish_at'] = this.publishAt;
    data['total_questions'] = this.totalQuestion;
    data['start_date'] = this.startDate;
    data['category_name'] = this.category_name;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['duration'] = this.duration;
    data['attempted'] = this.attempted;
    data['completed'] = this.completed;
    return data;
  }
}

class Achievers {
  int? id;
  String? userName;
  String? userRank;
  String? exam_name;
  String? image;
  String? description;

  Achievers(
      {this.id, this.userName,this.exam_name, this.userRank, this.image, this.description});

  Achievers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    userRank = json['user_rank'];
    exam_name = json['exam_name'];
    image = json['image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['user_rank'] = this.userRank;
    data['exam_name'] = this.exam_name;
    data['image'] = this.image;
    data['description'] = this.description;
    return data;
  }
}
