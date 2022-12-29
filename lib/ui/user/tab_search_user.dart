import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../controllers/controllers.dart';
import '../ui.dart';

class TabSearchUser extends StatefulWidget {
  const TabSearchUser({super.key});

  @override
  State<TabSearchUser> createState() => _TabSearchUserState();
}

class _TabSearchUserState extends State<TabSearchUser> {
  int radius = 30;
  TextEditingController radiusController = TextEditingController();

  String jsonToString(String value) {
    var s = (value.substring(1, value.length - 1)).toString();
    if (s.length > 120) {
      s = s.substring(0, 120) + ' ...';
    }
    return s;
  }

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
                    GetX<VehicleController>(
                      init: Get.put<VehicleController>(VehicleController()),
                      builder: (VehicleController vehicleController) {
                        return Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                          ),
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: vehicleController.vehiclesOpen.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(vehicleController.vehiclesOpen[index]);
                              final vehicleData =
                                  vehicleController.vehiclesOpen[index];
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
                                            textAlign: TextAlign.left,
                                            vehicleData.title.toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          IconButton(
                                              icon: const Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                //Get.to(addVehicle());
                                              }),
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
                                              vehicleData.pictureOfVehicle
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
                                              Divider(
                                                height: 10,
                                              ),
                                              Text(
                                                vehicleData.make.toString() +
                                                    ' - ' +
                                                    vehicleData.model
                                                        .toString() +
                                                    '(' +
                                                    vehicleData.year
                                                        .toString() +
                                                    ')',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Divider(
                                                height: 5,
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2) -
                                                    40,
                                                child: Text(jsonToString(
                                                    vehicleData.ableToTransport
                                                        .toString())),
                                              )
                                            ],
                                          )
                                        ],
                                      )
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
