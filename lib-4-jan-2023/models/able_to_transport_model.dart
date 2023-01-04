import 'package:cloud_firestore/cloud_firestore.dart';

class AbleToTransportModel {
  String? id;
  String? slugurl;
  String? title;

  AbleToTransportModel({this.id, required this.slugurl, required this.title});

  AbleToTransportModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;

    slugurl = documentSnapshot["slugurl"];
    title = documentSnapshot["title"];
  }

  factory AbleToTransportModel.fromMap(Map data) {
    return AbleToTransportModel(
// id : data.id,
        slugurl: data["slugurl"],
        title: data["title"]);
  }
}
