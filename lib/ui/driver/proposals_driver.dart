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

import '../ui.dart';

class listProposalsDriver extends StatefulWidget {
  const listProposalsDriver({super.key});

  @override
  State<listProposalsDriver> createState() => _listProposalsDriverState();
}

class _listProposalsDriverState extends State<listProposalsDriver> {
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
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.offAll(driverHome()),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.black87,
                  title: Text('Bids'),
                ),
                body: GetX<BidController>(
                  init: Get.put<BidController>(BidController()),
                  builder: (BidController bidController) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: bidController.bids.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(bidController.bids[index]);
                          final bidsData = bidController.bids[index];
                          return Container(
                              padding: EdgeInsets.all(15),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        bidsData.job_title.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          (bidsData.status!.toUpperCase() ==
                                                      'ACCEPTED' ||
                                                  bidsData.status!
                                                          .toUpperCase() ==
                                                      'HIRED')
                                              ? IconButton(
                                                  icon: const Icon(
                                                    Icons.message,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    UserModel user = await _db
                                                        .doc(
                                                            '/users/${bidsData.user_id}')
                                                        .get()
                                                        .then((documentSnapshot) =>
                                                            UserModel.fromMap(
                                                                documentSnapshot
                                                                    .data()!));
                                                    UserModel driver = await _db
                                                        .doc(
                                                            '/users/${bidsData.driver_id}')
                                                        .get()
                                                        .then((documentSnapshot) =>
                                                            UserModel.fromMap(
                                                                documentSnapshot
                                                                    .data()!));

                                                    ChatListModel
                                                        chatListModel =
                                                        ChatListModel(
                                                            chat_id: bidsData
                                                                    .job_id
                                                                    .toString() +
                                                                '_' +
                                                                bidsData.user_id
                                                                    .toString() +
                                                                '_' +
                                                                bidsData
                                                                    .driver_id
                                                                    .toString(), //jobid_userid_driverid
                                                            user_id: bidsData
                                                                .user_id,
                                                            user_name: bidsData
                                                                .user_name,
                                                            user_image:
                                                                user.photoUrl,
                                                            driver_id: bidsData
                                                                .driver_id,
                                                            driver_name: bidsData
                                                                .driver_name,
                                                            driver_image:
                                                                driver.photoUrl,
                                                            job_id:
                                                                bidsData.job_id,
                                                            job_title: bidsData
                                                                .job_title,
                                                            status: '1',
                                                            updatedon:
                                                                DateTime.now(),
                                                            createdon:
                                                                DateTime.now());

                                                    await FirestoreDb
                                                        .addChatList(
                                                            chatListModel);
                                                  })
                                              : Container(),
                                          IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                // Get.to(addVehicle());
                                              })
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(bidsData.createdon.toString()),
                                      Text(bidsData.status!.toUpperCase())
                                    ],
                                  )
                                ],
                              ));
                        },
                      ),
                    );
                  },
                )));
  }
}
