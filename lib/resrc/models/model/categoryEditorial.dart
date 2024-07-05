class EditorialCat {
  bool? result;
  String? message;
  Editorial? editorials;

  EditorialCat({this.result, this.message, this.editorials});

  EditorialCat.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    editorials = json['editorials'] != null
        ? new Editorial.fromJson(json['editorials'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.editorials != null) {
      data['editorials'] = this.editorials!.toJson();
    }
    return data;
  }
}

class Editorial {
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

  Editorial(
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

  Editorial.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? type;
  String? author;
  int? quizAvailable;
  String? date;
  String? image;
  int? faqs;

  Data(
      {this.id,
        this.title,
        this.type,
        this.author,
        this.quizAvailable,
        this.date,
        this.image,
        this.faqs});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    author = json['author'];
    quizAvailable = json['quiz_available'];
    date = json['date'];
    image = json['image'];
    faqs = json['faqs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['author'] = this.author;
    data['quiz_available'] = this.quizAvailable;
    data['date'] = this.date;
    data['image'] = this.image;
    data['faqs'] = this.faqs;
    return data;
  }
}