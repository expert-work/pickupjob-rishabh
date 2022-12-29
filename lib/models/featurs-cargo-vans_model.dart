import 'package:cloud_firestore/cloud_firestore.dart';

class FeatursCargoVansModel {
  String? id;
  String? slugurl;
  String? title;

  FeatursCargoVansModel({this.id, required this.slugurl, required this.title});

  FeatursCargoVansModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;

    slugurl = documentSnapshot["slugurl"];
    title = documentSnapshot["title"];
  }

  factory FeatursCargoVansModel.fromMap(Map data) {
    return FeatursCargoVansModel(
// id : data.id,
        slugurl: data["slugurl"],
        title: data["title"]);
  }
}
