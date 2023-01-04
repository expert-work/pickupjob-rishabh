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
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          decoration: const BoxDecoration(
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
                                  margin: const EdgeInsets.only(bottom: 20),
                                  // padding: EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      // Row for the Job Name and the view job button.
                                      Text(
                                        'Created on ${DateFormat('dd-MM-yyyy').format(pickupjobData.createdon!).replaceAll('-', '/')} | ${CommonHelper.calculateDistance(pickupjobData.pickLat, pickupjobData.pickLan, pickupjobData.dropLat, pickupjobData.dropLan).toStringAsFixed(2)} KM away',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              pickupjobData.title.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          IconButton(
                                              icon: const Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                Get.to(
                                                    () => const ViewJobDriver(),
                                                    arguments: {
                                                      'id': pickupjobData.id,
                                                      'uid': pickupjobData.uid,
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
                                                      'weight':
                                                          pickupjobData.weight,
                                                      'length':
                                                          pickupjobData.length,
                                                      'height':
                                                          pickupjobData.height,
                                                      'numberOfItem':
                                                          pickupjobData
                                                              .numberOfItem,
                                                      'itemImage': pickupjobData
                                                          .itemImage,
                                                      'needLoadUnload':
                                                          pickupjobData
                                                              .needLoadUnload,
                                                      'needLoadUnloadTime':
                                                          pickupjobData
                                                              .needLoadUnloadTime,

//pick Addreess

                                                      'pickLat':
                                                          pickupjobData.pickLat,
                                                      'pickLan':
                                                          pickupjobData.pickLan,
                                                      'pickAddress':
                                                          pickupjobData
                                                              .pickAddress,
                                                      'pickState': pickupjobData
                                                          .pickState,
                                                      'pickCity': pickupjobData
                                                          .pickCity,
                                                      'pickZip':
                                                          pickupjobData.pickZip,

//drop
                                                      'dropLat':
                                                          pickupjobData.dropLat,
                                                      'dropLan':
                                                          pickupjobData.dropLan,
                                                      'dropAddress':
                                                          pickupjobData
                                                              .dropAddress,
                                                      'dropState': pickupjobData
                                                          .dropState,
                                                      'dropCity': pickupjobData
                                                          .dropCity,
                                                      'dropZip':
                                                          pickupjobData.dropZip,

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
                                                      'isAutoBid': pickupjobData
                                                          .isAutoBid,
                                                      'autoBidStartDateTime':
                                                          pickupjobData
                                                              .autoBidStartDateTime,
                                                      'createdon': pickupjobData
                                                          .createdon,
                                                      'isDone':
                                                          pickupjobData.isDone,
                                                      'status':
                                                          pickupjobData.status,
                                                    });

                                                //Get.to(addVehicle());
                                              }),
                                        ],
                                      ),
                                      // Job date and Distance row -->
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Wrap(
                                            children: [
                                              const Text('Job Date: '),
                                              Text(
                                                DateFormat('dd-yyyy')
                                                    .format(pickupjobData
                                                        .createdon!)
                                                    .replaceAll('-', '/'),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Wrap(
                                            children: [
                                              const Text('Total Distance:'),
                                              Text(
                                                ' ${CommonHelper.calculateDistance(pickupjobData.pickLat, pickupjobData.pickLan, pickupjobData.dropLat, pickupjobData.dropLan).toStringAsFixed(2)} KM',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      // Job Price Text -->
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Wrap(
                                          children: const [
                                            Text('Price: '),
                                            Text(
                                              '\$0.00',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                      // Column for the Product Details -->
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Image Container -->
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color:
                                                            const Color.fromARGB(
                                                                24,
                                                                255,
                                                                255,
                                                                255))),
                                                height: MediaQuery
                                                            .of(context)
                                                        .size
                                                        .height /
                                                    6.5,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.0,
                                                child: Image.network(
                                                  pickupjobData.itemImage
                                                      .toString(),
                                                  fit: BoxFit.cover,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Wrap(
                                                    children: [
                                                      const Text(
                                                          'Total Items: '),
                                                      Text(
                                                        '${pickupjobData.barCodeItemNumber.toString()} Items',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  const Text('Item info:'),
                                                  Text(
                                                    "Height: " +
                                                        pickupjobData.height
                                                            .toString() +
                                                        ' Feet \n' +
                                                        "Weight: " +
                                                        pickupjobData.weight
                                                            .toString() +
                                                        ' Pound \n' +
                                                        "Length: " +
                                                        pickupjobData.length
                                                            .toString() +
                                                        ' Feet',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
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
