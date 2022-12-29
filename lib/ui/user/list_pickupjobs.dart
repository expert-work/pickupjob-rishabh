import 'package:flutter/material.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:get/get.dart';
import 'package:pickupjob/helpers/firestore_db.dart';

import '../ui.dart';

class ListPickUpJob extends StatefulWidget {
  const ListPickUpJob({super.key});

  @override
  State<ListPickUpJob> createState() => _ListPickUpJobState();
}

class _ListPickUpJobState extends State<ListPickUpJob> {
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
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.black87,
                  title: Text('My Jobs'),
                  actions: [
                    IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.to(addPickupJobs());
                        }),
                  ],
                ),
                body: GetX<PickUpJobController>(
                  init: Get.put<PickUpJobController>(PickUpJobController()),
                  builder: (PickUpJobController pickUpJobController) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: pickUpJobController.pickupOpenjobs.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(pickUpJobController.pickupOpenjobs[index]);
                          final pickupjobData =
                              pickUpJobController.pickupOpenjobs[index];
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
                                      Container(
                                        child: Text(
                                          pickupjobData.title.toString(),
                                          style: TextStyle(
                                              overflow: TextOverflow.clip,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        width: 96,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                icon: const Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Get.to(() => editPickupJobs(),
                                                      arguments: {
                                                        'id': pickupjobData.id,
                                                        'uid':
                                                            pickupjobData.uid,
                                                        'uname':
                                                            pickupjobData.uname,
                                                        'title':
                                                            pickupjobData.title,
                                                        'inputMethod':
                                                            pickupjobData
                                                                .inputMethod,
                                                        'barCodeItemNumber':
                                                            pickupjobData
                                                                .barCodeItemNumber,
                                                        'barCodeItem':
                                                            pickupjobData
                                                                .barCodeItem,
                                                        'weight': pickupjobData
                                                            .weight,
                                                        'length': pickupjobData
                                                            .length,
                                                        'height': pickupjobData
                                                            .height,
                                                        'numberOfItem':
                                                            pickupjobData
                                                                .numberOfItem,
                                                        'itemImage':
                                                            pickupjobData
                                                                .itemImage,
                                                        'needLoadUnload':
                                                            pickupjobData
                                                                .needLoadUnload,
                                                        'needLoadUnloadTime':
                                                            pickupjobData
                                                                .needLoadUnloadTime,

//pick Addreess

                                                        'pickLat': pickupjobData
                                                            .pickLat,
                                                        'pickLan': pickupjobData
                                                            .pickLan,
                                                        'pickAddress':
                                                            pickupjobData
                                                                .pickAddress,
                                                        'pickState':
                                                            pickupjobData
                                                                .pickState,
                                                        'pickCity':
                                                            pickupjobData
                                                                .pickCity,
                                                        'pickZip': pickupjobData
                                                            .pickZip,

//drop
                                                        'dropLat': pickupjobData
                                                            .dropLat,
                                                        'dropLan': pickupjobData
                                                            .dropLan,
                                                        'dropAddress':
                                                            pickupjobData
                                                                .dropAddress,
                                                        'dropState':
                                                            pickupjobData
                                                                .dropState,
                                                        'dropCity':
                                                            pickupjobData
                                                                .dropCity,
                                                        'dropZip': pickupjobData
                                                            .dropZip,

//Contact Person
                                                        'contactPersonName':
                                                            pickupjobData
                                                                .contactPersonName,
                                                        'contactPersonMobile':
                                                            pickupjobData
                                                                .contactPersonMobile,
                                                        'contactPersonAlternateMobile':
                                                            pickupjobData
                                                                .contactPersonAlternateMobile,
                                                        'dateForPickup':
                                                            pickupjobData
                                                                .dateForPickup,
                                                        'timeForPickupLoad':
                                                            pickupjobData
                                                                .timeForPickupLoad,
                                                        'isAutoBid':
                                                            pickupjobData
                                                                .isAutoBid,
                                                        'autoBidStartDateTime':
                                                            pickupjobData
                                                                .autoBidStartDateTime,
                                                        'createdon':
                                                            pickupjobData
                                                                .createdon,
                                                        'isDone': pickupjobData
                                                            .isDone,
                                                        'status': pickupjobData
                                                            .status,
                                                        "driver_on_way_to_pickup":
                                                            pickupjobData
                                                                .driver_on_way_to_pickup,
                                                        "driver_at_pickup_location":
                                                            pickupjobData
                                                                .driver_at_pickup_location,
                                                        "user_picture_of_driver_with_driver_id":
                                                            pickupjobData
                                                                .user_picture_of_driver_with_driver_id,
                                                        "driver_image_of_pickup_job":
                                                            pickupjobData
                                                                .driver_image_of_pickup_job,
                                                        "driver_image_of_pickup_job_on_truck":
                                                            pickupjobData
                                                                .driver_image_of_pickup_job_on_truck,
                                                        "user_confirm_pickup_job":
                                                            pickupjobData
                                                                .user_confirm_pickup_job,
                                                        "driver_at_drop_off_loaction":
                                                            pickupjobData
                                                                .driver_at_drop_off_loaction,
                                                        "driver_pickupjob_delivered":
                                                            pickupjobData
                                                                .driver_pickupjob_delivered,
                                                        "user_release_payment":
                                                            pickupjobData
                                                                .user_release_payment,
                                                        "rating_to_driver":
                                                            pickupjobData
                                                                .rating_to_driver,
                                                        "rating_to_user":
                                                            pickupjobData
                                                                .rating_to_user,
                                                        "review_for_customer":
                                                            pickupjobData
                                                                .review_for_customer,
                                                        "review_for_user":
                                                            pickupjobData
                                                                .review_for_user,
                                                      });
                                                  Get.to(editPickupJobs());
                                                }),
                                            IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  confirmPickupJobDelete(
                                                      pickupjobData.id);
                                                }),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 10,
                                  ),
                                  Image.network(
                                    pickupjobData.itemImage.toString(),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
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
                                ],
                              ));
                        },
                      ),
                    );
                  },
                )));
  }

  confirmPickupJobDelete(job_id) {
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
                  'Delete',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              onTap: () async {
                FirestoreDb.deletePickupJobs(job_id);
                Get.back();
              },
            )
          ],
        ),
        radius: 10.0);
  }
}
