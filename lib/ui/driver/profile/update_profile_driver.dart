import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickupjob/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/helpers/firestore_user_db.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pickupjob/models/models.dart';

class DriverUpdateProfile extends StatefulWidget {
  const DriverUpdateProfile({Key? key}) : super(key: key);

  @override
  State<DriverUpdateProfile> createState() => _DriverUpdateProfileState();
}

class _DriverUpdateProfileState extends State<DriverUpdateProfile> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthController authController = AuthController.to;
  List<String> usaStates = <String>[];
  List<String> cities = <String>[];

  TextEditingController fullAddressController = TextEditingController();

  TextEditingController zipCodeController = TextEditingController();
  TextEditingController suitAptNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController driverLicNumberCodeController = TextEditingController();

  TextEditingController companyNameController = TextEditingController();
  TextEditingController incorporationStateController = TextEditingController();
  TextEditingController usdotLicNumController = TextEditingController();
  TextEditingController einTaxIdNumController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String state = "";
  String fullAddress = "";
  String suitAptNumber = "";
  String city = "";
  String zipCode = "";
  String phoneNumber = "";
  String driverLicFront = "";
  String driverLicBack = "";
  String driverLicNumber = "";

  //Company
  String companyName = "";
  String incorporationState = "";
  String usdotLicNum = "";
  String einTaxIdNum = "";

  @override
  void initState() {
    loadData();
    getStatesData();
    super.initState();
  }

  void loadData() async {
    UserModel userDetail =
        await FirestoreUserDb.getUsersId(auth.currentUser!.uid);

    fullAddressController.text = userDetail.fullAddress!;

    zipCodeController.text = userDetail.zipCode!;
    suitAptNumberController.text = userDetail.suitAptNumber!;
    phoneNumberController.text = userDetail.phoneNumber!;
    driverLicNumberCodeController.text = userDetail.driverLicNumber!;
    companyNameController.text = userDetail.companyName!;
    incorporationStateController.text = userDetail.incorporationState!;
    usdotLicNumController.text = userDetail.usdotLicNum!;
    einTaxIdNumController.text = userDetail.einTaxIdNum!;
    citiesListData(userDetail.state!);
    setState(() {
      driverLicFront = userDetail.driverLicFront!;
      driverLicBack = userDetail.driverLicBack!;
      state = userDetail.state!;
      city = userDetail.city!;
    });
  }

  getStatesData() async {
    usaStates = [];
    cities = [];
    await FirebaseFirestore.instance
        .collection('locations')
        .orderBy('state')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (!usaStates.contains(doc["state"])) {
          usaStates.add(doc["state"]);
        }
      });
    });
    setState(() {
      usaStates = usaStates;
      // cities = [];
    });
  }

  citiesListData(String state) async {
    cities = [];
    await FirebaseFirestore.instance
        .collection('locations')
        .where("state", isEqualTo: state)
        .orderBy('city')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (!cities.contains(doc["city"])) {
          cities.add(doc["city"]);
        }
      });
    });

    setState(() {
      cities = cities;
    });
  }

  Future<String> uploadImageToFirebase() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    var imageFile = File(image!.path);
    String fileName = basename(imageFile.path);

    try {
      showLoadingIndicator();
      Reference storageReference =
          FirebaseStorage.instance.ref().child("images/$fileName");
      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();
      print(url);
      hideLoadingIndicator();
      return url;
    } on FirebaseException catch (e) {
      hideLoadingIndicator();
      return "";
      // e.g, e.code == 'canceled'
    }
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
                title: const Text('Complete Profile'),
                // actions: [
                //   IconButton(
                //       icon: const Icon(
                //         Icons.logout,
                //         color: Colors.white,
                //       ),
                //       onPressed: () {
                //         AuthController.to.signOut();
                //       }),
                // ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              body: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: (MediaQuery.of(context).size.height - 60),
                        child: ListView(
                          padding: const EdgeInsets.all(30),
                          children: <Widget>[
                            controller.firestoreUser.value!.isIndividual
                                ? Container(
                                    child: Column(
                                    children: [
                                      TextField(
                                        controller:
                                            driverLicNumberCodeController,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                        decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          labelText: 'Driver Lic Number',
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 20,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 10),
                                        child: const Text(
                                          'Driver Lic (Front)',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        child: InkWell(
                                          child: Image.network(
                                            (driverLicFront == '')
                                                ? "https://cdn-icons-png.flaticon.com/512/4653/4653792.png"
                                                : driverLicFront,
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
                                          onTap: () async {
                                            String url =
                                                await uploadImageToFirebase();

                                            setState(() {
                                              driverLicFront = url;
                                            });
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      const Divider(
                                        height: 20,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 10),
                                        child: const Text(
                                          'Driver Lic (Back)',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        child: InkWell(
                                          child: Image.network(
                                            (driverLicBack == '')
                                                ? "https://cdn-icons-png.flaticon.com/512/4653/4653792.png"
                                                : driverLicBack,
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
                                          onTap: () async {
                                            String url =
                                                await uploadImageToFirebase();

                                            setState(() {
                                              driverLicBack = url;
                                            });
                                            setState(() {});
                                          },
                                        ),
                                      )
                                    ],
                                  ))
                                : Container(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: companyNameController,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            labelText: 'Company Name',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 30,
                                        ),
                                        TextField(
                                          controller:
                                              incorporationStateController,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            labelText: 'Incorporation State',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 30,
                                        ),
                                        TextField(
                                          controller: usdotLicNumController,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            labelText:
                                                'USDOT Lic Number or MC Lic Num',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 30,
                                        ),
                                        TextField(
                                          controller: einTaxIdNumController,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            labelText: 'EID TAX ID Number',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            const Divider(
                              height: 30,
                            ),
                            TextField(
                              controller: fullAddressController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              maxLines: 3, //or null
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                labelText: 'Full Address',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 24,
                            ),
                            TextField(
                              controller: suitAptNumberController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                labelText: 'Suite or APT Number',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 14,
                            ),
                            Divider(
                              height: 20,
                            ),
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                labelText: 'State',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              isExpanded: true,
                              value: state.isNotEmpty
                                  ? state
                                  : null, // guard it with null if empty

                              icon: const Icon(Icons.arrow_downward),
                              elevation: 12,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                              hint: state != null
                                  ? null
                                  : Text(
                                      'State',
                                      style: TextStyle(color: Colors.black),
                                    ),

                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  state = value!;
                                  city = "";
                                });
                                citiesListData(value!);
                              },
                              items: usaStates.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            Divider(
                              height: 20,
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                labelText: 'City',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              isExpanded: true,
                              value: (city.isNotEmpty && city != '')
                                  ? city
                                  : null, // guard it with null if empty

                              icon: const Icon(Icons.arrow_downward),
                              elevation: 12,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                              hint: city != null
                                  ? null
                                  : Text(
                                      'City',
                                      style: TextStyle(color: Colors.black),
                                    ),

                              onChanged: (String? value) {
                                setState(() {
                                  city = value!;
                                });
                              },
                              items: cities.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            Divider(
                              height: 20,
                            ),
                            TextField(
                              controller: zipCodeController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                labelText: 'Zipcode',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 24,
                            ),
                            TextField(
                              controller: phoneNumberController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Row(children: [
                          Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    //company
                                    companyName = companyNameController.text;
                                    incorporationState =
                                        incorporationStateController.text;
                                    usdotLicNum = usdotLicNumController.text;
                                    einTaxIdNum = einTaxIdNumController.text;
                                    //driver
                                    driverLicNumber =
                                        driverLicNumberCodeController.text;
                                    //Address
                                    fullAddress = fullAddressController.text;
                                    suitAptNumber =
                                        suitAptNumberController.text;

                                    zipCode = zipCodeController.text;
                                    phoneNumber = phoneNumberController.text;
                                  });
                                  if (controller
                                      .firestoreUser.value!.isIndividual) {
                                    if (driverLicNumber.trim() == '' ||
                                        driverLicBack == "" ||
                                        driverLicFront == "" ||
                                        fullAddress == "" ||
                                        city == "" ||
                                        zipCode == "" ||
                                        state == "Select State" ||
                                        phoneNumber == "") {
                                      Get.defaultDialog(
                                        title: "Alert!",
                                        content: const Text(
                                            "All fields are required"),
                                      );
                                    } else {
                                      UserModel _updatedUser = UserModel(
                                          uid: controller
                                              .firestoreUser.value!.uid,
                                          email: controller
                                              .firestoreUser.value!.email,
                                          name: controller
                                              .firestoreUser.value!.name,
                                          firstName: controller
                                              .firestoreUser.value!.firstName,
                                          lastName: controller
                                              .firestoreUser.value!.lastName,
                                          photoUrl: controller
                                              .firestoreUser.value!.photoUrl,
                                          userType: controller
                                              .firestoreUser.value!.userType,
                                          isProfileCompleted: true,
                                          companyName: "",
                                          incorporationState: "",
                                          usdotLicNum: "",
                                          einTaxIdNum: "",
                                          driverLicNumber: driverLicNumber,
                                          driverLicBack: driverLicBack,
                                          driverLicFront: driverLicFront,
                                          fullAddress: fullAddress,
                                          suitAptNumber: suitAptNumber,
                                          city: city,
                                          zipCode: zipCode,
                                          state: state,
                                          phoneNumber: phoneNumber,
                                          isIndividual: controller.firestoreUser
                                              .value!.isIndividual,
                                          deviceToken: controller
                                              .firestoreUser.value!.deviceToken,
                                          numberOfVehicle: 0);
                                      print(_updatedUser);
                                      await AuthController()
                                          .updateUserFirestoreById(
                                              _updatedUser,
                                              controller
                                                  .firestoreUser.value!.uid);
                                    }
                                  }

                                  if (!controller
                                      .firestoreUser.value!.isIndividual) {
                                    if (companyName.trim() == '' ||
                                        incorporationState == "" ||
                                        usdotLicNum == "" ||
                                        einTaxIdNum == "" ||
                                        fullAddress == "" ||
                                        city == "" ||
                                        zipCode == "" ||
                                        state == "Select State" ||
                                        phoneNumber == "") {
                                      Get.defaultDialog(
                                        title: "Alert!",
                                        content: const Text(
                                            "All fields are required"),
                                      );
                                    } else {
                                      UserModel _updatedUser = UserModel(
                                          uid: controller
                                              .firestoreUser.value!.uid,
                                          email: controller
                                              .firestoreUser.value!.email,
                                          name: controller
                                              .firestoreUser.value!.name,
                                          firstName: controller
                                              .firestoreUser.value!.firstName,
                                          lastName: controller
                                              .firestoreUser.value!.lastName,
                                          photoUrl: controller
                                              .firestoreUser.value!.photoUrl,
                                          userType: controller
                                              .firestoreUser.value!.userType,
                                          isProfileCompleted: true,
                                          companyName: companyName,
                                          incorporationState:
                                              incorporationState,
                                          usdotLicNum: usdotLicNum,
                                          einTaxIdNum: einTaxIdNum,
                                          driverLicNumber: "",
                                          driverLicBack: "",
                                          driverLicFront: "",
                                          fullAddress: fullAddress,
                                          suitAptNumber: suitAptNumber,
                                          city: city,
                                          zipCode: zipCode,
                                          state: state,
                                          phoneNumber: phoneNumber,
                                          isIndividual: controller.firestoreUser
                                              .value!.isIndividual,
                                          deviceToken: controller
                                              .firestoreUser.value?.deviceToken,
                                          numberOfVehicle: 0);
                                      print(_updatedUser);
                                      await AuthController()
                                          .updateUserFirestoreById(
                                              _updatedUser,
                                              controller
                                                  .firestoreUser.value!.uid);
                                    }
                                  }
                                },
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ))
                        ]),
                      )
                    ],
                  ))),
    );
  }
}
