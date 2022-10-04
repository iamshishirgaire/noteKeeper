import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  late String title;
  late String subtitle;
  late String importance;
  late String id;
  late String userId;
  late DateTime dateTime;
  Note(
      {required this.title,
      required this.subtitle,
      required this.importance,
      required this.userId});

  Note.fromJson(Map json) {
    title = json["title"];
    subtitle = json["subtitle"];
    importance = json["importance"];
    dateTime = (json["dateTime"] as Timestamp).toDate();
    id = json["id"];
    userId = json["userId"];
  }

  Map<String, dynamic> toJson() {
    // json =  {
    //   "title": json["title"],
    //   "subtitle": "subtitle",
    //   "importance": "importance",
    //   "id": "id",
    // };
    return {
      "title": title,
      "subtitle": subtitle,
      "importance": importance,
      "userId": userId,
      "dateTime": FieldValue.serverTimestamp()
    };
  }
}
