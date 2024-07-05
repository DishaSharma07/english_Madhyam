class MeaningList {
  bool? result;
  String? message;
  List<Editorials>? editorials;

  MeaningList({this.result, this.message, this.editorials});

  MeaningList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['editorials'] != null) {
      editorials = <Editorials>[];
      json['editorials'].forEach((v) {
        editorials!.add(new Editorials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.editorials != null) {
      data['editorials'] = this.editorials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Editorials {
  String title="SAVE";
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