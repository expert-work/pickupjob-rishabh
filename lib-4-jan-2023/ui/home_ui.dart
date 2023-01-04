import 'package:flutter/material.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:pickupjob/ui/ui.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({Key? key}) : super(key: key);

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) => controller.firestoreUser == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              bottomNavigationBar: CurvedNavigationBar(
                key: _bottomNavigationKey,
                index: 0,
                height: 60.0,
                items: const <Widget>[
                  Icon(Icons.home, size: 30),
                  Icon(Icons.search, size: 30),
                  Icon(Icons.fire_truck, size: 30),
                  Icon(Icons.chat, size: 30),
                  Icon(Icons.perm_identity, size: 30),
                ],
                color: Colors.white,
                buttonBackgroundColor: Colors.white,
                backgroundColor: Colors.black87,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 600),
                onTap: (index) {
                  setState(() {
                    _page = index;
                  });
                },
                letIndexChange: (index) => true,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('home.title'.tr),
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.to(SettingsUI());
                      }),
                ],
              ),
              body: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 120),
                      Avatar(controller.firestoreUser.value!),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FormVerticalSpace(),
                          Text(
                              'home.uidLabel'.tr +
                                  ': ' +
                                  controller.firestoreUser.value!.uid,
                              style: TextStyle(fontSize: 16)),
                          FormVerticalSpace(),
                          Text(
                              'home.nameLabel'.tr +
                                  ': ' +
                                  controller.firestoreUser.value!.name,
                              style: TextStyle(fontSize: 16)),
                          FormVerticalSpace(),
                          Text(
                              'home.emailLabel'.tr +
                                  ': ' +
                                  controller.firestoreUser.value!.email,
                              style: TextStyle(fontSize: 16)),
                          FormVerticalSpace(),
                          Text(
                              'home.adminUserLabel'.tr +
                                  ': ' +
                                  controller.admin.value.toString(),
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
