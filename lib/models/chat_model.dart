import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? id;
  String? chat_id;
  String? user_id;
  String? driver_id;
  String? job_id;
  String? message;
  String? send_by;
  String? status;
  String? type;
  DateTime? updatedon;
  DateTime? createdon;

  ChatModel(
      {this.id,
      required this.chat_id,
      required this.user_id,
      required this.driver_id,
      required this.job_id,
      required this.message,
      required this.send_by,
      required this.status,
      required this.type,
      required this.updatedon,
      required this.createdon});

  ChatModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;

    chat_id = documentSnapshot["chat_id"];
    user_id = documentSnapshot["user_id"];
    driver_id = documentSnapshot["driver_id"];
    job_id = documentSnapshot["job_id"];
    message = documentSnapshot["message"];

    send_by = documentSnapshot["send_by"];
    status = documentSnapshot["status"];
    type = documentSnapshot["type"];
    updatedon = documentSnapshot["updatedon"].toDate();
    createdon = documentSnapshot["createdon"].toDate();
  }

  factory ChatModel.fromMap(Map data) {
    return ChatModel(
// id : data.id,
        chat_id: data["chat_id"],
        user_id: data["user_id"],
        driver_id: data["driver_id"],
        job_id: data["job_id"],
        message: data["message"],
        send_by: data["send_by"],
        status: data["status"],
        type: data["type"],
        updatedon: data["updatedon"].toDate(),
        createdon: data["createdon"].toDate());
  }
}
