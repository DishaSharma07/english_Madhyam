// import '../../../helper/model/feed_model/feed_model.dart';
//
// class EventFeedModel {
//   bool? result;
//   String? message;
//   Data? data;
//
//   EventFeedModel({this.result, this.message, this.data});
//
//   EventFeedModel.fromJson(Map<String, dynamic> json) {
//     result = json['result'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['result'] = this.result;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   EventData? wordOfDay;
//   Data({this.wordOfDay});
//   Data.fromJson(Map<String, dynamic> json) {
//     wordOfDay = json['word_of_day'] != null
//         ? new EventData.fromJson(json['word_of_day'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.wordOfDay != null) {
//       data['word_of_day'] = this.wordOfDay!.toJson();
//     }
//     return data;
//   }
// }
//
// class EventData {
//   int? currentPage;
//   List<FeedDataModel>? eventData;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   String? nextPageUrl;
//   String? path;
//   dynamic perPage;
//   dynamic prevPageUrl;
//   int? to;
//   int? total;
//
//   EventData(
//       {this.currentPage,
//         this.eventData,
//         this.firstPageUrl,
//         this.from,
//         this.lastPage,
//         this.lastPageUrl,
//         this.nextPageUrl,
//         this.path,
//         this.perPage,
//         this.prevPageUrl,
//         this.to,
//         this.total});
//
//   EventData.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     if (json['data'] != null) {
//       eventData = <FeedDataModel>[];
//       json['data'].forEach((v) {
//         eventData!.add(new FeedDataModel.fromJson(v));
//       });
//     }
//     firstPageUrl = json['first_page_url'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     lastPageUrl = json['last_page_url'];
//     nextPageUrl = json['next_page_url'];
//     path = json['path'];
//     perPage = json['per_page'];
//     prevPageUrl = json['prev_page_url'];
//     to = json['to'];
//     total = json['total'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['current_page'] = this.currentPage;
//     if (this.eventData != null) {
//       data['data'] = this.eventData!.map((v) => v.toJson()).toList();
//     }
//     data['first_page_url'] = this.firstPageUrl;
//     data['from'] = this.from;
//     data['last_page'] = this.lastPage;
//     data['last_page_url'] = this.lastPageUrl;
//     data['next_page_url'] = this.nextPageUrl;
//     data['path'] = this.path;
//     data['per_page'] = this.perPage;
//     data['prev_page_url'] = this.prevPageUrl;
//     data['to'] = this.to;
//     data['total'] = this.total;
//     return data;
//   }
// }
//
