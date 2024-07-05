class BirthDayModel {
  bool? result;
  String? message;
  BirthdayMsg? birthdayMsg;

  BirthDayModel({this.result, this.message, this.birthdayMsg});

  BirthDayModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    birthdayMsg = json['birthday_msg'] != null
        ? new BirthdayMsg.fromJson(json['birthday_msg'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.birthdayMsg != null) {
      data['birthday_msg'] = this.birthdayMsg!.toJson();
    }
    return data;
  }
}

class BirthdayMsg {
  String? messageTitle;
  String? name;
  String? message;

  BirthdayMsg({this.messageTitle, this.name, this.message});

  BirthdayMsg.fromJson(Map<String, dynamic> json) {
    messageTitle = json['message_title'];
    name = json['name'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_title'] = this.messageTitle;
    data['name'] = this.name;
    data['message'] = this.message;
    return data;
  }
}