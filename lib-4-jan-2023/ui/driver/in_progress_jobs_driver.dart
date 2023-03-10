import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pickupjob/helpers/common_helper.dart';

import '../../controllers/controllers.dart';
import '../ui.dart';

class inProgressJobsDriver extends StatefulWidget {
  const inProgressJobsDriver({super.key});

  @override
  State<inProgressJobsDriver> createState() => _inProgressJobsDriverState();
}

class _inProgressJobsDriverState extends State<inProgressJobsDriver> {
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
                  title: Text("Jobs In Progress"),
                ),
                body: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                    ),
                    child: GetX<PickUpJobController>(
                      init: Get.put<PickUpJobController>(PickUpJobController()),
                      builder: (PickUpJobController pickUpJobController) {
                        return Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                          ),
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: pickUpJobController
                                .pickupInProgressjobsDriver.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(pickUpJobController
                                  .pickupInProgressjobsDriver[index]);
                              final pickupjobData = pickUpJobController
                                  .pickupInProgressjobsDriver[index];

                              return Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1.5,
                                          color: Color.fromARGB(
                                              24, 255, 255, 255)),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    2 /
                                                    3 -
                                                80,
                                            child: Text(
                                              pickupjobData.title.toString(),
                                              style: TextStyle(
                                                  overflow: TextOverflow.clip,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3 +
                                                10,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                    icon: const Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () => {
                                                          Get.to(
                                                              () =>
                                                                  inProgressJobsStepsDriver(),
                                                              arguments: {
                                                                'id':
                                                                    pickupjobData
                                                                        .id,
                                                                'uid':
                                                                    pickupjobData
                                                                        .uid,
                                                                'uname':
                                                                    pickupjobData
                                                                        .uname,
                                                                'title':
                                                                    pickupjobData
                                                                        .title,
                                                                'inputMethod':
                                                                    pickupjobData
                                                                        .inputMethod,
                                                                'barCodeItemNumber':
                                                                    pickupjobData
                                                                        .barCodeItemNumber,
                                                                'barCodeItem':
                                                                    pickupjobData
                                                                        .barCodeItem,
                                                                'weight':
                                                                    pickupjobData
                                                                        .weight,
                                                                'length':
                                                                    pickupjobData
                                                                        .length,
                                                                'height':
                                                                    pickupjobData
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

                                                                'pickLat':
                                                                    pickupjobData
                                                                        .pickLat,
                                                                'pickLan':
                                                                    pickupjobData
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
                                                                'pickZip':
                                                                    pickupjobData
                                                                        .pickZip,

//drop
                                                                'dropLat':
                                                                    pickupjobData
                                                                        .dropLat,
                                                                'dropLan':
                                                                    pickupjobData
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
                                                                'dropZip':
                                                                    pickupjobData
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
                                                                'isDone':
                                                                    pickupjobData
                                                                        .isDone,
                                                                'status':
                                                                    pickupjobData
                                                                        .status,
                                                              })

                                                          //Get.to(addVehicle());
                                                        }),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        24, 255, 255, 255))),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                5,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Image.network(
                                              pickupjobData.itemImage
                                                  .toString(),
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15, top: 15),
                                                  child: Text(pickupjobData
                                                      .barCodeItem
                                                      .toString())),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15, top: 5),
                                                  child: Text(DateFormat(
                                                          'yyyy-MM-dd ??? kk:mm')
                                                      .format(pickupjobData
                                                          .createdon!))),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 15, top: 10),
                                                child: Text(
                                                  " Height: " +
                                                      pickupjobData.height
                                                          .toString() +
                                                      'Feet \n' +
                                                      " Weight: " +
                                                      pickupjobData.weight
                                                          .toString() +
                                                      'Pound \n' +
                                                      " Length: " +
                                                      pickupjobData.length
                                                          .toString() +
                                                      ' Feet',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15, top: 10),
                                                  child: Text(CommonHelper
                                                              .calculateDistance(
                                                                  pickupjobData
                                                                      .pickLat,
                                                                  pickupjobData
                                                                      .pickLan,
                                                                  pickupjobData
                                                                      .dropLat,
                                                                  pickupjobData
                                                                      .dropLan)
                                                          .toStringAsFixed(2) +
                                                      ' KM')),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        );
                      },
                    ))));
  }
}
