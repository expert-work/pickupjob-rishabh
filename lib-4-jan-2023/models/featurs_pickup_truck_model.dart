import 'package:cloud_firestore/cloud_firestore.dart';

class FeatursPickupTruckModel {
  String? id;
  String? slugurl;
  String? title;

  FeatursPickupTruckModel(
      {this.id, required this.slugurl, required this.title});

  FeatursPickupTruckModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;

    slugurl = documentSnapshot["slugurl"];
    title = documentSnapshot["title"];
  }

  factory FeatursPickupTruckModel.fromMap(Map data) {
    return FeatursPickupTruckModel(
// id : data.id,
        slugurl: data["slugurl"],
        title: data["title"]);
  }
}
