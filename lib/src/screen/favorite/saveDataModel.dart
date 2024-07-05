class SaveDataModel {
  bool? result;
  String? message;

  SaveDataModel({this.result, this.message});

  SaveDataModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    return data;
  }
}

class Editorials {
  String? word;
  String? meaning;
  int? id;

  Editorials({this.word, this.meaning, this.id});

  Editorials.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    meaning = json['meaning'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['meaning'] = this.meaning;
    data['id'] = this.id;
    return data;
  }
}