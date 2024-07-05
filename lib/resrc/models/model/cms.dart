class CMSPAGES {
  bool? result;
  String? message;
  CmsPages? cmsPages;

  CMSPAGES({this.result, this.message, this.cmsPages});

  CMSPAGES.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    cmsPages = json['cms_pages'] != null
        ? new CmsPages.fromJson(json['cms_pages'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.cmsPages != null) {
      data['cms_pages'] = this.cmsPages!.toJson();
    }
    return data;
  }
}

class CmsPages {
  CmsPagess? cmsPages;
  List<Faqs>? faqs;

  CmsPages({this.cmsPages, this.faqs});

  CmsPages.fromJson(Map<String, dynamic> json) {
    cmsPages = json['cms_pages'] != null
        ? new CmsPagess.fromJson(json['cms_pages'])
        : null;
    if (json['faqs'] != null) {
      faqs = <Faqs>[];
      json['faqs'].forEach((v) {
        faqs!.add(new Faqs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cmsPages != null) {
      data['cms_pages'] = this.cmsPages!.toJson();
    }
    if (this.faqs != null) {
      data['faqs'] = this.faqs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CmsPagess {
  int? id;
  int? referralAmount;
  String? privacy;
  String? terms;
  String? aboutUs;
  String? phoneNumber;
  String? facebookId;
  String? instaId;
  String? telegramId;
  String? twitterId;
  String? youtubeId;
  String? emailId;
  String? helpFeed;
  String? createdAt;
  String? updatedAt;

  CmsPagess(
      {this.id,
        this.referralAmount,
        this.privacy,
        this.terms,
        this.aboutUs,
        this.facebookId,
        this.phoneNumber,
        this.instaId,
        this.telegramId,
        this.twitterId,
        this.youtubeId,
        this.emailId,
        this.helpFeed,
        this.createdAt,
        this.updatedAt});

  CmsPagess.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referralAmount = json['referral_amount'];
    privacy = json['privacy'];
    terms = json['terms'];
    aboutUs = json['about_us'];
    facebookId = json['facebook_id'];
    phoneNumber = json['phone'];
    instaId = json['insta_id'];
    telegramId = json['telegram_id'];
    twitterId = json['twitter_id'];
    youtubeId = json['youtube_id'];
    emailId = json['email_id'];
    helpFeed = json['help_feed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['referral_amount'] = this.referralAmount;
    data['privacy'] = this.privacy;
    data['terms'] = this.terms;
    data['about_us'] = this.aboutUs;
    data['phone'] = this.phoneNumber;
    data['facebook_id'] = this.facebookId;
    data['insta_id'] = this.instaId;
    data['telegram_id'] = this.telegramId;
    data['twitter_id'] = this.twitterId;
    data['youtube_id'] = this.youtubeId;
    data['email_id'] = this.emailId;
    data['help_feed'] = this.helpFeed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Faqs {
  int? id;
  String? question;
  String? answer;

  Faqs({this.id, this.question, this.answer});

  Faqs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}