import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:validators/validators.dart';

class PickUpJobModel {
  String? id;
  String? uid;
  String? uname;
  String? title;
  String? inputMethod;
  String? barCodeItemNumber;
  String? barCodeItem;
  String? weight;
  String? length;
  String? height;
  String? numberOfItem;
  String? itemImage;
  String? needLoadUnload;
  String? needLoadUnloadTime;

  //pick Addreess

  double? pickLat;
  double? pickLan;
  String? pickAddress;
  String? pickState;
  String? pickCity;
  String? pickZip;

//drop
  double? dropLat;
  double? dropLan;
  String? dropAddress;
  String? dropState;
  String? dropCity;
  String? dropZip;

// after pickup start
  String? driver_on_way_to_pickup;
  String? driver_at_pickup_location;
  String? user_picture_of_driver_with_driver_id;
  String? driver_image_of_pickup_job;
  String? driver_image_of_pickup_job_on_truck;
  String? driver_confirm_pickup_job;
  String? user_confirm_pickup_job;
  String? driver_at_drop_off_loaction;
  String? driver_pickupjob_delivered;

  String? user_release_payment;
  String? rating_to_driver;
  String? rating_to_user;
  String? review_for_customer;
  String? review_for_user;

//Contact Person
  String? contactPersonName;
  String? contactPersonMobile;
  String? contactPersonAlternateMobile;

  DateTime? dateForPickup;
  DateTime? timeForPickupLoad;

  bool? isAutoBid;
  DateTime? autoBidStartDateTime;

  DateTime? createdon;
  bool? isDone;
  String? status;

  String? bid_id;
  String? driver_id;
  String? driver_name;
  String? vehicle_id;
  String? vehicle_name;
  int? amount;

  PickUpJobModel({
    this.id,
    required this.uid,
    required this.uname,
    required this.title,
    required this.inputMethod,
    required this.barCodeItemNumber,
    required this.barCodeItem,
    required this.weight,
    required this.length,
    required this.height,
    required this.numberOfItem,
    required this.itemImage,
    required this.needLoadUnload,
    required this.needLoadUnloadTime,

    //pick Addreess

    required this.pickLat,
    required this.pickLan,
    required this.pickAddress,
    required this.pickState,
    required this.pickCity,
    required this.pickZip,

//drop
    required this.dropLat,
    required this.dropLan,
    required this.dropAddress,
    required this.dropState,
    required this.dropCity,
    required this.dropZip,

//Contact Person
    required this.contactPersonName,
    required this.contactPersonMobile,
    required this.contactPersonAlternateMobile,
    required this.dateForPickup,
    required this.timeForPickupLoad,
    required this.isAutoBid,
    required this.autoBidStartDateTime,
    required this.createdon,
    this.isDone,
    this.status,
    required this.bid_id,
    required this.driver_id,
    required this.driver_name,
    required this.vehicle_id,
    required this.vehicle_name,
    required this.amount,

    // after pickup start

    required this.driver_on_way_to_pickup,
    required this.driver_at_pickup_location,
    required this.user_picture_of_driver_with_driver_id,
    required this.driver_image_of_pickup_job,
    required this.driver_image_of_pickup_job_on_truck,
    required this.driver_confirm_pickup_job,
    required this.user_confirm_pickup_job,
    required this.driver_at_drop_off_loaction,
    required this.driver_pickupjob_delivered,
    required this.user_release_payment,
    required this.rating_to_driver,
    required this.rating_to_user,
    required this.review_for_customer,
    required this.review_for_user,
  });

  PickUpJobModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    print(documentSnapshot);
    uid = documentSnapshot["uid"];
    uname = documentSnapshot["uname"];
    title = documentSnapshot["title"];

    inputMethod = documentSnapshot["inputMethod"];
    barCodeItemNumber = documentSnapshot["barCodeItemNumber"];
    barCodeItem = documentSnapshot["barCodeItem"];
    weight = documentSnapshot["weight"];
    length = documentSnapshot["length"];
    height = documentSnapshot["height"];
    numberOfItem = documentSnapshot["numberOfItem"];
    itemImage = documentSnapshot["itemImage"];
    needLoadUnload = documentSnapshot["needLoadUnload"];
    needLoadUnloadTime = documentSnapshot["needLoadUnloadTime"];

    //pick Addreess

    pickLat = documentSnapshot["pickLat"] as double;
    pickLan = documentSnapshot["pickLan"] as double;
    pickAddress = documentSnapshot["pickAddress"];
    pickState = documentSnapshot["pickState"];
    pickCity = documentSnapshot["pickCity"];
    pickZip = documentSnapshot["pickZip"];

//drop
    dropLat = documentSnapshot["dropLat"] as double;
    dropLan = documentSnapshot["dropLan"] as double;
    dropAddress = documentSnapshot["dropAddress"];
    dropState = documentSnapshot["dropState"];
    dropCity = documentSnapshot["dropCity"];
    dropZip = documentSnapshot["dropZip"];

//Contact Person
    contactPersonName = documentSnapshot["contactPersonName"];
    contactPersonMobile = documentSnapshot["contactPersonMobile"];
    contactPersonAlternateMobile =
        documentSnapshot["contactPersonAlternateMobile"];

    dateForPickup = documentSnapshot["dateForPickup"].toDate();
    timeForPickupLoad = documentSnapshot["timeForPickupLoad"].toDate();

    isAutoBid = documentSnapshot["isAutoBid"];
    autoBidStartDateTime = documentSnapshot["autoBidStartDateTime"].toDate();

    createdon = documentSnapshot["createdon"].toDate();
    isDone = documentSnapshot["isDone"];
    status = documentSnapshot["status"];

    bid_id = documentSnapshot['bid_id'];

    driver_id = documentSnapshot['driver_id'];

    driver_name = documentSnapshot['driver_name'];

    vehicle_id = documentSnapshot['vehicle_id'];
    vehicle_name = documentSnapshot['vehicle_name'];
    amount = documentSnapshot['amount'];
    // after pickup start

    driver_on_way_to_pickup = documentSnapshot["driver_on_way_to_pickup"];
    driver_at_pickup_location = documentSnapshot["driver_at_pickup_location"];
    user_picture_of_driver_with_driver_id =
        documentSnapshot["user_picture_of_driver_with_driver_id"];
    driver_image_of_pickup_job = documentSnapshot["driver_image_of_pickup_job"];
    driver_image_of_pickup_job_on_truck =
        documentSnapshot["driver_image_of_pickup_job_on_truck"];

    driver_confirm_pickup_job = documentSnapshot["driver_confirm_pickup_job"];
    user_confirm_pickup_job = documentSnapshot["user_confirm_pickup_job"];
    driver_at_drop_off_loaction =
        documentSnapshot["driver_at_drop_off_loaction"];
    driver_pickupjob_delivered = documentSnapshot["driver_pickupjob_delivered"];
    user_release_payment = documentSnapshot["user_release_payment"];
    rating_to_driver = documentSnapshot["rating_to_driver"];
    rating_to_user = documentSnapshot["rating_to_user"];
    review_for_customer = documentSnapshot["review_for_customer"];
    review_for_user = documentSnapshot["review_for_user"];
  }

  factory PickUpJobModel.fromMap(Map data) {
    print("data loaded");
    print(data['driver_on_way_to_pickup']);
    print("data loaded end");
    return PickUpJobModel(
      uid: data["uid"],
      uname: data["uname"],
      title: data["title"],
      inputMethod: data["inputMethod"],
      barCodeItemNumber: data["barCodeItemNumber"],
      barCodeItem: data["barCodeItem"],
      weight: data["weight"],
      length: data["length"],
      height: data["height"],
      numberOfItem: data["numberOfItem"],
      itemImage: data["itemImage"],
      needLoadUnload: data["needLoadUnload"],
      needLoadUnloadTime: data["needLoadUnloadTime"],

      //pick Addreess

      pickLat: data["pickLat"] as double,
      pickLan: data["pickLan"] as double,
      pickAddress: data["pickAddress"],
      pickState: data["pickState"],
      pickCity: data["pickCity"],
      pickZip: data["pickZip"],

//drop
      dropLat: data["dropLat"] as double,
      dropLan: data["dropLan"] as double,
      dropAddress: data["dropAddress"],
      dropState: data["dropState"],
      dropCity: data["dropCity"],
      dropZip: data["dropZip"],

//Contact Person
      contactPersonName: data["contactPersonName"],
      contactPersonMobile: data["contactPersonMobile"],
      contactPersonAlternateMobile: data["contactPersonAlternateMobile"],
      dateForPickup: data["dateForPickup"].toDate(),
      timeForPickupLoad: data["timeForPickupLoad"].toDate(),
      isAutoBid: data["isAutoBid"],
      autoBidStartDateTime: data["autoBidStartDateTime"].toDate(),
      createdon: data["createdon"].toDate(),
      isDone: data["isDone"],
      status: data["status"],
      bid_id: data['bid_id'],
      driver_id: data['driver_id'],
      driver_name: data['driver_name'],
      vehicle_id: data['vehicle_id'],
      vehicle_name: data['vehicle_name'],
      amount: data['amount'],

      // after pickup start

      driver_on_way_to_pickup: data["driver_on_way_to_pickup"],
      driver_at_pickup_location: data["driver_at_pickup_location"],
      user_picture_of_driver_with_driver_id:
          data["user_picture_of_driver_with_driver_id"],
      driver_image_of_pickup_job: data["driver_image_of_pickup_job"],
      driver_image_of_pickup_job_on_truck:
          data["driver_image_of_pickup_job_on_truck"],

      driver_confirm_pickup_job: data["driver_confirm_pickup_job"],

      user_confirm_pickup_job: data["user_confirm_pickup_job"],
      driver_at_drop_off_loaction: data["driver_at_drop_off_loaction"],
      driver_pickupjob_delivered: data["driver_pickupjob_delivered"],
      user_release_payment: data["user_release_payment"],
      rating_to_driver: data["rating_to_driver"],
      rating_to_user: data["rating_to_user"],
      review_for_customer: data["review_for_customer"],
      review_for_user: data["review_for_user"],
    );
  }
}
