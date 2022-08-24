class YoutubeListModel {
  bool? result;
  String? message;
  int? total;
  List<Videos>? videos;

  YoutubeListModel({this.result,this.total, this.message, this.videos});

  YoutubeListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    total = json['total'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  int? id;
  String? title;
  String? videoId;
  String? publishAtDate;
  String? categoryName;

  Videos(
      {this.id,
        this.title,
        this.videoId,
        this.publishAtDate,
        this.categoryName});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    videoId = json['video_id'];
    publishAtDate = json['publish_at_date'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['video_id'] = this.videoId;
    data['publish_at_date'] = this.publishAtDate;
    data['category_name'] = this.categoryName;
    return data;
  }
}


