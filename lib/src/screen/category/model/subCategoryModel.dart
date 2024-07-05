class SubCategoryModel {
  String? data;
  String? message;
  List<SubCategories>? subCategories;
  int? total;

  SubCategoryModel({this.data, this.message, this.subCategories, this.total});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    if (json['sub_categories'] != null) {
      subCategories = <SubCategories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(new SubCategories.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class SubCategories {
  int? id;
  String? name;
  String? image;

  SubCategories({this.id, this.name, this.image});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
