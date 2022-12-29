import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pickupjob/ui/components/components.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import '../../constants.dart';
import '../../controllers/controllers.dart';
import '../../helpers/firestore_db.dart';
import '../../models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class inProgressJobsStepsUser extends StatefulWidget {
  const inProgressJobsStepsUser({super.key});

  @override
  State<inProgressJobsStepsUser> createState() =>
      _inProgressJobsStepsUserState();
}

class _inProgressJobsStepsUserState extends State<inProgressJobsStepsUser> {
  final PickUpJobController pickUpJobController = PickUpJobController.to;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  dynamic argumentData = Get.arguments;
  final ImagePicker _picker = ImagePicker();

  late PickUpJobModel pickUpJobModel;

  Future<String> uploadImageToFirebase() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    var imageFile = File(image!.path);
    String fileName = basename(imageFile.path);
    showLoadingIndicator();
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child("images/$fileName");
      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();
      print(url);
      hideLoadingIndicator();
      return url;
    } on FirebaseException catch (e) {
      hideLoadingIndicator();
      return "";
      // e.g, e.code == 'canceled'
    }
  }

  @override
  void initState() {
//     setState(() {
//       pickUpJobModel = PickUpJobModel(
//         uid: argumentData["uid"],
//         uname: argumentData["uname"],
//         title: argumentData["title"],
//         inputMethod: argumentData["inputMethod"],
//         barCodeItemNumber: argumentData["barCodeItemNumber"],
//         barCodeItem: argumentData["barCodeItem"],
//         weight: argumentData["weight"],
//         length: argumentData["length"],
//         height: argumentData["height"],
//         numberOfItem: argumentData["numberOfItem"],
//         itemImage: argumentData["itemImage"],
//         needLoadUnload: argumentData["needLoadUnload"],
//         needLoadUnloadTime: argumentData["needLoadUnloadTime"],

//         //pick Addreess

//         pickLat: argumentData["pickLat"] as double,
//         pickLan: argumentData["pickLan"] as double,
//         pickAddress: argumentData["pickAddress"],
//         pickState: argumentData["pickState"],
//         pickCity: argumentData["pickCity"],
//         pickZip: argumentData["pickZip"],

// //drop
//         dropLat: argumentData["dropLat"] as double,
//         dropLan: argumentData["dropLan"] as double,
//         dropAddress: argumentData["dropAddress"],
//         dropState: argumentData["dropState"],
//         dropCity: argumentData["dropCity"],
//         dropZip: argumentData["dropZip"],

// //Contact Person
//         contactPersonName: argumentData["contactPersonName"],
//         contactPersonMobile: argumentData["contactPersonMobile"],
//         contactPersonAlternateMobile:
//             argumentData["contactPersonAlternateMobile"],
//         dateForPickup: argumentData["dateForPickup"],
//         timeForPickupLoad: argumentData["timeForPickupLoad"],
//         isAutoBid: argumentData["isAutoBid"],
//         autoBidStartDateTime: argumentData["autoBidStartDateTime"],
//         createdon: argumentData["createdon"],
//         isDone: argumentData["isDone"],
//         status: argumentData["status"],
//         bid_id: argumentData['bid_id'],
//         driver_id: argumentData['driver_id'],
//         driver_name: argumentData['driver_name'],
//         vehicle_id: argumentData['vehicle_id'],
//         vehicle_name: argumentData['vehicle_name'],
//         amount: argumentData['amount'],

//         // after pickup start

//         driver_on_way_to_pickup: argumentData["driver_on_way_to_pickup"],
//         driver_at_pickup_location: argumentData["driver_at_pickup_location"],
//         user_picture_of_driver_with_driver_id:
//             argumentData["user_picture_of_driver_with_driver_id"],
//         driver_image_of_pickup_job: argumentData["driver_image_of_pickup_job"],
//         driver_image_of_pickup_job_on_truck:
//             argumentData["driver_image_of_pickup_job_on_truck"],

//         driver_confirm_pickup_job: argumentData["driver_confirm_pickup_job"],
//         user_confirm_pickup_job: argumentData["user_confirm_pickup_job"],
//         driver_at_drop_off_loaction:
//             argumentData["driver_at_drop_off_loaction"],
//         driver_pickupjob_delivered: argumentData["driver_pickupjob_delivered"],
//         user_release_payment: argumentData["user_release_payment"],
//         rating_to_driver: argumentData["rating_to_driver"],
//         rating_to_user: argumentData["rating_to_user"],
//         review_for_customer: argumentData["review_for_customer"],
//         review_for_user: argumentData["review_for_user"],
//       );
//     });
    // loadData(false);
    // TODO: implement initState
    super.initState();
  }

  // loadData(isBack) async {
  //   pickUpJobModel =
  //       await pickUpJobController.getJobByJobId(argumentData['id']);
  //   pickUpJobModel.id = argumentData['id'];
  //   setState(() {
  //     pickUpJobModel = pickUpJobModel;
  //   });
  //   setState(() {});
  //   if (isBack) {
  //     Get.back();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebaseFirestore
            .collection('pickupjobs')
            .doc(argumentData['id'])
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          PickUpJobModel pickUpJobModel = PickUpJobModel.fromDocumentSnapshot(
              documentSnapshot: snapshot.data!);

          return Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.black87,
                title: Text(pickUpJobModel.title.toString()),
                actions: [
                  IconButton(
                      icon: const Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        UserModel user = await _db
                            .doc('/users/${pickUpJobModel.uid}')
                            .get()
                            .then((documentSnapshot) =>
                                UserModel.fromMap(documentSnapshot.data()!));
                        UserModel driver = await _db
                            .doc('/users/${pickUpJobModel.driver_id}')
                            .get()
                            .then((documentSnapshot) =>
                                UserModel.fromMap(documentSnapshot.data()!));

                        ChatListModel chatListModel = ChatListModel(
                            chat_id: argumentData['id'].toString() +
                                '_' +
                                pickUpJobModel.uid.toString() +
                                '_' +
                                pickUpJobModel.driver_id
                                    .toString(), //jobid_userid_driverid
                            user_id: pickUpJobModel.uid,
                            user_name: pickUpJobModel.uname,
                            user_image: user.photoUrl,
                            driver_id: pickUpJobModel.driver_id,
                            driver_name: pickUpJobModel.driver_name,
                            driver_image: driver.photoUrl,
                            job_id: argumentData['id'],
                            job_title: pickUpJobModel.title,
                            status: '1',
                            updatedon: DateTime.now(),
                            createdon: DateTime.now());

                        await FirestoreDb.addChatList(chatListModel);
                      })
                ],
              ),
              body: Container(
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    (pickUpJobModel.driver_on_way_to_pickup == 'Yes' &&
                            pickUpJobModel.driver_at_pickup_location != 'Yes')
                        ? Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border:
                                    Border.all(width: 1.0, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: Container(
                              child: Text(
                                'Driver is On the Way to pickup',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )))
                        : Container(),
                    (pickUpJobModel.driver_on_way_to_pickup == 'Yes' &&
                            pickUpJobModel.driver_at_pickup_location == 'Yes')
                        ? Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border:
                                    Border.all(width: 1.0, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: Container(
                              child: Text(
                                'Driver at Pickup Location',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )))
                        : Container(),
                    (pickUpJobModel.driver_at_pickup_location == 'Yes' &&
                            pickUpJobModel.user_picture_of_driver_with_driver_id
                                    .toString()
                                    .length <
                                5)
                        ? Container(
                            padding: EdgeInsets.all(15),
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border:
                                    Border.all(width: 1.0, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.black,
                                  height: 60,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(top: 20, bottom: 10),
                                  child: Text(
                                    'Image of Driver With Driver Id',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 100,
                                  width: double.infinity,
                                  child: InkWell(
                                    child: Image.network(
                                      (pickUpJobModel
                                                  .user_picture_of_driver_with_driver_id
                                                  .toString()
                                                  .length <
                                              5)
                                          ? "https://cdn-icons-png.flaticon.com/512/4653/4653792.png"
                                          : pickUpJobModel
                                              .user_picture_of_driver_with_driver_id
                                              .toString(),
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                    onTap: () async {
                                      String url =
                                          await uploadImageToFirebase();
                                      pickUpJobModel.id = argumentData['id'];

                                      PickUpJobModel pickUpJob =
                                          await pickUpJobController
                                              .getJobByJobId(
                                                  argumentData['id']);

                                      pickUpJob.id = argumentData['id'];

                                      pickUpJob
                                              .user_picture_of_driver_with_driver_id =
                                          url;

                                      await FirestoreDb.updatePickUpJobSteps(
                                          pickUpJob);
                                      // await loadData(true);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    (pickUpJobModel.user_picture_of_driver_with_driver_id
                                .toString()
                                .length >
                            5)
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border:
                                    Border.all(width: 1.0, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Image.network(
                              pickUpJobModel
                                  .user_picture_of_driver_with_driver_id
                                  .toString(),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                    (pickUpJobModel.user_picture_of_driver_with_driver_id
                                    .toString()
                                    .length >
                                5 &&
                            pickUpJobModel.user_confirm_pickup_job != 'Yes')
                        ? Container(
                            height: 100,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                border:
                                    Border.all(width: 1.0, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: InkWell(
                              child: Container(
                                  child: Text(
                                'Confirm  Pickup Job',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                              onTap: (() {
                                confirmPickupJob();
                              }),
                            )))
                        : Container(),
                    (pickUpJobModel.user_confirm_pickup_job == 'Yes')
                        ? Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border:
                                    Border.all(width: 1.0, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: Text('Pickup Job is confirmed ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          )
                        : Container(),
                    (pickUpJobModel.user_confirm_pickup_job == 'Yes')
                        ? Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border:
                                    Border.all(width: 1.0, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: Text(
                                    'Driver is on the way to dropoff your pickup job',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          )
                        : Container(),
                    (pickUpJobModel.driver_at_drop_off_loaction == 'Yes')
                        ? Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border:
                                    Border.all(width: 1.0, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: Text(
                                    'Driver at the drop off site and deliver the picjup job',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          )
                        : Container(),
                    (pickUpJobModel.driver_at_drop_off_loaction == 'Yes' &&
                            pickUpJobModel.driver_pickupjob_delivered == 'Yes')
                        ? Container(
                            height: 100,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                border:
                                    Border.all(width: 1.0, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: InkWell(
                              child: Container(
                                  child: Text(
                                'Release Payment',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                              onTap: (() {
                                //  confirmPickupJob();
                              }),
                            )))
                        : Container(),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 1.0, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Pick Address",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                          ),
                          Divider(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              pickUpJobModel.pickAddress.toString() +
                                  '\n' +
                                  pickUpJobModel.pickCity.toString() +
                                  '\n' +
                                  pickUpJobModel.pickState.toString() +
                                  '\n' +
                                  pickUpJobModel.pickZip.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 1.0, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Drop Address",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                          ),
                          Divider(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              pickUpJobModel.dropAddress.toString() +
                                  '\n' +
                                  pickUpJobModel.dropCity.toString() +
                                  '\n' +
                                  pickUpJobModel.dropState.toString() +
                                  '\n' +
                                  pickUpJobModel.dropZip.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(width: 1.0, color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Contact Person Name",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                pickUpJobModel.contactPersonName.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          Divider(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Contact Person Mobile",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                pickUpJobModel.contactPersonMobile.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          Divider(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Contact Alternate Mobile",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                pickUpJobModel.contactPersonAlternateMobile
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ])),
                  ],
                ),
              ));
        });
  }

  confirmPickupJob() {
    Get.defaultDialog(
        title: 'Are you sure?',
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Container(
                margin: EdgeInsets.all(5),
                width: 100,
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Center(
                    child: Text(
                  'Canecl',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              onTap: () {
                Get.back();
              },
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                width: 140,
                color: Colors.green,
                child: Center(
                    child: Text(
                  'Confirm  Pickup Job',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              onTap: () async {
                PickUpJobModel pickUpJob =
                    await pickUpJobController.getJobByJobId(argumentData['id']);

                pickUpJob.id = argumentData['id'];
                pickUpJob.user_confirm_pickup_job = 'Yes';
                await FirestoreDb.updatePickUpJobSteps(pickUpJob);

                FirestoreDb.sendPushMessage(
                    pickUpJob.driver_id.toString(),
                    pickUpJob.uname.toString() +
                        ' Confirmed, Job loaded successfully' +
                        pickUpJob.title.toString(),
                    'Confirmed, Job loaded successfully');

                Get.back();

                // await loadData(true);

                setState(() {});
              },
            )
          ],
        ),
        radius: 10.0);
  }
}
