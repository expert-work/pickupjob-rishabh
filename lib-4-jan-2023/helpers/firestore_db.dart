import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pickupjob/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:pickupjob/constants.dart';
import 'package:pickupjob/models/models.dart';
import 'package:pickupjob/models/user_model.dart';
import 'package:pickupjob/models/vehicle_model.dart';
import 'package:pickupjob/ui/ui.dart';
import 'package:http/http.dart' as http;
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';

final getStorage = GetStorage();
GeoFirestore geoFirestore = GeoFirestore(firebaseFirestore.collection('users'));

class FirestoreDb {
  static addVehicle(VehicleModel vehiclemodel) async {
    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);
    print("auth.currentUser!.uid");
    await firebaseFirestore.collection('vehicles').add({
      'uid': vehiclemodel.uid,
      'uname': vehiclemodel.uname,
      'driverId': vehiclemodel.driverId,
      'title': vehiclemodel.title,
      'ownThisVehicle': vehiclemodel.ownThisVehicle,
      'ownerOfVehicle': vehiclemodel.ownerOfVehicle,
      'leaseContactInfo': vehiclemodel.leaseContactInfo,
      'year': vehiclemodel.year,
      'make': vehiclemodel.make,
      'model': vehiclemodel.model,
      'pictureOfVehicle': vehiclemodel.pictureOfVehicle,
      'pictureOfLicPlate': vehiclemodel.pictureOfLicPlate,
      'pictureOfVehicleReg': vehiclemodel.pictureOfVehicleReg,
      'pictureOfVehicleInspection': vehiclemodel.pictureOfVehicleInspection,
      'vehicleInsurenceProvider': vehiclemodel.vehicleInsurenceProvider,
      'vehicleInsurencePolicyName': vehiclemodel.vehicleInsurencePolicyName,
      'pictureOfVehicleInsurenceCard':
          vehiclemodel.pictureOfVehicleInsurenceCard,
      'ableToTransport': vehiclemodel.ableToTransport,
      'specialFeaturesCargoVans': vehiclemodel.specialFeaturesCargoVans,
      'specialFeaturespickupTrucks': vehiclemodel.specialFeaturespickupTrucks,
      'createdon': Timestamp.now(),
      'status': 'Open',
      'isDone': false,
    });
    // int numberOfVehicle = 0;
    // print(AuthController().firestoreUser.value?.numberOfVehicle);
    // numberOfVehicle =
    //     (AuthController().firestoreUser.value!.numberOfVehicle != null)
    //         ? AuthController().firestoreUser.value!.numberOfVehicle
    //         : 0 + 1;
    // UserModel user = UserModel(
    //     uid: auth.currentUser!.uid,
    //     email: AuthController().firestoreUser.value!.email,
    //     name: AuthController().firestoreUser.value!.name,
    //     photoUrl: AuthController().firestoreUser.value!.photoUrl,
    //     userType: AuthController().firestoreUser.value!.userType,
    //     isProfileCompleted:
    //         AuthController().firestoreUser.value!.isProfileCompleted,
    //     isIndividual: AuthController().firestoreUser.value!.isIndividual,
    //     numberOfVehicle: numberOfVehicle);
    // AuthController().updateUserFirestoreById(user, auth.currentUser!.uid);

    Get.snackbar("Success", "Vehicle Successfully added",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
  }

  static Stream<List<AbleToTransportModel>> ableToTransportStream() {
    return firebaseFirestore
        .collection('able-to-transport')
        .orderBy('title', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<AbleToTransportModel> bids = [];
      for (var todo in query.docs) {
        final abletotransportModel =
            AbleToTransportModel.fromDocumentSnapshot(documentSnapshot: todo);
        bids.add(abletotransportModel);
      }
      return bids;
    });
  }

  static Stream<List<FeatursCargoVansModel>> featursCargoVansStream() {
    return firebaseFirestore
        .collection('featurs-cargo-vans')
        .orderBy('title', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<FeatursCargoVansModel> FeatursCargoVans = [];
      for (var todo in query.docs) {
        final featursCargoVans =
            FeatursCargoVansModel.fromDocumentSnapshot(documentSnapshot: todo);
        FeatursCargoVans.add(featursCargoVans);
      }
      return FeatursCargoVans;
    });
  }

  static Stream<List<FeatursPickupTruckModel>> featursPickupTruckStream() {
    return firebaseFirestore
        .collection('featurs-pickup-truck')
        .orderBy('title', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<FeatursPickupTruckModel> FeatursPickupTruck = [];
      for (var todo in query.docs) {
        final featursPickupTruck = FeatursPickupTruckModel.fromDocumentSnapshot(
            documentSnapshot: todo);
        FeatursPickupTruck.add(featursPickupTruck);
      }
      return FeatursPickupTruck;
    });
  }

  static Stream<List<BidModel>> bidStream() {
    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);
    print("auth.currentUser!.uid");

    return firebaseFirestore
        .collection('bids')
        .where("driver_id", isEqualTo: auth.currentUser!.uid)
        .orderBy('createdon', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<BidModel> bids = [];
      for (var todo in query.docs) {
        final vehicleModel =
            BidModel.fromDocumentSnapshot(documentSnapshot: todo);
        bids.add(vehicleModel);
      }
      return bids;
    });
  }

  static Stream<List<ChatModel>> chatStream() {
    return firebaseFirestore
        .collection('chats')
        .doc(getStorage.read('chat_id') ?? 'false')
        .collection('message')
        .orderBy('aid', descending: true)
        .where("chat_id", isEqualTo: getStorage.read('chat_id') ?? false)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ChatModel> chats = [];
      for (var todo in query.docs) {
        final chatsModel =
            ChatModel.fromDocumentSnapshot(documentSnapshot: todo);
        chats.add(chatsModel);
      }
      return chats;
    });
  }

  static addChat(ChatModel chatModel) async {
    await firebaseFirestore
        .collection('chats')
        .doc(chatModel.chat_id)
        .collection('message')
        .add({
      "aid": DateTime.now().millisecondsSinceEpoch,
      "chat_id": chatModel.chat_id,
      "user_id": chatModel.user_id,
      "driver_id": chatModel.driver_id,
      "job_id": chatModel.job_id,
      "message": chatModel.message,
      "send_by": chatModel.send_by,
      "status": chatModel.status,
      "type": chatModel.type,
      "updatedon": chatModel.updatedon,
      "createdon": chatModel.createdon
    });
  }

  static Stream<List<ChatListModel>> chatListDriverStream() {
    return firebaseFirestore
        .collection('chat-list')
        .where("driver_id", isEqualTo: auth.currentUser!.uid)
        .orderBy('createdon', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ChatListModel> chatsLists = [];
      for (var todo in query.docs) {
        final chatListModel =
            ChatListModel.fromDocumentSnapshot(documentSnapshot: todo);
        chatsLists.add(chatListModel);
      }
      return chatsLists;
    });
  }

  static Stream<List<ChatListModel>> chatListUserStream() {
    return firebaseFirestore
        .collection('chat-list')
        .where("user_id", isEqualTo: auth.currentUser!.uid)
        .orderBy('createdon', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ChatListModel> chatsLists = [];
      for (var todo in query.docs) {
        final chatListModel =
            ChatListModel.fromDocumentSnapshot(documentSnapshot: todo);
        chatsLists.add(chatListModel);
      }
      return chatsLists;
    });
  }

  static addChatList(ChatListModel chatListModel) async {
    final count = await firebaseFirestore
        .collection('chat-list')
        .where("chat_id", isEqualTo: chatListModel.chat_id)
        .get()
        .then((res) => res.size);
    print(count);
    print("yes printedt");

    print("object");
    if (count < 1) {
      await firebaseFirestore.collection('chat-list').add({
        "chat_id": chatListModel.chat_id,
        "user_id": chatListModel.user_id,
        "user_name": chatListModel.user_name,
        "user_image": chatListModel.user_image,
        "driver_id": chatListModel.driver_id,
        "driver_name": chatListModel.driver_name,
        "driver_image": chatListModel.driver_image,
        "job_id": chatListModel.job_id,
        "job_title": chatListModel.job_title,
        "status": chatListModel.status,
        "updatedon": chatListModel.updatedon,
        "createdon": chatListModel.createdon
      });
      // Get.snackbar("Success", "chat room Successfully created",
      //     snackPosition: SnackPosition.BOTTOM,
      //     duration: const Duration(seconds: 7),
      //     backgroundColor: Get.theme.snackBarTheme.backgroundColor,
      //     colorText: Get.theme.snackBarTheme.actionTextColor);

      Get.to(() => Chat(), arguments: {
        "chat_id": chatListModel.chat_id,
        "user_id": chatListModel.user_id,
        "user_name": chatListModel.user_name,
        "user_image": chatListModel.user_image,
        "driver_id": chatListModel.driver_id,
        "driver_name": chatListModel.driver_name,
        "driver_image": chatListModel.driver_image,
        "job_id": chatListModel.job_id,
        "job_title": chatListModel.job_title,
        "status": chatListModel.status,
        "updatedon": chatListModel.updatedon,
        "createdon": chatListModel.createdon
      });
    } else {
      // Get.snackbar("Success", "chat room already created",
      //     snackPosition: SnackPosition.BOTTOM,
      //     duration: const Duration(seconds: 7),
      //     backgroundColor: Get.theme.snackBarTheme.backgroundColor,
      //     colorText: Get.theme.snackBarTheme.actionTextColor);
      Get.to(() => Chat(), arguments: {
        "chat_id": chatListModel.chat_id,
        "user_id": chatListModel.user_id,
        "user_name": chatListModel.user_name,
        "user_image": chatListModel.user_image,
        "driver_id": chatListModel.driver_id,
        "driver_name": chatListModel.driver_name,
        "driver_image": chatListModel.driver_image,
        "job_id": chatListModel.job_id,
        "job_title": chatListModel.job_title,
        "status": chatListModel.status,
        "updatedon": chatListModel.updatedon,
        "createdon": chatListModel.createdon
      });
    }
  }

  static Stream<List<BidModel>> bidsUserStream() {
    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);
    print("auth.currentUser!.uid");

    return firebaseFirestore
        .collection('bids')
        .where("user_id", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot query) {
      List<BidModel> bids = [];
      for (var todo in query.docs) {
        final vehicleModel =
            BidModel.fromDocumentSnapshot(documentSnapshot: todo);
        bids.add(vehicleModel);
      }
      return bids;
    });
  }

  static addBids(BidModel bidModel) async {
    final count = await firebaseFirestore
        .collection('bids')
        .where("driver_id", isEqualTo: bidModel.driver_id)
        .where("job_id", isEqualTo: bidModel.job_id)
        .get()
        .then((res) => res.size);
    print(count);
    //var c = getCount(bidModel.job_id, bidModel.driver_id);
    print("yes printedt");

    print("object");
    if (count < 1) {
      await firebaseFirestore.collection('bids').add({
        "user_id": bidModel.user_id,
        "user_name": bidModel.user_name,
        "job_id": bidModel.job_id,
        "job_title": bidModel.job_title,
        "job_image": bidModel.job_image,
        "selected_vehicle": bidModel.selected_vehicle,
        "selected_vehicle_title": bidModel.selected_vehicle_title,
        "selected_vehicle_picture": bidModel.selected_vehicle_picture,
        "bid_amount": bidModel.bid_amount,
        "message": bidModel.message,
        "status": bidModel.status,
        "driver_id": bidModel.driver_id,
        "driver_name": bidModel.driver_name,
        "updatedon": bidModel.updatedon,
        "createdon": bidModel.createdon
      });
      Get.snackbar("Success", "Bid Successfully added",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 7),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
      Get.offAll(listProposalsDriver());
    } else {
      Get.snackbar("Success", "You already bided on this job",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 7),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  static editBidS(BidModel bidModel) async {
    await firebaseFirestore.collection('bids').doc(bidModel.id).update({
      "status": bidModel.status,
    });
    print(bidModel.status.toString());
    if (bidModel.status.toString() == 'Accepted') {
      sendPushMessage(
          bidModel.driver_id.toString(),
          'Your bid on Pickup Job - ' +
              bidModel.job_title.toString() +
              ' Accepted, Start chat for more info',
          'Bid Accepted');
    }

    Get.snackbar("Success", "Bid Successfully " + bidModel.status.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
    Get.offAll(listProposalsUser());
  }

  // static getCount(jobId, driver_id) async {
  //   final count = await firebaseFirestore
  //       .collection('bids')
  //       .where("driver_id", isEqualTo: driver_id)
  //       .where("job_id", isEqualTo: jobId)
  //       .get()
  //       .then((res) => res.size);
  //   print("countstart-" + driver_id);
  //   print(count);
  //   print("countend-" + jobId);
  //   return count;
  // }

  // static Stream<List<BidModel>> checkDriverAppliedOrNot(jobId, driver_id) {
  //   return firebaseFirestore
  //       .collection('bids')
  //       .where("driver_id", isEqualTo: driver_id)
  //       .where("job_id", isEqualTo: jobId)
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //     List<BidModel> bids = [];
  //     for (var todo in query.docs) {
  //       print("vehicleModel");
  //       print(todo.data());
  //       print("vehicleModel");

  //       final bidModel = BidModel.fromDocumentSnapshot(documentSnapshot: todo);
  //       print("vehicleModel");
  //       print(todo.data());
  //       print("vehicleModel");
  //       print(bidModel);

  //       bids.add(bidModel);
  //     }
  //     return bids;
  //   });
  // }

  static Stream<PickUpJobModel> getJob(id) {
    return FirebaseFirestore.instance
        .collection('pickupjobs')
        .doc(id)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      return PickUpJobModel.fromDocumentSnapshot(
          documentSnapshot: snapshot.data as DocumentSnapshot);
    });
    ;
  }

  static addPickupJobs(PickUpJobModel pickUpJobModel) async {
    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);
    print("auth.currentUser!.uid");
    await firebaseFirestore.collection('pickupjobs').add({
      "uid": pickUpJobModel.uid,
      "uname": pickUpJobModel.uname,
      "title": pickUpJobModel.title,
      "inputMethod": pickUpJobModel.inputMethod,
      "barCodeItemNumber": pickUpJobModel.barCodeItemNumber,
      "barCodeItem": pickUpJobModel.barCodeItem,
      "weight": pickUpJobModel.weight,
      "length": pickUpJobModel.length,
      "height": pickUpJobModel.height,
      "numberOfItem": pickUpJobModel.numberOfItem,
      "itemImage": pickUpJobModel.itemImage,
      "needLoadUnload": pickUpJobModel.needLoadUnload,
      "needLoadUnloadTime": pickUpJobModel.needLoadUnloadTime,
      "pickLat": pickUpJobModel.pickLat,
      "pickLan": pickUpJobModel.pickLan,
      "pickAddress": pickUpJobModel.pickAddress,
      "pickState": pickUpJobModel.pickState,
      "pickCity": pickUpJobModel.pickCity,
      "pickZip": pickUpJobModel.pickZip,
      "dropLat": pickUpJobModel.dropLat,
      "dropLan": pickUpJobModel.dropLan,
      "dropAddress": pickUpJobModel.dropAddress,
      "dropState": pickUpJobModel.dropState,
      "dropCity": pickUpJobModel.dropCity,
      "dropZip": pickUpJobModel.dropZip,
      "contactPersonName": pickUpJobModel.contactPersonName,
      "contactPersonMobile": pickUpJobModel.contactPersonMobile,
      "contactPersonAlternateMobile":
          pickUpJobModel.contactPersonAlternateMobile,
      "dateForPickup": pickUpJobModel.dateForPickup,
      "timeForPickupLoad": pickUpJobModel.timeForPickupLoad,
      "isAutoBid": pickUpJobModel.isAutoBid,
      "autoBidStartDateTime": pickUpJobModel.autoBidStartDateTime,
      "createdon": pickUpJobModel.createdon,
      "isDone": pickUpJobModel.isDone,
      "status": pickUpJobModel.status,
      "bid_id": "",
      "driver_id": "",
      "driver_name": "",
      "vehicle_id": "",
      "vehicle_name": "",
      "amount": 0,

      // after pickup start

      "driver_on_way_to_pickup": "",
      "driver_at_pickup_location": "",
      "user_picture_of_driver_with_driver_id": "",
      "driver_image_of_pickup_job": "",
      "driver_image_of_pickup_job_on_truck": "",
      "driver_confirm_pickup_job": "",
      "user_confirm_pickup_job": "",
      "driver_at_drop_off_loaction": "",
      "driver_pickupjob_delivered": "",
      "user_release_payment": "",
      "rating_to_driver": "",
      "rating_to_user": "",
      "review_for_customer": "",
      "review_for_user": "",
    });

    Get.snackbar("Success", "Job Successfully added",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
  }

  static editPickupJobs(PickUpJobModel pickUpJobModel) async {
    await firebaseFirestore
        .collection('pickupjobs')
        .doc(pickUpJobModel.id)
        .update({
      "uname": pickUpJobModel.uname,
      "title": pickUpJobModel.title,
      "inputMethod": pickUpJobModel.inputMethod,
      "barCodeItemNumber": pickUpJobModel.barCodeItemNumber,
      "barCodeItem": pickUpJobModel.barCodeItem,
      "weight": pickUpJobModel.weight,
      "length": pickUpJobModel.length,
      "height": pickUpJobModel.height,
      "numberOfItem": pickUpJobModel.numberOfItem,
      "itemImage": pickUpJobModel.itemImage,
      "needLoadUnload": pickUpJobModel.needLoadUnload,
      "needLoadUnloadTime": pickUpJobModel.needLoadUnloadTime,
      "pickLat": pickUpJobModel.pickLat,
      "pickLan": pickUpJobModel.pickLan,
      "pickAddress": pickUpJobModel.pickAddress,
      "pickState": pickUpJobModel.pickState,
      "pickCity": pickUpJobModel.pickCity,
      "pickZip": pickUpJobModel.pickZip,
      "dropLat": pickUpJobModel.dropLat,
      "dropLan": pickUpJobModel.dropLan,
      "dropAddress": pickUpJobModel.dropAddress,
      "dropState": pickUpJobModel.dropState,
      "dropCity": pickUpJobModel.dropCity,
      "dropZip": pickUpJobModel.dropZip,
      "contactPersonName": pickUpJobModel.contactPersonName,
      "contactPersonMobile": pickUpJobModel.contactPersonMobile,
      "contactPersonAlternateMobile":
          pickUpJobModel.contactPersonAlternateMobile,
      "dateForPickup": pickUpJobModel.dateForPickup,
      "timeForPickupLoad": pickUpJobModel.timeForPickupLoad,
      "isAutoBid": pickUpJobModel.isAutoBid,
      "autoBidStartDateTime": pickUpJobModel.autoBidStartDateTime,
      "createdon": pickUpJobModel.createdon,
      "isDone": pickUpJobModel.isDone,
      "status": pickUpJobModel.status,
      "amount": pickUpJobModel.amount,
      "bid_id": pickUpJobModel.bid_id,
      "driver_id": pickUpJobModel.driver_id,
      "driver_name": pickUpJobModel.driver_name,
      "vehicle_id": pickUpJobModel.vehicle_id,
      "vehicle_name": pickUpJobModel.vehicle_name,
    });

    Get.snackbar("Success", "Job Successfully updated",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
  }

  static deletePickupJobs(job_id) async {
    await firebaseFirestore.collection('pickupjobs').doc(job_id).delete();

    Get.snackbar("Success", "Job Successfully deleted",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
  }

  static updatePickUpJobSteps(PickUpJobModel pickUpJobModel) async {
    await firebaseFirestore
        .collection('pickupjobs')
        .doc(pickUpJobModel.id)
        .update({
      "driver_on_way_to_pickup": pickUpJobModel.driver_on_way_to_pickup,
      "driver_at_pickup_location": pickUpJobModel.driver_at_pickup_location,
      "user_picture_of_driver_with_driver_id":
          pickUpJobModel.user_picture_of_driver_with_driver_id,
      "driver_image_of_pickup_job": pickUpJobModel.driver_image_of_pickup_job,
      "driver_image_of_pickup_job_on_truck":
          pickUpJobModel.driver_image_of_pickup_job_on_truck,
      "driver_confirm_pickup_job": pickUpJobModel.driver_confirm_pickup_job,
      "user_confirm_pickup_job": pickUpJobModel.user_confirm_pickup_job,
      "driver_at_drop_off_loaction": pickUpJobModel.driver_at_drop_off_loaction,
      "driver_pickupjob_delivered": pickUpJobModel.driver_pickupjob_delivered,
      "user_release_payment": pickUpJobModel.user_release_payment,
      "rating_to_driver": pickUpJobModel.rating_to_driver,
      "rating_to_user": pickUpJobModel.rating_to_user,
      "review_for_customer": pickUpJobModel.review_for_customer,
      "review_for_user": pickUpJobModel.review_for_user
    });
    Get.snackbar("Success", "Successfully Updated",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
  }

  static hire(BidModel bidModel, PickUpJobModel pickUpJobModel) async {
    await firebaseFirestore
        .collection('pickupjobs')
        .doc(bidModel.job_id)
        .update({
      "status": pickUpJobModel.status,
      "bid_id": pickUpJobModel.bid_id,
      "driver_id": pickUpJobModel.driver_id,
      "driver_name": pickUpJobModel.driver_name,
      "vehicle_id": pickUpJobModel.vehicle_id,
      "vehicle_name": pickUpJobModel.vehicle_name,
      "amount": pickUpJobModel.amount
    });

    await firebaseFirestore.collection('bids').doc(bidModel.id).update({
      "status": bidModel.status,
      "updatedon": DateTime.now().toString(),
    });
    sendPushMessage(
        bidModel.driver_id.toString(),
        bidModel.user_name.toString() +
            ' Hired You for job ' +
            bidModel.job_title.toString() +
            '. Best Of Luck!',
        'Hired for job ' + bidModel.job_title.toString());

    Get.snackbar("Success", "Hired Successfully ",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
    Get.offAll(userHome());
  }

  static Stream<List<PickUpJobModel>> pickupSearchJobsList(radius) {
    print("radius updated start");
    print(radius);
    print("radius updated end");

    return firebaseFirestore
        .collection('pickupjobs')
        .where("status", isEqualTo: 'Open')
        .orderBy('createdon', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<PickUpJobModel> pickupjobs = [];
      for (var todo in query.docs) {
        print("vehicleModel");
        print(todo.data());
        print("vehicleModel");

        final pickUpJobModel =
            PickUpJobModel.fromDocumentSnapshot(documentSnapshot: todo);
        print("vehicleModel");
        print(todo.data());
        print("vehicleModel");
        print(pickUpJobModel);

        pickupjobs.add(pickUpJobModel);
      }
      return pickupjobs;
    });
  }

  static Stream<List<PickUpJobModel>> pickupInProgressjobsUserList() {
    return firebaseFirestore
        .collection('pickupjobs')
        .where("uid", isEqualTo: auth.currentUser!.uid)
        .where("status", isEqualTo: 'In Progress')
        .snapshots()
        .map((QuerySnapshot query) {
      List<PickUpJobModel> pickupjobs = [];
      for (var todo in query.docs) {
        final pickUpJobModel =
            PickUpJobModel.fromDocumentSnapshot(documentSnapshot: todo);
        pickupjobs.add(pickUpJobModel);
      }
      return pickupjobs;
    });
  }

  static Stream<List<PickUpJobModel>> pickupInProgressjobsDriverList() {
    return firebaseFirestore
        .collection('pickupjobs')
        .where("driver_id", isEqualTo: auth.currentUser!.uid)
        .where("status", isEqualTo: 'In Progress')
        .orderBy('createdon', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<PickUpJobModel> pickupjobs = [];
      for (var todo in query.docs) {
        final pickUpJobModel =
            PickUpJobModel.fromDocumentSnapshot(documentSnapshot: todo);
        pickupjobs.add(pickUpJobModel);
      }
      return pickupjobs;
    });
  }

  static Stream<List<PickUpJobModel>> pickupOpenJobsList() {
    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);
    print("auth.currentUser!.uid");

    return firebaseFirestore
        .collection('pickupjobs')
        .where("uid", isEqualTo: auth.currentUser!.uid)
        .where("status", isEqualTo: 'Open')
        .orderBy('createdon', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<PickUpJobModel> pickupjobs = [];
      for (var todo in query.docs) {
        print("vehicleModel");
        print(todo.data());
        print("vehicleModel");

        final pickUpJobModel =
            PickUpJobModel.fromDocumentSnapshot(documentSnapshot: todo);
        print("vehicleModel");
        print(todo.data());
        print("vehicleModel");
        print(pickUpJobModel);

        pickupjobs.add(pickUpJobModel);
      }
      return pickupjobs;
    });
  }

  static Stream<List<PickUpJobModel>> pickupJobsList() {
    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);
    print("auth.currentUser!.uid");

    return firebaseFirestore
        .collection('pickupjobs')
        .where("uid", isEqualTo: auth.currentUser!.uid)
        .orderBy('createdon', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<PickUpJobModel> pickupjobs = [];
      for (var todo in query.docs) {
        print("vehicleModel");
        print(todo.data());
        print("vehicleModel");

        final pickUpJobModel =
            PickUpJobModel.fromDocumentSnapshot(documentSnapshot: todo);
        print("vehicleModel");
        print(todo.data());
        print("vehicleModel");
        print(pickUpJobModel);

        pickupjobs.add(pickUpJobModel);
      }
      return pickupjobs;
    });
  }

  static Future<PickUpJobModel> pickupJobsId(jobId) {
    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);
    print("auth.currentUser!.uid");

    return firebaseFirestore.collection('pickupjobs').doc(jobId).get().then(
        (documentSnapshot) => PickUpJobModel.fromMap(documentSnapshot.data()!));
  }

  static Stream<List<VehicleModel>> todoStream() {
    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);
    print("auth.currentUser!.uid");

    return firebaseFirestore
        .collection('vehicles')
        .where("uid", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot query) {
      List<VehicleModel> vehicles = [];
      for (var todo in query.docs) {
        final vehicleModel =
            VehicleModel.fromDocumentSnapshot(documentSnapshot: todo);
        // print("vehicleModel");
        // print(todo.data());
        // print("vehicleModel");

        vehicles.add(vehicleModel);
      }
      return vehicles;
    });
  }

  static Stream<List<VehicleModel>> vehicleListOpen() {
    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);
    print("auth.currentUser!.uid");

    return firebaseFirestore
        .collection('vehicles')
        .where("status", isEqualTo: 'Open')
        .snapshots()
        .map((QuerySnapshot query) {
      List<VehicleModel> vehicles = [];
      for (var todo in query.docs) {
        final vehicleModel =
            VehicleModel.fromDocumentSnapshot(documentSnapshot: todo);
        // print("vehicleModel");
        // print(todo.data());
        // print("vehicleModel");

        vehicles.add(vehicleModel);
      }
      return vehicles;
    });
  }

  static Stream<List<VehicleModel>> myVehicleListOpen() {
    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);
    print("auth.currentUser!.uid");

    return firebaseFirestore
        .collection('vehicles')
        .where("status", isEqualTo: 'Open')
        .where("uid", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot query) {
      List<VehicleModel> vehicles = [];
      for (var todo in query.docs) {
        final vehicleModel =
            VehicleModel.fromDocumentSnapshot(documentSnapshot: todo);
        // print("myVehicleListOpen");
        // print(todo.data());
        // print("myVehicleListOpen");

        vehicles.add(vehicleModel);
      }
      return vehicles;
    });
  }

  static updateStatus(bool isDone, documentId) {
    firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('vehicles')
        .doc(documentId)
        .update(
      {
        'isDone': isDone,
      },
    );
  }

  static deleteTodo(String documentId) {
    firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('vehicles')
        .doc(documentId)
        .delete();
  }

  static void sendPushMessage(
      String receiverUserId, String body, String title) async {
    try {
      UserModel receiverUser = await firebaseFirestore
          .doc('/users/${receiverUserId}')
          .get()
          .then((documentSnapshot) =>
              UserModel.fromMap(documentSnapshot.data()!));

      print(receiverUserId);
      print(receiverUser.email);
      print(receiverUser.deviceToken);
      var d = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA_bNvtJU:APA91bEmoElLJDG0RtcbX6o4NsDtzfuc0fYwQwwiIbboUnMr9Dn_IRWxexrtfEg8LdUhZcEHZzKcbEm-WTe8SIRkDAnnh6ihcSrimLCQpLxbw5eUYmJCBxYeYjMltUimmYQy6QIVs2eY',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'payload': {"name": "flutter"}
            },
            'priority': 'high',
            'contentAvailable': true,
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": receiverUser.deviceToken,
          },
        ),
      );
      print(d.body);
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }

  static void setLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await geoFirestore.setLocation(
        auth.currentUser!.uid, GeoPoint(position.latitude, position.longitude));
  }
}
