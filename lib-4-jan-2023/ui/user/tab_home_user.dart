import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../controllers/controllers.dart';
import '../ui.dart';

class TabHomeUser extends StatefulWidget {
  const TabHomeUser({super.key});

  @override
  State<TabHomeUser> createState() => _TabHomeUserState();
}

class _TabHomeUserState extends State<TabHomeUser> {
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
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'welcome: ' +
                            controller.firestoreUser.value!.name +
                            '!',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        crossAxisCount: 2,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: Icon(
                                    Icons.add,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Get.to(addPickupJobs());
                                  },
                                ),
                                Divider(
                                  height: 15,
                                ),
                                InkWell(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Create Job",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    Get.to(addPickupJobs());
                                  },
                                ),
                              ],
                            )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: Icon(
                                    Icons.fire_truck,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Get.to(inProgressJobsUser());
                                  },
                                ),
                                Divider(
                                  height: 15,
                                ),
                                InkWell(
                                  child: Text(
                                    "In Progress  Jobs",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    Get.to(inProgressJobsUser());
                                  },
                                ),
                              ],
                            )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.car_rental,
                                  size: 60,
                                  color: Colors.white,
                                ),
                                Divider(
                                  height: 15,
                                ),
                                Text(
                                  "Completed Jobs",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.payment,
                                  size: 60,
                                  color: Colors.white,
                                ),
                                Divider(
                                  height: 15,
                                ),
                                Text(
                                  "Payments",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.money,
                                  size: 60,
                                  color: Colors.white,
                                ),
                                Divider(
                                  height: 15,
                                ),
                                Text(
                                  "Fee & Charges",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.policy,
                                  size: 60,
                                  color: Colors.white,
                                ),
                                Divider(
                                  height: 15,
                                ),
                                Text(
                                  "Terms & Policies",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          ),
                        ],
                      ),
                    )
                  ],
                )));
  }
}
