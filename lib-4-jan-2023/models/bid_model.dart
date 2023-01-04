import 'package:cloud_firestore/cloud_firestore.dart';

class BidModel {
  String? id;
  String? user_id;
  String? user_name;
  String? job_id;
  String? job_title;
  String? job_image;
  String? driver_id;
  String? driver_name;
  String? selected_vehicle;
  String? selected_vehicle_title;
  String? selected_vehicle_picture;
  String? year;
  String? make;
  String? model;
  String? bid_amount;
  String? message;
  String? status;
  String? createdon;
  String? updatedon;

  BidModel(
      {this.id,
      required this.user_id,
      required this.user_name,
      required this.job_id,
      required this.job_title,
      required this.job_image,
      required this.driver_id,
      required this.driver_name,
      required this.selected_vehicle,
      required this.selected_vehicle_title,
      required this.selected_vehicle_picture,
      required this.bid_amount,
      required this.year,
      required this.make,
      required this.model,
      required this.message,
      required this.status,
      required this.createdon,
      required this.updatedon});

  BidModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;

    user_id = documentSnapshot["user_id"];
    user_name = documentSnapshot["user_name"];
    job_id = documentSnapshot["job_id"];
    job_title = documentSnapshot["job_title"];
    job_image = documentSnapshot["job_image"];

    driver_id = documentSnapshot["driver_id"];
    driver_name = documentSnapshot["driver_name"];
    selected_vehicle = documentSnapshot["selected_vehicle"];
    selected_vehicle_title = documentSnapshot["selected_vehicle_title"];
    selected_vehicle_picture = documentSnapshot["selected_vehicle_picture"];

    year = documentSnapshot["year"];
    make = documentSnapshot["make"];
    model = documentSnapshot["model"];

    bid_amount = documentSnapshot["bid_amount"];
    message = documentSnapshot["message"];
    status = documentSnapshot["status"];
    createdon = documentSnapshot["createdon"].toString();
    updatedon = documentSnapshot["updatedon"].toString();
  }

  factory BidModel.fromMap(Map data) {
    return BidModel(
// id : data.id,
      user_id: data["user_id"],
      user_name: data["user_name"],
      job_id: data["job_id"],
      job_title: data["job_title"],
      job_image: data["job_image"],

      driver_id: data["driver_id"],
      driver_name: data["driver_name"],
      selected_vehicle: data["selected_vehicle"],
      selected_vehicle_title: data["selected_vehicle_title"],
      selected_vehicle_picture: data["selected_vehicle_picture"],

      year: data["year"],
      make: data["make"],
      model: data["model"],

      bid_amount: data["bid_amount"],
      message: data["message"],
      status: data["status"],
      createdon: data["createdon"],
      updatedon: data["updatedon"],
    );
  }
}
