class CreatePaymentModel {
  bool? result;
  String? message;
  PaymentDetails? paymentDetails;

  CreatePaymentModel({this.result, this.message, this.paymentDetails});

  CreatePaymentModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    paymentDetails = json['payment_details'] != null
        ? new PaymentDetails.fromJson(json['payment_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.paymentDetails != null) {
      data['payment_details'] = this.paymentDetails!.toJson();
    }
    return data;
  }
}

class PaymentDetails {
  int? userId;
  double? fee;
  String? originalPrice;
  String? paymentType;
  String? paymentCause;
  String? planId;
  String? orderId;
  String? updatedAt;
  String? createdAt;
  int? id;

  PaymentDetails(
      {this.userId,
        this.fee,
        this.originalPrice,
        this.paymentType,
        this.paymentCause,
        this.planId,
        this.orderId,
        this.updatedAt,
        this.createdAt,
        this.id});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fee = double.parse(json['fee'].toString());
    originalPrice = json['original_price'];
    paymentType = json['payment_type'];
    paymentCause = json['payment_cause'];
    planId = json['plan_id'];
    orderId = json['order_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['fee'] = this.fee;
    data['original_price'] = this.originalPrice;
    data['payment_type'] = this.paymentType;
    data['payment_cause'] = this.paymentCause;
    data['plan_id'] = this.planId;
    data['order_id'] = this.orderId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}