class ParentCategoryModel {
  String? data;
  String? message;
  List<ParentCategories>? parentCategories;
  int? total;

  ParentCategoryModel(
      {this.data, this.message, this.parentCategories, this.total});

  ParentCategoryModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    if (json['parent_categories'] != null) {
      parentCategories = <ParentCategories>[];
      json['parent_categories'].forEach((v) {
        parentCategories!.add(new ParentCategories.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    if (this.parentCategories != null) {
      data['parent_categories'] =
          this.parentCategories!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ParentCategories {
  int? id;
  String? name;
  String? image;
  int ?ordering;

  ParentCategories({this.id, this.name, this.image,this.ordering});

  ParentCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    ordering=json.containsKey('ordering')?json['ordering']:null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
