import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/helpers/firestore_db.dart';
import 'package:pickupjob/models/models.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../constants.dart';
import '../ui.dart';

class listProposalsUser extends StatefulWidget {
  const listProposalsUser({super.key});

  @override
  State<listProposalsUser> createState() => _listProposalsUserState();
}

class _listProposalsUserState extends State<listProposalsUser> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) => controller.firestoreUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.offAll(const userHome()),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.black87,
                  title: const Text('Bids'),
                ),
                body: GetX<BidController>(
                  init: Get.put<BidController>(BidController()),
                  builder: (BidController bidController) {
                    return Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: bidController.bidsUser.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(bidController.bidsUser[index]);
                          final bidsData = bidController.bidsUser[index];
                          return Container(
                              padding: const EdgeInsets.all(10),
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                border: Border(
                                  bottom: BorderSide(
                                      width: 1.5,
                                      color: Color.fromARGB(24, 255, 255, 255)),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    24, 255, 255, 255))),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Image.network(
                                          bidsData.selected_vehicle_picture
                                              .toString(),
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
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
                                      ),
                                      Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                50,
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(bidsData.job_title.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(
                                                bidsData.year.toString() +
                                                    ' ' +
                                                    bidsData.make.toString() +
                                                    ' ' +
                                                    bidsData.model.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            const Divider(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Insurance Verified",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: Colors.green),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Vehicle Verified",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: Colors.green),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Identity Verified",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: Colors.green),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Bid Amount: "),
                                          Text(
                                            '\$' +
                                                bidsData.bid_amount.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.green[800]),
                                          )
                                        ],
                                      ),
                                      IconButton(
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            PickUpJobModel pickupjob = await _db
                                                .doc(
                                                    '/pickupjobs/${bidsData.job_id}')
                                                .get()
                                                .then((documentSnapshot) =>
                                                    PickUpJobModel.fromMap(
                                                        documentSnapshot
                                                            .data()!));

                                            print(pickupjob.title);

                                            Get.to(
                                                () =>
                                                    const ProposalsAcceptReject(),
                                                arguments: {
                                                  'pickupjob': pickupjob,
                                                  'bidsData': bidsData
                                                });

                                            //  Get.to(ProposalsAcceptReject());
                                          }),
                                    ],
                                  ),
                                  (bidsData.status == "applied")
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                    color: Colors.white),
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2) -
                                                    30,
                                                child: Text('Reject',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black)),
                                              ),
                                              onTap: () async {
                                                bidsData.status = 'Rejected';
                                                await FirestoreDb.editBidS(
                                                    bidsData);
                                              },
                                            ),
                                            InkWell(
                                                onTap: () async {
                                                  bidsData.status = 'Accepted';
                                                  await FirestoreDb.editBidS(
                                                      bidsData);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                      color: Colors.green[800]),
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2) -
                                                      30,
                                                  child: Text(
                                                    'Accept',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          ],
                                        )
                                      : Container(),
                                  (bidsData.status == "Accepted")
                                      ? Container(
                                          margin: EdgeInsets.all(5),
                                          padding: EdgeInsets.all(10),
                                          color: Colors.white,
                                          child: InkWell(
                                            child: Center(
                                              child: Text('Hire Now',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            onTap: () async {
                                              PickUpJobModel pickupjob = await _db
                                                  .doc(
                                                      '/pickupjobs/${bidsData.job_id}')
                                                  .get()
                                                  .then((documentSnapshot) =>
                                                      PickUpJobModel.fromMap(
                                                          documentSnapshot
                                                              .data()!));

                                              hireNow(bidsData, pickupjob);
                                            },
                                          ),
                                        )
                                      : Container(),
                                  Divider(
                                    height: 15,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    decoration:
                                        BoxDecoration(color: Colors.blue[800]),
                                    padding: EdgeInsets.all(15),
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        child: Center(
                                            child: Text(
                                          'Message',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      onTap: () async {
                                        UserModel user = await _db
                                            .doc('/users/${bidsData.user_id}')
                                            .get()
                                            .then((documentSnapshot) =>
                                                UserModel.fromMap(
                                                    documentSnapshot.data()!));
                                        UserModel driver = await _db
                                            .doc('/users/${bidsData.driver_id}')
                                            .get()
                                            .then((documentSnapshot) =>
                                                UserModel.fromMap(
                                                    documentSnapshot.data()!));

                                        ChatListModel chatListModel =
                                            ChatListModel(
                                                chat_id: bidsData.job_id
                                                        .toString() +
                                                    '_' +
                                                    bidsData.user_id
                                                        .toString() +
                                                    '_' +
                                                    bidsData.driver_id
                                                        .toString(), //jobid_userid_driverid
                                                user_id: bidsData.user_id,
                                                user_name: bidsData.user_name,
                                                user_image: user.photoUrl,
                                                driver_id: bidsData.driver_id,
                                                driver_name:
                                                    bidsData.driver_name,
                                                driver_image: driver.photoUrl,
                                                job_id: bidsData.job_id,
                                                job_title: bidsData.job_title,
                                                status: '1',
                                                updatedon: DateTime.now(),
                                                createdon: DateTime.now());

                                        await FirestoreDb.addChatList(
                                            chatListModel);
                                        print({
                                          "chat_id": bidsData.job_id
                                                  .toString() +
                                              '_' +
                                              bidsData.user_id.toString() +
                                              '_' +
                                              bidsData.driver_id
                                                  .toString(), //jobid_userid_driverid
                                          "user_id": bidsData.user_id,
                                          "user_name": bidsData.user_name,
                                          "user_image": user.photoUrl,
                                          "driver_id": bidsData.driver_id,
                                          "driver_name": bidsData.driver_name,
                                          "driver_image": driver.photoUrl,
                                          "job_id": bidsData.job_id,
                                          "job_title": bidsData.job_title,
                                          "status": '1',
                                          "updatedon": DateTime.now(),
                                          "createdon": DateTime.now()
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ));
                        },
                      ),
                    );
                  },
                )));
  }

  hireNow(BidModel bidsData, PickUpJobModel pickupjob) {
    Get.defaultDialog(
        title: 'Hire Now',
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Container(
                margin: EdgeInsets.all(5),
                width: 120,
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
                width: 120,
                color: Colors.green,
                child: Center(
                    child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              onTap: () async {
                bidsData.status = 'Hired';

                pickupjob.bid_id = bidsData.id;
                pickupjob.driver_id = bidsData.driver_id;
                pickupjob.driver_name = bidsData.driver_name;
                pickupjob.vehicle_id = bidsData.selected_vehicle;
                pickupjob.vehicle_name = bidsData.selected_vehicle_title;
                pickupjob.status = "In Progress";

                pickupjob.amount = int.parse(bidsData.bid_amount as String);
                print(bidsData.job_id);
                await FirestoreDb.hire(bidsData, pickupjob);
              },
            )
          ],
        ),
        radius: 10.0);
  }
}
