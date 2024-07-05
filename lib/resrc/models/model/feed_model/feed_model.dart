class FeedModel {
  bool? result;
  String? message;
  Data? data;

  FeedModel({this.result, this.message, this.data});

  FeedModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  WordOfDay? wordOfDay;
List<Dataum>?phrase;
  Data({this.wordOfDay,this.phrase});

  Data.fromJson(Map<String, dynamic> json) {
    wordOfDay =json.containsKey('word_of_day') ?json['word_of_day'] != null
        ? new WordOfDay.fromJson(json['word_of_day'])
        : null:null;
    if (json.containsKey('phrase')&&json['phrase'] != null) {
      phrase = <Dataum>[];
      json['phrase'].forEach((v) {
        phrase!.add(new Dataum.fromJson(v));
      });
  }}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wordOfDay != null) {
      data['word_of_day'] = this.wordOfDay!.toJson();
    }
    return data;
  }
}

class WordOfDay {
  int? currentPage;
  List<Dataum>? data;
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

  WordOfDay(
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

  WordOfDay.fromJson(Map<String, dynamic> json) {
    currentPage = json.containsKey('current_page')?json['current_page']:null;
    if (json['data'] != null) {
      data = <Dataum>[];
      json['data'].forEach((v) {
        data!.add(new Dataum.fromJson(v));
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

class Dataum {
  int? id;
  String? word;
  String? meaning;
  String? synonyms;
  String? antonyms;
  String? example;
  String? image;
  String? date;

  Dataum(
      {this.id,
        this.word,
        this.meaning,
        this.synonyms,
        this.antonyms,
        this.example,
        this.image,
        this.date});

  Dataum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    word = json['word'];
    meaning = json['meaning'];
    synonyms = json.containsKey('synonyms')?json['synonyms']:null;
    antonyms =  json.containsKey('antonyms')?json['antonyms']:null;
    example = json.containsKey('example')?json['example']:null;
    image = json['image'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['word'] = this.word;
    data['meaning'] = this.meaning;
    data['synonyms'] = this.synonyms;
    data['antonyms'] = this.antonyms;
    data['example'] = this.example;
    data['image'] = this.image;
    data['date'] = this.date;
    return data;
  }
}