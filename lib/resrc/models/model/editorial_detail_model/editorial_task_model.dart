import 'package:flutter_downloader/flutter_downloader.dart';

class TaskInfo {
  final String? name;
  final String? link;
  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status;

  TaskInfo({this.name, this.link});
}

class EditorialDescription {
  String word;
  bool status;
  bool selected;

  EditorialDescription({
    required this.word,
    required this.status,
    this.selected = false,
  });

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'status': status,
      'selected': selected,
    };
  }

  // Method to create an instance from JSON
  factory EditorialDescription.fromJson(Map<String, dynamic> json) {
    return EditorialDescription(
      word: json['word'],
      status: json['status'],
      selected: json['selected'] ?? false,
    );
  }
  // Method to convert a list of instances to JSON
  static List<Map<String, dynamic>> listToJson(List<EditorialDescription> list) {
    return list.map((item) => item.toJson()).toList();
  }
  // Method to create a list of instances from JSON
  static List<EditorialDescription> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => EditorialDescription.fromJson(json)).toList();
  }

}