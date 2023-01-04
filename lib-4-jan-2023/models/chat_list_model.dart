import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListModel {
  String? id;
  String? chat_id;
  String? user_id;
  String? user_name;
  String? user_image;
  String? driver_id;
  String? driver_name;
  String? driver_image;
  String? job_id;
  String? job_title;
  String? status;
  DateTime? updatedon;
  DateTime? createdon;

  ChatListModel(
      {this.id,
      required this.chat_id,
      required this.user_id,
      required this.user_name,
      required this.user_image,
      required this.driver_id,
      required this.driver_name,
      required this.driver_image,
      required this.job_id,
      required this.job_title,
      required this.status,
      required this.updatedon,
      required this.createdon});

  ChatListModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    chat_id = documentSnapshot["chat_id"];
    user_id = documentSnapshot["user_id"];
    user_name = documentSnapshot["user_name"];
    user_image = documentSnapshot["user_image"];
    driver_id = documentSnapshot["driver_id"];

    driver_name = documentSnapshot["driver_name"];
    driver_image = documentSnapshot["driver_image"];
    job_id = documentSnapshot["job_id"];
    job_title = documentSnapshot["job_title"];
    updatedon = documentSnapshot["updatedon"].toDate();
    createdon = documentSnapshot["createdon"].toDate();

    status = documentSnapshot["status"];
  }

  factory ChatListModel.fromMap(Map data) {
    return ChatListModel(
        //id : data.id,
        chat_id: data["chat_id"],
        user_id: data["user_id"],
        user_name: data["user_name"],
        user_image: data["user_image"],
        driver_id: data["driver_id"],
        driver_name: data["driver_name"],
        driver_image: data["driver_image"],
        job_id: data["job_id"],
        job_title: data["job_title"],
        status: data["status"],
        updatedon: data["updatedon"].toDate(),
        createdon: data["createdon"].toDate());
  }
}
