class ProfileGet {
  String? result;
  String? message;
  User? user;

  ProfileGet({this.result, this.message, this.user});

  ProfileGet.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? username;
  String? email;
  Null? emailVerifiedAt;
  int? wallet;
  String? slug;
  int? loginEnabled;
  String? phone;
  String? image;
  String? dateOfBirth;
  int? stateId;
  int? cityId;
  int? referredBy;
  int? isDelete;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? isSubscription;
  SubscriptionDetails? subscriptionDetails;
  String? stateName;
  String? cityName;

  User(
      {this.id,
        this.name,
        this.username,
        this.email,
        this.emailVerifiedAt,
        this.wallet,
        this.slug,
        this.loginEnabled,
        this.phone,
        this.image,
        this.dateOfBirth,
        this.stateId,
        this.cityId,
        this.referredBy,
        this.isDelete,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.isSubscription,
        this.subscriptionDetails,
        this.stateName,
        this.cityName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    wallet = json['wallet'];
    slug = json['slug'];
    loginEnabled = json['login_enabled'];
    phone = json['phone'];
    image = json['image'];
    dateOfBirth = json['date_of_birth'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    referredBy = json['referredBy'];
    isDelete = json['is_delete'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isSubscription = json['is_subscription'];
    subscriptionDetails = json['subscription_details'] != null
        ? new SubscriptionDetails.fromJson(json['subscription_details'])
        : null;
    stateName = json['state_name'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['wallet'] = this.wallet;
    data['slug'] = this.slug;
    data['login_enabled'] = this.loginEnabled;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['date_of_birth'] = this.dateOfBirth;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['referredBy'] = this.referredBy;
    data['is_delete'] = this.isDelete;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_subscription'] = this.isSubscription;
    if (this.subscriptionDetails != null) {
      data['subscription_details'] = this.subscriptionDetails!.toJson();
    }
    data['state_name'] = this.stateName;
    data['city_name'] = this.cityName;
    return data;
  }
}

class SubscriptionDetails {
  int? planId;
  String? startDate;
  String? endDate;
  int? fee;
  int? daysLeft;
  String? planTitle;
  int? planDuration;

  SubscriptionDetails(
      {this.planId,
        this.startDate,
        this.endDate,
        this.fee,
        this.daysLeft,
        this.planTitle,
        this.planDuration});

  SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    fee = json['fee'];
    daysLeft = json['days_left'];
    planTitle = json['plan_title'];
    planDuration = json['plan_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_id'] = this.planId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['fee'] = this.fee;
    data['days_left'] = this.daysLeft;
    data['plan_title'] = this.planTitle;
    data['plan_duration'] = this.planDuration;
    return data;
  }
}