import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pickupjob/helpers/common_helper.dart';
import '../../controllers/controllers.dart';
import '../ui.dart';

class TabSearchDriver extends StatefulWidget {
  const TabSearchDriver({super.key});

  @override
  State<TabSearchDriver> createState() => _TabSearchDriverState();
}

class _TabSearchDriverState extends State<TabSearchDriver> {
  int radius = 30;
  TextEditingController radiusController = TextEditingController();

  @override
  void initState() {
    radiusController.text = radius.toString();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) => controller.firestoreUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                child: Stack(
                  children: [
                    GetX<PickUpJobController>(
                      init: Get.put<PickUpJobController>(PickUpJobController()),
                      builder: (PickUpJobController pickUpJobController) {
                        return Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                          ),
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount:
                                pickUpJobController.pickupSearchjobs.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(
                                  pickUpJobController.pickupSearchjobs[index]);
                              final pickupjobData =
                                  pickUpJobController.pickupSearchjobs[index];
                              return Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  // padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    // borderRadius: BorderRadius.circular(4),

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
                                          Text(
                                            pickupjobData.title.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  icon: const Icon(
                                                    Icons.remove_red_eye,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Get.to(
                                                        () => ViewJobDriver(),
                                                        arguments: {
                                                          'id':
                                                              pickupjobData.id,
                                                          'uid':
                                                              pickupjobData.uid,
                                                          'uname': pickupjobData
                                                              .uname,
                                                          'title': pickupjobData
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
                                                        });

                                                    //Get.to(addVehicle());
                                                  }),
                                            ],
                                          ),
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
                                                            24,
                                                            255,
                                                            255,
                                                            255))),
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
                                                )),
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
                                                            'yyyy-MM-dd – kk:mm')
                                                        .format(pickupjobData
                                                            .createdon!))),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15, top: 10),
                                                  child: Text(
                                                    " Height: " +
                                                        pickupjobData.height
                                                            .toString() +
                                                        ' Feet \n' +
                                                        " Weight: " +
                                                        pickupjobData.weight
                                                            .toString() +
                                                        ' Pound \n' +
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
                                                            .toStringAsFixed(
                                                                2) +
                                                        ' KM')),
                                              ],
                                            )
                                          ]),
                                    ],
                                  ));
                            },
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink, // inner circle color
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.filter_alt_outlined,
                              color: Colors.white,
                            ),
                            highlightColor: Colors.pink,
                            onPressed: () {
                              Get.defaultDialog(
                                  title: '',
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: radiusController,
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            labelText: 'Search Radius (KM)',
                                            hintMaxLines: 1,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.green,
                                                    width: 4.0))),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.pink)),
                                        onPressed: () {
                                          if (radiusController.text != '' &&
                                              int.parse(radiusController.text) >
                                                  0) {
                                            setState(() {
                                              radius = int.parse(
                                                  radiusController.text);
                                            });
                                            Get.back();
                                          }
                                        },
                                        child: const Text(
                                          'Update',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                  radius: 10.0);
                            },
                          )), //CircularAvatar
                    ),
                  ],
                )));
  }
}
