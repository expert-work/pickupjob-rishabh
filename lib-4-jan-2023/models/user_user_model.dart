import 'package:cloud_firestore/cloud_firestore.dart';

class UserUser {
  String? documentId;
  late String content;
  late Timestamp createdOn;
  late bool isDone;

  UserUser({
    required this.content,
    required this.isDone,
//     required this.createdOn,
  });

  UserUser.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    documentId = documentSnapshot.id;
    content = documentSnapshot["content"];
    createdOn = documentSnapshot["createdOn"];
    isDone = documentSnapshot["isDone"];
  }
}
