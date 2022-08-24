class CouponList {
  bool? result;
  String? message;
  List<CouponsList>? couponsList;

  CouponList({this.result, this.message, this.couponsList});

  CouponList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['coupons_list'] != null) {
      couponsList = <CouponsList>[];
      json['coupons_list'].forEach((v) {
        couponsList!.add(new CouponsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.couponsList != null) {
      data['coupons_list'] = this.couponsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponsList {
  int? id;
  String? title;
  String? couponCode;
  String? couponType;
  String? couponValue;
  String? minCartValue;
  String? maxDiscount;
  int? allowedUserTimes;
  String? description;
  String? terms;
  String? startDate;
  String? endDate;
  String? noOfUsage;
  String? publishAtDate;
  String? publishAtTime;
  int? status;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;

  CouponsList(
      {this.id,
        this.title,
        this.couponCode,
        this.couponType,
        this.couponValue,
        this.minCartValue,
        this.maxDiscount,
        this.allowedUserTimes,
        this.description,
        this.terms,
        this.startDate,
        this.endDate,
        this.noOfUsage,
        this.publishAtDate,
        this.publishAtTime,
        this.status,
        this.isDeleted,
        this.createdAt,
        this.updatedAt});

  CouponsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    couponCode = json['coupon_code'];
    couponType = json['coupon_type'];
    couponValue = json['coupon_value'];
    minCartValue = json['min_cart_value'];
    maxDiscount = json['max_discount'];
    allowedUserTimes = json['allowed_user_times'];
    description = json['description'];
    terms = json['terms'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    noOfUsage = json['no_of_usage'];
    publishAtDate = json['publish_at_date'];
    publishAtTime = json['publish_at_time'];
    status = json['status'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['coupon_code'] = this.couponCode;
    data['coupon_type'] = this.couponType;
    data['coupon_value'] = this.couponValue;
    data['min_cart_value'] = this.minCartValue;
    data['max_discount'] = this.maxDiscount;
    data['allowed_user_times'] = this.allowedUserTimes;
    data['description'] = this.description;
    data['terms'] = this.terms;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['no_of_usage'] = this.noOfUsage;
    data['publish_at_date'] = this.publishAtDate;
    data['publish_at_time'] = this.publishAtTime;
    data['status'] = this.status;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


