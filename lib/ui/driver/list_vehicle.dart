import 'dart:async';
import 'dart:io';
import 'dart:ui';
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

class listVehicle extends StatefulWidget {
  const listVehicle({super.key});

  @override
  State<listVehicle> createState() => _listVehicleState();
}

class _listVehicleState extends State<listVehicle> {
  String jsonToString(String value) {
    var s = (value.substring(1, value.length - 1)).toString();
    if (s.length > 120) {
      s = s.substring(0, 120) + ' ...';
    }
    return s;
  }

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
                  title: Text('My Vehicles--'),
                  actions: [
                    IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.to(addVehicle());
                        }),
                  ],
                ),
                body: GetX<VehicleController>(
                  init: Get.put<VehicleController>(VehicleController()),
                  builder: (VehicleController vehicleController) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: vehicleController.vehicles.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(vehicleController.vehicles[index]);
                          final vehicleData = vehicleController.vehicles[index];
                          return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              // padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                // borderRadius: BorderRadius.circular(4),

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
                                    children: [
                                      Text(
                                        vehicleData.title.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
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
                                                Get.to(addVehicle());
                                              }),
                                          IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                Get.to(addVehicle());
                                              }),
                                          IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                Get.to(addVehicle());
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
                                                    24, 255, 255, 255))),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Image.network(
                                          vehicleData.pictureOfVehicle
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Divider(
                                            height: 10,
                                          ),
                                          Text(
                                            vehicleData.make.toString() +
                                                ' - ' +
                                                vehicleData.model.toString() +
                                                '(' +
                                                vehicleData.year.toString() +
                                                ')',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Divider(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2) -
                                                40,
                                            child: Text(jsonToString(vehicleData
                                                .ableToTransport
                                                .toString())),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ));
                        },
                      ),
                    );
                  },
                )));
  }
}
