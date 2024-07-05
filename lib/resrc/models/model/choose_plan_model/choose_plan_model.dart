class ChoosePlanModel {
  String? data;
  String? message;
  List<MaterialChildData>? childCategories;

  ChoosePlanModel(
      {this.data, this.message, this.childCategories});

  ChoosePlanModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    if (json['parent_categories'] != null) {
      childCategories = <MaterialChildData>[];
      json['parent_categories'].forEach((v) {
        childCategories!.add(new MaterialChildData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    if (this.childCategories != null) {
      data['parent_categories'] = this.childCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MaterialChildData {
  int? id;
  String? name;
  String? image;
  int? type;

  MaterialChildData({this.id, this.name, this.image, this.type});

  MaterialChildData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['type'] = this.type;
    return data;
  }
}