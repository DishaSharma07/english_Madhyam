class VideoCategoriesModel {
  String? data;
  String? message;
  Categories? categories;
  int? total;

  VideoCategoriesModel({this.data, this.message, this.categories, this.total});

  VideoCategoriesModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    categories = json['categories'] != null
        ? new Categories.fromJson(json['categories'])
        : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    if (this.categories != null) {
      data['categories'] = this.categories!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Categories {
  dynamic currentPage;
  List<VideoData>? data;
  String? firstPageUrl;
  dynamic from;
  dynamic lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  Categories(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Categories.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <VideoData>[];
      json['data'].forEach((v) {
        data!.add(new VideoData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class VideoData {
  int? id;
  String? name;
  String? image;
  int? type;
  int? videoCount;

  VideoData({this.id, this.name, this.image, this.type, this.videoCount});

  VideoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    type = json['type'];
    videoCount = json['video_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['type'] = this.type;
    data['video_count'] = this.videoCount;
    return data;
  }
}