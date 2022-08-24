class PurchaseHistoryModel {
  String? result;
  String? message;
  List<PurchaseHistory>? purchaseHistory;

  PurchaseHistoryModel({this.result, this.message, this.purchaseHistory});

  PurchaseHistoryModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['purchase_history'] != null) {
      purchaseHistory = <PurchaseHistory>[];
      json['purchase_history'].forEach((v) {
        purchaseHistory!.add(new PurchaseHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.purchaseHistory != null) {
      data['purchase_history'] =
          this.purchaseHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PurchaseHistory {
  int? planId;
  String? startDate;
  String? endDate;
  int? fee;
  int? originalPrice;
  String? couponCode;
  int? discount;
  String? txnNo;
  String? orderId;
  String? planTitle;
  int? planDuration;

  PurchaseHistory(
      {this.planId,
        this.startDate,
        this.endDate,
        this.fee,
        this.originalPrice,
        this.couponCode,
        this.discount,
        this.txnNo,
        this.orderId,
        this.planTitle,
        this.planDuration});

  PurchaseHistory.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    fee = json['fee'];
    originalPrice = json['original_price'];
    couponCode = json['coupon_code'];
    discount = json['discount'];
    txnNo = json['txn_no'];
    orderId = json['order_id'];
    planTitle = json['plan_title'];
    planDuration = json['plan_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_id'] = this.planId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['fee'] = this.fee;
    data['original_price'] = this.originalPrice;
    data['coupon_code'] = this.couponCode;
    data['discount'] = this.discount;
    data['txn_no'] = this.txnNo;
    data['order_id'] = this.orderId;
    data['plan_title'] = this.planTitle;
    data['plan_duration'] = this.planDuration;
    return data;
  }
}