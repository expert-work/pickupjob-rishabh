import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  String? id;
  String? uid;
  String? uname;
  String? driverId;
  String? title;
  String? ownThisVehicle;
  String? ownerOfVehicle;

  String? leaseContactInfo;
  String? year;
  String? make;
  String? model;
  String? pictureOfVehicle;
  String? pictureOfLicPlate;
  String? pictureOfVehicleReg;
  String? pictureOfVehicleInspection;

  String? vehicleInsurenceProvider;
  String? vehicleInsurencePolicyName;
  String? pictureOfVehicleInsurenceCard;
  String? ableToTransport;
  String? specialFeaturesCargoVans;
  String? specialFeaturespickupTrucks;
  String? status;

  Timestamp? createdon;
  bool? isDone;

  VehicleModel({
    this.id,
    this.uid,
    this.uname,
    required this.driverId,
    required this.title,
    required this.ownThisVehicle,
    required this.ownerOfVehicle,
    required this.leaseContactInfo,
    required this.year,
    required this.make,
    required this.model,
    required this.pictureOfVehicle,
    required this.pictureOfLicPlate,
    required this.pictureOfVehicleReg,
    required this.pictureOfVehicleInspection,
    required this.vehicleInsurenceProvider,
    required this.vehicleInsurencePolicyName,
    required this.pictureOfVehicleInsurenceCard,
    required this.ableToTransport,
    required this.specialFeaturesCargoVans,
    required this.specialFeaturespickupTrucks,
    required this.status,
    this.createdon,
  });

  VehicleModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;

    var absdsd = documentSnapshot;
    print("documentSnapshot");
    print(absdsd.id);
    print("documentSnapshot");
    uid = documentSnapshot["uid"];
    uname = documentSnapshot["uname"];

    driverId = documentSnapshot["driverId"];
    title = documentSnapshot["title"];
    ownThisVehicle = documentSnapshot["ownThisVehicle"];
    ownerOfVehicle = documentSnapshot["ownerOfVehicle"];
    leaseContactInfo = documentSnapshot["leaseContactInfo"];
    year = documentSnapshot["year"];
    make = documentSnapshot["make"];
    model = documentSnapshot["model"];
    pictureOfVehicle = documentSnapshot["pictureOfVehicle"];
    pictureOfLicPlate = documentSnapshot["pictureOfLicPlate"];
    pictureOfVehicleReg = documentSnapshot["pictureOfVehicleReg"];
    pictureOfVehicleInspection = documentSnapshot["pictureOfVehicleInspection"];
    vehicleInsurenceProvider = documentSnapshot["vehicleInsurenceProvider"];
    vehicleInsurencePolicyName = documentSnapshot["vehicleInsurencePolicyName"];
    pictureOfVehicleInsurenceCard =
        documentSnapshot["pictureOfVehicleInsurenceCard"];
    ableToTransport = documentSnapshot["ableToTransport"];
    specialFeaturesCargoVans = documentSnapshot["specialFeaturesCargoVans"];
    specialFeaturespickupTrucks =
        documentSnapshot["specialFeaturespickupTrucks"];
    status = documentSnapshot["status"];

    createdon = documentSnapshot["createdon"];
    // isDone = documentSnapshot["isDone"];
  }

  factory VehicleModel.fromMap(Map data) {
    return VehicleModel(
        uid: data["uid"],
        uname: data["uname"],
        driverId: data["driverId"],
        title: data["title"],
        ownThisVehicle: data["ownThisVehicle"],
        ownerOfVehicle: data["ownerOfVehicle"],
        leaseContactInfo: data["leaseContactInfo"],
        year: data["year"],
        make: data["make"],
        model: data["model"],
        pictureOfVehicle: data["pictureOfVehicle"],
        pictureOfLicPlate: data["pictureOfLicPlate"],
        pictureOfVehicleReg: data["pictureOfVehicleReg"],
        pictureOfVehicleInspection: data["pictureOfVehicleInspection"],
        vehicleInsurenceProvider: data["vehicleInsurenceProvider"],
        vehicleInsurencePolicyName: data["vehicleInsurencePolicyName"],
        pictureOfVehicleInsurenceCard: data["pictureOfVehicleInsurenceCard"],
        ableToTransport: data["ableToTransport"],
        specialFeaturesCargoVans: data["specialFeaturesCargoVans"],
        specialFeaturespickupTrucks: data["specialFeaturespickupTrucks"],
        status: data["status"],
        createdon: data["createdon"]);
  }
}
