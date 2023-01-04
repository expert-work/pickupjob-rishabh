import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pickupjob/models/models.dart';

class userCompleteProfile extends StatefulWidget {
  const userCompleteProfile({Key? key}) : super(key: key);

  @override
  State<userCompleteProfile> createState() => _userCompleteProfileState();
}

class _userCompleteProfileState extends State<userCompleteProfile> {
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

  int _value = 1;
  int _screenIndex = 0;

  bool isIndividual = true;
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
    getStatesData();
    super.initState();
  }

  // List of items in our dropdown menu

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
      cities = [];
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
    showLoadingIndicator();

    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    var imageFile = File(image!.path);
    String fileName = basename(imageFile.path);

    try {
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
                title: Text('Complete Profile'),
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              body: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                  ),
                  child: screenSelect(context, controller.firestoreUser))),
    );
  }

  Widget screenSelect(BuildContext context, firestoreUser) {
    switch (_screenIndex) {
      case 0:
        {
          return selectUserTypeScreen(context, firestoreUser);
          break;
        }
      case 1:
        {
          return selectUserDetailScreen(context, firestoreUser);
          break;
        }
      default:
        {
          return Text("data");
        }
    }
  }

  Widget selectUserDetailScreen(BuildContext context, firestoreUser) {
    return Stack(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height - 60),
          child: ListView(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            children: <Widget>[
              isIndividual
                  ? Container()
                  : Container(
                      child: Column(
                        children: [
                          TextField(
                            controller: companyNameController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20.0),
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              labelText: 'Company Name',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          Divider(
                            height: 30,
                          ),
                          TextField(
                            controller: incorporationStateController,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: 'Incorporation State',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          Divider(
                            height: 30,
                          ),
                          TextField(
                            controller: usdotLicNumController,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: 'USDOT Lic Number or MC Lic Num',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          Divider(
                            height: 30,
                          ),
                          TextField(
                            controller: einTaxIdNumController,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: 'EID TAX ID Number',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              Divider(
                height: 30,
              ),
              TextField(
                controller: fullAddressController,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                maxLines: 3, //or null
                decoration: InputDecoration(
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
              Divider(
                height: 24,
              ),
              TextField(
                controller: suitAptNumberController,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                decoration: InputDecoration(
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
                height: 24,
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
                style: TextStyle(color: Colors.grey, fontSize: 15),
                hint: state != null
                    ? null
                    : const Text(
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
              const Divider(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
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
                style: const TextStyle(color: Colors.grey, fontSize: 15),
                hint: city != null
                    ? null
                    : const Text(
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
              const Divider(
                height: 24,
              ),
              TextField(
                controller: zipCodeController,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                decoration: InputDecoration(
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
              Divider(
                height: 24,
              ),
              TextField(
                controller: phoneNumberController,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                decoration: InputDecoration(
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
              Divider(
                height: 80,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Row(children: [
            Container(
                height: 60,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () async {
                    setState(() {
                      _screenIndex = 0;
                    });
                  },
                  child: const Text(
                    'Previous',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )),
            Container(
                height: 60,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () async {
                    print("firestoreUser.value!.uid");
                    print(firestoreUser.value!.uid);
                    print("firestoreUser.value!.uid");
                    setState(() {
                      //company
                      companyName = companyNameController.text;
                      incorporationState = incorporationStateController.text;
                      usdotLicNum = usdotLicNumController.text;
                      einTaxIdNum = einTaxIdNumController.text;
                      //driver
                      driverLicNumber = driverLicNumberCodeController.text;
                      //Address
                      suitAptNumber = suitAptNumberController.text;
                      fullAddress = fullAddressController.text;
                      zipCode = zipCodeController.text;
                      phoneNumber = phoneNumberController.text;
                    });
                    if (isIndividual) {
                      if (fullAddress == "" ||
                          city == "" ||
                          zipCode == "" ||
                          state == "Select State" ||
                          phoneNumber == "") {
                        Get.defaultDialog(
                          title: "Alert!",
                          content: Text("All fields are required"),
                        );
                      } else {
                        UserModel _updatedUser = UserModel(
                            uid: firestoreUser.value?.uid,
                            email: firestoreUser.value?.email,
                            name: firestoreUser.value?.name,
                            firstName: firestoreUser.value?.firstName,
                            lastName: firestoreUser.value?.lastName,
                            photoUrl: firestoreUser.value?.photoUrl,
                            userType: firestoreUser.value?.userType,
                            isProfileCompleted: true,
                            companyName: "",
                            incorporationState: "",
                            usdotLicNum: "",
                            einTaxIdNum: "",
                            driverLicNumber: "",
                            driverLicBack: "",
                            driverLicFront: "",
                            fullAddress: fullAddress,
                            suitAptNumber: suitAptNumber,
                            city: city,
                            zipCode: zipCode,
                            state: state,
                            phoneNumber: phoneNumber,
                            isIndividual: isIndividual,
                            deviceToken: firestoreUser.value?.deviceToken,
                            numberOfVehicle: 0);
                        print(_updatedUser);
                        await AuthController().updateUserFirestoreById(
                            _updatedUser, firestoreUser.value?.uid);

                        //_screenIndex = 2;
                      }
                    }

                    if (!isIndividual) {
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
                          content: Text("All fields are required"),
                        );
                      } else {
                        UserModel _updatedUser = UserModel(
                            uid: firestoreUser.value?.uid,
                            email: firestoreUser.value?.email,
                            name: firestoreUser.value?.name,
                            firstName: firestoreUser.value?.firstName,
                            lastName: firestoreUser.value?.lastName,
                            photoUrl: firestoreUser.value?.photoUrl,
                            userType: firestoreUser.value?.userType,
                            isProfileCompleted: true,
                            companyName: companyName,
                            incorporationState: incorporationState,
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
                            deviceToken: firestoreUser.value?.deviceToken,
                            isIndividual: isIndividual,
                            numberOfVehicle: 0);
                        print(_updatedUser);
                        await AuthController().updateUserFirestoreById(
                            _updatedUser, firestoreUser.value?.uid);

                        // _screenIndex = 2;
                      }
                    }

                    // else {
                    //   Get.defaultDialog(
                    //     title: "Alert!",
                    //     content: Text("All fields are required"),
                    //   );
                    // }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ))
          ]),
        )
      ],
    );
  }

  Widget selectUserTypeScreen(BuildContext context, firestoreUser) {
    return Stack(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height - 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: MyRadioListTile<int>(
                  value: 1,
                  groupValue: _value,
                  leading: 'An Independent Need Service',
                  onChanged: (value) =>
                      setState(() => {_value = value!, isIndividual = true}),
                ),
              ),
              MyRadioListTile<int>(
                value: 2,
                groupValue: _value,
                leading: ' A Corporate Need Service',
                onChanged: (value) =>
                    setState(() => {_value = value!, isIndividual = false}),
              )
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
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () async {
                    setState(() {
                      _screenIndex = 1;
                    });
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ))
          ]),
        )
      ],
    );
  }
}
