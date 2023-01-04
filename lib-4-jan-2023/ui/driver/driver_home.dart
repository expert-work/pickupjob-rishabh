import 'package:flutter/material.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:pickupjob/ui/ui.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class driverHome extends StatefulWidget {
  const driverHome({Key? key}) : super(key: key);

  @override
  State<driverHome> createState() => _driverHomeState();
}

class _driverHomeState extends State<driverHome> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  static const List<String> _tabNames = [
    'Home',
    'Search new Jobs',
    'Orders',
    'Chats',
    'Profile'
  ];
  static const List<Widget> _widgetOptions = <Widget>[
    TabHomeDriver(),
    TabSearchDriver(),
    TabOrdersDriver(),
    TabChatDriver(),
    TabProfileDriver()
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) => controller.firestoreUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                drawer: myDrawer(context, controller),
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
                    print(_page);
                    setState(() {});
                  },
                  letIndexChange: (index) => true,
                ),
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.black87,
                  title: Text(_tabNames[_page]),
                  actions: [
                    IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          AuthController.to.signOut();
                        }),
                  ],
                ),
                body: _widgetOptions.elementAt(_page)));
  }

//firestoreUser
//controller.firestoreUser
  Drawer myDrawer(BuildContext context, controller) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage(controller.firestoreUser.value!.photoUrl),
            ),
            accountEmail: Text(controller.firestoreUser.value!.email),
            accountName: Text(
              controller.firestoreUser.value!.name,
              style: const TextStyle(fontSize: 24.0),
            ),
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.fire_truck),
            title: const Text(
              'Pickup Jobs',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.fire_truck),
            title: const Text(
              'In Progress Jobs',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              Get.to(inProgressJobsDriver());
            },
          ),
          ListTile(
            leading: const Icon(Icons.car_rental),
            title: const Text(
              'Completed Jobs',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.window_rounded),
            title: const Text(
              'Bids',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              Get.offAll(listProposalsDriver());
            },
          ),
          ListTile(
            leading: const Icon(Icons.window_rounded),
            title: const Text(
              'My Vehicle',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              Get.to(listVehicle());
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text(
              'Payment Method',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              Get.to(Cards());
            },
          ),
          const Divider(
            height: 10,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text(
              'Our Fee/Charges',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text(
              'Terms & Policy',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              AuthController.to.signOut();
            },
          ),
        ],
      ),
    );
  }
}
