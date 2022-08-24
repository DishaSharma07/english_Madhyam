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
  List<WordOfDay>? wordOfDay;
  List<Phrase>? phrase;


  Data({this.wordOfDay,this.phrase});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['word_of_day'] != null) {
      wordOfDay = <WordOfDay>[];
      json['word_of_day'].forEach((v) {
        wordOfDay!.add( WordOfDay.fromJson(v));
      });
    }
   if (json['phrase'] != null) {
      phrase = <Phrase>[];
      json['phrase'].forEach((v) {
        phrase!.add(new Phrase.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wordOfDay != null) {
      data['word_of_day'] = this.wordOfDay!.map((v) => v.toJson()).toList();
    }
    if (this.phrase != null) {
      data['phrase'] = this.phrase!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




class WordOfDay {
  int? id;
  String? word;
  String? meaning;
  String? synonyms;
  String? antonyms;
  String? example;
  String? image;
  String? date;

  WordOfDay(
      {this.id,
        this.word,
        this.meaning,
        this.synonyms,
        this.antonyms,
        this.example,
        this.image,
        this.date});

  WordOfDay.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    word = json['word'];
    meaning = json['meaning'];
    synonyms = json['synonyms'];
    antonyms = json['antonyms'];
    example = json['example'];
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
class Phrase {
  int? id;
  String? word;
  String? meaning;
  String? date;
  String? image;

  Phrase({this.id, this.word, this.meaning, this.date, this.image});

  Phrase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    word = json['word'];
    meaning = json['meaning'];
    date = json['date'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['word'] = this.word;
    data['meaning'] = this.meaning;
    data['date'] = this.date;
    data['image'] = this.image;
    return data;
  }
}