class MeaningModel {
  bool? result;
  Vocab? vocab;
  String ?word;

  MeaningModel({this.result, this.vocab,this.word});

  MeaningModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    vocab = json['vocab'] != null ? new Vocab.fromJson(json['vocab']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.vocab != null) {
      data['vocab'] = this.vocab!.toJson();
    }
    return data;
  }
}

class Vocab {
  String? meaning;

  Vocab({this.meaning});

  Vocab.fromJson(Map<String, dynamic> json) {
    meaning = json['meaning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meaning'] = this.meaning;
    return data;
  }
}