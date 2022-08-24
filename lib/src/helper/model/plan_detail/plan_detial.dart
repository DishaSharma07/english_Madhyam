class PlanDetailModel {
  bool? result;
  String? message;
  List<PlanList>? list;

  PlanDetailModel({this.result, this.message, this.list});

  PlanDetailModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['list'] != null) {
      list = <PlanList>[];
      json['list'].forEach((v) {
        list!.add(new PlanList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanList {
  int? id;
  String? title;
  String? description;
  int? fee;
  double? perDay;
  int? mrp;
  int? duration;
  int? discount;

  PlanList(
      {this.id,
        this.title,
        this.description,
        this.fee,
        this.perDay,
        this.mrp,
        this.duration,
        this.discount});

  PlanList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    fee = json['fee'];
    mrp = json['mrp'];
    perDay = json['per_day_amt'];
    duration = json['duration'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['fee'] = this.fee;
    data['per_day_amt'] = this.perDay;
    data['mrp'] = this.mrp;
    data['duration'] = this.duration;
    data['discount'] = this.discount;
    return data;
  }
}