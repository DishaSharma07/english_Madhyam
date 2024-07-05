class WordDataModel {
  bool? result;
  String? message;
  List<WordData>? wordsList;

  WordDataModel({this.result, this.message, this.wordsList});

  WordDataModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['words_list'] != null) {
      wordsList = <WordData>[];
      json['words_list'].forEach((v) {
        wordsList!.add(new WordData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.wordsList != null) {
      data['words_list'] =
          this.wordsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WordData {
  int? vocabId;
  dynamic meaning;
  String? word;

  WordData({this.vocabId, this.meaning, this.word});

  WordData.fromJson(Map<String, dynamic> json) {
    vocabId = json['vocab_id'];
    meaning = json['meaning'];
    word = json['word'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vocab_id'] = this.vocabId;
    data['meaning'] = this.meaning;
    data['word'] = this.word;
    return data;
  }
}
