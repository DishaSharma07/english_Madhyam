class GetAllQuizCategory {
  String? data;
  String? message;
  int? total;
  List<PracticeQuizData>? childCategory;

  GetAllQuizCategory({this.data, this.message, this.childCategory,this.total});

  GetAllQuizCategory.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    total = json['total'];
    message = json['message'];
    if (json['parent_categories'] != null) {
      childCategory = <PracticeQuizData>[];
      json['parent_categories'].forEach((v) {
        childCategory!.add(new PracticeQuizData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['total'] = this.total;
    data['message'] = this.message;
    if (this.childCategory != null) {
      data['parent_categories'] = this.childCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PracticeQuizData {
  int? id;
  String? name;
  String? image;
  int? isPrevious;

  PracticeQuizData({this.id, this.name, this.image,this.isPrevious});

  PracticeQuizData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    isPrevious = json['is_previous'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['is_previous'] = this.isPrevious;
    return data;
  }
}