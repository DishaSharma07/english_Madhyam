class PdfList {
  bool? result;
  String? message;
  List<Pdfs>? pdfs;

  PdfList({this.result, this.message, this.pdfs});

  PdfList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['pdfs'] != null) {
      pdfs = <Pdfs>[];
      json['pdfs'].forEach((v) {
        pdfs!.add(new Pdfs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.pdfs != null) {
      data['pdfs'] = this.pdfs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pdfs {
  int? id;
  String? title;
  int? type;
  String? file;
  String? publishAt;

  Pdfs({this.id, this.title, this.type, this.file, this.publishAt});

  Pdfs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    file = json['file'];
    publishAt = json['publish_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['file'] = this.file;
    data['publish_at'] = this.publishAt;
    return data;
  }
}