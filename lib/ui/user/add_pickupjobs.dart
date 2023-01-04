import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pickupjob/models/models.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

import '../../constants.dart';
import '../../helpers/firestore_db.dart';
import '../ui.dart';

class addPickupJobs extends StatefulWidget {
  const addPickupJobs({super.key});

  @override
  State<addPickupJobs> createState() => _addPickupJobsState();
}

class _addPickupJobsState extends State<addPickupJobs> {
  FirebaseStorage _storage = FirebaseStorage.instance;

  final AuthController authController = AuthController.to;
  final ImagePicker _picker = ImagePicker();
  final ableToTransportController = Get.put(AbleToTransportController());
  List<String> ableToTranport = <String>[];
  List<String> citiesData = <String>['Select City'];
  List<String> statesData = <String>[];
  List<String> pickCitiesList = <String>[];
  List<String> dropCitiesList = <String>[];

  TextEditingController barCodeItemNumberController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController numberOfItemController = TextEditingController();
  TextEditingController needLoadUnloadTimeController = TextEditingController();
  //pick Addreess

  TextEditingController pickAddressController = TextEditingController();
  TextEditingController pickZipController = TextEditingController();
  //pick Addreess

  //drop Addreess

  TextEditingController dropAddressController = TextEditingController();

  TextEditingController dropZipController = TextEditingController();
  //drop Addreess

  TextEditingController contactPersonNameController = TextEditingController();
  TextEditingController contactPersonMobileController = TextEditingController();
  TextEditingController contactPersonAlternateMobileController =
      TextEditingController();

  DateTime? currentTime = DateTime.now();
  int _screenIndex = 0;
  String pageTitle = "New Job";
  String inputMethod = '';
  String _scanBarcode = '';
  String title = 'hjgjhgj';
  String barCodeItemNumber = '';
  String barCodeItem = '';
  String weight = '';
  String length = '';
  String height = '';
  String numberOfItem = '';
  String itemImage = '';
  String needLoadUnload = 'No';
  String needLoadUnloadTime = '';

//pick Addreess
  static Key pickMapKey = ObjectKey('pickMapKey');
  late double pickLat;
  late double pickLan;
  String pickAddress = '';
  String pickState = '';
  String pickCity = '';
  String pickZip = '';

//drop
  static Key dropMapKey = ObjectKey('dropMapKey');

  late double dropLat;
  late double dropLan;
  String dropAddress = '';
  String dropState = '';
  String dropCity = '';
  String dropZip = '';

  String totalDistence = "0";
//Contact Person
  String contactPersonName = '';
  String contactPersonMobile = '';
  String contactPersonAlternateMobile = '';

  DateTime dateForPickup = DateTime.now();
  DateTime timeForPickupLoad = DateTime.now();

  bool isAutoBid = false;
  DateTime autoBidStartDateTime = DateTime.now();

//MAP

  late CameraPosition currentPickPosition;
  late CameraPosition _currentDropPosition;
  String googleApikey = "AIzaSyCe2c5wnzwWCrtk-U-MvBIbvVn2rswuxpQ";
  GoogleMapController? pickMapController;
  GoogleMapController? dropMapController;

  final TextEditingController _pickSearchController = TextEditingController();
  final TextEditingController _dropSearchController = TextEditingController();
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  late List<Placemark> placemarks;
  String blockDropdownValue = '';
  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      pickLat = position.latitude;
      pickLan = position.longitude;
      dropLat = position.latitude;
      dropLan = position.longitude;

      pickMapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(pickLat, pickLan), zoom: 20)));
      currentPickPosition = CameraPosition(
        target: LatLng(pickLat, pickLan),
        zoom: 20,
      );

      dropMapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(dropLat, dropLan), zoom: 20)));
      _currentDropPosition = CameraPosition(
        target: LatLng(dropLat, dropLan),
        zoom: 20,
      );
    });
    setState(() {});
  }

  @override
  void initState() {
    googlePlace = GooglePlace(googleApikey);
    ableToTransportData();
    getStatesData();
    getLocation();
    // Getting user Information function -->
    getUserInfo();
    super.initState();
  }

  // Getting User Information Information -->
  getUserInfo() {
    UserModel userInfo = Get.find<AuthController>().firestoreUser.value!;
    contactPersonNameController.text = userInfo.name;
    contactPersonMobileController.text = userInfo.phoneNumber.toString();
    contactPersonAlternateMobileController.text =
        userInfo.phoneNumber.toString();
  }

  getStatesData() async {
    citiesData = [];
    statesData = [];
    await FirebaseFirestore.instance
        .collection('locations')
        .orderBy('state')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (!statesData.contains(doc["state"])) {
          statesData.add(doc["state"]);
        }
      });
    });
    setState(() {
      statesData = statesData;
    });
  }

  getDropCitiesListData(String state) async {
    dropCitiesList = [];
    await FirebaseFirestore.instance
        .collection('locations')
        .where("state", isEqualTo: state)
        .orderBy('city')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        dropCitiesList.add(doc["city"]);
      });
    });

    dropCitiesList = dropCitiesList.toSet().toList();
    setState(() {
      dropCitiesList = dropCitiesList;
    });
  }

  getPickCitiesListData(String state) async {
    pickCitiesList = [];
    await FirebaseFirestore.instance
        .collection('locations')
        .where("state", isEqualTo: state)
        .orderBy('city')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        pickCitiesList.add(doc["city"]);
      });
    });

    pickCitiesList = pickCitiesList.toSet().toList();

    setState(() {
      pickCitiesList = pickCitiesList;
    });
  }

  getCitiesData(String state) async {
    citiesData = [];
    await FirebaseFirestore.instance
        .collection('locations')
        .where("state", isEqualTo: state)
        .orderBy('city')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        citiesData.add(doc["city"]);
      });
    });

    setState(() {
      citiesData = ableToTranport;
    });
  }

  ableToTransportData() async {
    ableToTranport = [];
    await FirebaseFirestore.instance
        .collection('able-to-transport')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        ableToTranport.add(doc["title"]);
      });
    });

    setState(() {
      ableToTranport = ableToTranport;
    });
  }

  Future<bool> _onWillPop() async {
    return await Get.defaultDialog(
      title: "",
      middleText: "You want exit from screen?",
      barrierDismissible: false,
      radius: 10.0,
      confirm: confirmBtn(),
      cancel: cancelBtn(),
    );
  }

  Widget confirmBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.offAll(userHome());
          print("back button pushed");
        },
        child: Text("Confirm"));
  }

  Widget cancelBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("Cancel"));
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

//MAP
  setIsAutoBid(index) {
    setState(() {
      isAutoBid = index;
    });
    print(isAutoBid);
    setState(() {});
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    final ableToTransportController = Get.put(AbleToTransportController());

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      ///print(barcodeScanRes);
      var d = json.decode(barcodeScanRes);

      print(d);
//{title: wefwe, color: wefew, serialNumber: wfwefwe, manufacturedBy: 3ferfer, height: 2323, width: 323, length: 228, weight: 233232}
      print("d['title']");
      print(d['title']);
      print(d['serialNumber']);
      print(d['length']);
      print(d['height']);

      barCodeItemNumberController.text = d['serialNumber'];
      titleController.text = d['title'];
      weightController.text = d['weight'];
      lengthController.text = d['length'];
      heightController.text = d['height'];
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      print("barcodeScanRes Failed");
    }

    if (!mounted) return;
    if ((titleController.text).trim() == '') {
      Get.defaultDialog(
        title: "Alert!",
        content: const Text("Somthing is wrong with QR"),
      );
    } else {
      setState(() {
        _scanBarcode = barcodeScanRes;
        pageTitle = 'Basic Details';
        _screenIndex = 1;
      });
    }

    setState(() {});
  }

  Future<String> uploadImageToFirebase() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    var imageFile = File(image!.path);
    String fileName = basename(imageFile.path);
    showLoadingIndicator();
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
    return WillPopScope(
      child: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) => controller.firestoreUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.black87,
                  title: Text(pageTitle),
                  // actions: [
                  //   IconButton(
                  //       icon: Icon(
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
                    child: screenSelect(context, controller.firestoreUser))),
      ),
      onWillPop: () {
        return _onWillPop(); // if true allow back else block it
      },
    );
  }

  Widget screenSelect(BuildContext context, firestoreUser) {
    switch (_screenIndex) {
      case 0:
        {
          //return pickupLocation(context, firestoreUser);

          return pickupInputMethod(context, firestoreUser);
        }

      case 1:
        {
          return pickupJobInfo(context, firestoreUser);
        }
      case 2:
        {
          return pickupLocation(context, firestoreUser);
        }
      case 3:
        {
          return dropLocation(context, firestoreUser);
        }
      case 4:
        {
          return confirmLocation(context, firestoreUser);
        }
      case 5:
        {
          return contactPersonDetails(context, firestoreUser);
        }
      case 6:
        {
          return dateAndTime(context, firestoreUser);
        }

      // Additional Code -->
      case 7:
        {
          return reviewDetails(context, firestoreUser);
        }

      default:
        {
          return const Text("data");
        }
    }
  }

  Widget pickupInputMethod(BuildContext context, firestoreUser) {
    return Stack(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height - 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  margin: const EdgeInsets.all(30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: (inputMethod == 'input')
                          ? Colors.green
                          : Colors.white),
                  child: const Center(
                      child: Text(
                    "Input My Order",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                onTap: () {
                  setState(() {
                    inputMethod = 'input';
                    _screenIndex = 1;
                    pageTitle = 'Basic Details';
                  });
                  setState(() {});
                },
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  margin: const EdgeInsets.all(30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: (inputMethod == 'barcode')
                          ? Colors.green
                          : Colors.white),
                  child: const Center(
                      child: Text(
                    "Bar Scan Delivery",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                onTap: () {
                  setState(() {
                    inputMethod = 'barcode';
                  });
                  scanBarcodeNormal();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget pickupJobInfo(BuildContext context, firestoreUser) {
    return Stack(
      children: [
        SizedBox(
          height: (MediaQuery.of(context).size.height - 60),
          child: ListView(
            padding: const EdgeInsets.all(30),
            children: <Widget>[
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white, fontSize: 20.0),
                //or null
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  labelText: 'Job Title',
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
                controller: barCodeItemNumberController,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                //or null
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: 'Item Number',
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
                  labelText: 'Item Type',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                isExpanded: true,
                value: barCodeItem.isNotEmpty
                    ? barCodeItem
                    : null, // guard it with null if empty

                icon: const Icon(Icons.arrow_downward),
                elevation: 12,
                style: TextStyle(color: Colors.grey, fontSize: 15),
                hint: barCodeItem != null
                    ? null
                    : Text(
                        'Item Type',
                        style: TextStyle(color: Colors.black),
                      ),

                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    barCodeItem = value!;
                  });
                },
                items: ableToTranport.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const Divider(
                height: 24,
              ),
              SizedBox(
                height: 60,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20.0),
                          //or null
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            labelText: 'Weight (Pound)',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: TextField(
                          controller: lengthController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20.0),
                          //or null
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            labelText: 'Length (Feet)',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: TextField(
                          controller: heightController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20.0),
                          //or null
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            labelText: 'Height (Feet)',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              const Divider(
                height: 24,
              ),
              const Divider(
                height: 24,
              ),
              const Divider(
                height: 24,
              ),
              TextField(
                controller: numberOfItemController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 20.0),
                //or null
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  labelText: 'Number Of Items',
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: const Text(
                  'To View/Take a pic of Item',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(
                child: InkWell(
                  child: Image.network(
                    (itemImage == '')
                        ? "https://cdn-icons-png.flaticon.com/512/4653/4653792.png"
                        : itemImage,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  onTap: () async {
                    String url = await uploadImageToFirebase();

                    setState(() {
                      itemImage = url;
                    });
                    setState(() {});
                  },
                ),
              ),
              const Divider(
                height: 24,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: const Text(
                  'Do you need help to load/unload? (A charge of  USD 1 Per minute. 10 min minimum )',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: (needLoadUnload == 'Yes')
                              ? Colors.green
                              : Colors.white),
                      child: const Center(
                          child: Text(
                        "Yes",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    onTap: () {
                      setState(() {
                        needLoadUnload = 'Yes';
                      });
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: (needLoadUnload == 'No')
                              ? Colors.green
                              : Colors.white),
                      child: const Center(
                          child: Text(
                        "No",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    onTap: () {
                      setState(() {
                        needLoadUnload = 'No';
                      });
                      setState(() {});
                    },
                  ),
                  const Divider(
                    height: 20,
                  ),
                  (needLoadUnload == 'Yes')
                      ? TextField(
                          controller: needLoadUnloadTimeController,
                          keyboardType: TextInputType.number,

                          style: const TextStyle(
                              color: Colors.white, fontSize: 20.0),
                          //or null
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            labelText: 'How Much time you need?',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        )
                      : Container(),
                  const Divider(
                    height: 80,
                  ),
                ],
              )
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
                      pageTitle = 'New Job';
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
                  onPressed: () {
                    title = titleController.text;

                    barCodeItemNumber = barCodeItemNumberController.text;
                    weight = weightController.text;
                    height = heightController.text;
                    length = lengthController.text;
                    numberOfItem = numberOfItemController.text;
                    needLoadUnloadTime = needLoadUnloadTimeController.text;

                    bool isError = false;
                    if (title == '' ||
                        barCodeItem == '' ||
                        weight == '' ||
                        height == '' ||
                        length == '' ||
                        numberOfItem == '' ||
                        itemImage == '') {
                      isError = true;
                    }
                    if (needLoadUnload == 'Yes' && needLoadUnloadTime == '') {
                      isError = true;
                    }

                    if (!isError) {
                      // Get.defaultDialog(
                      //   title: "Alert!",
                      //   content: const Text("no Error"),
                      // );

                      setState(() {
                        currentPickPosition = CameraPosition(
                          target: LatLng(pickLat, pickLan),
                          zoom: 20,
                        );

                        pickMapController?.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(pickLat, pickLan), zoom: 20)));

                        pageTitle = 'Pickup Address';
                        _screenIndex = 2;
                      });
                      setState(() {});
                    } else {
                      Get.defaultDialog(
                        title: "Alert!",
                        content: const Text("All Fields are required"),
                      );
                    }

                    //itemImage;
                    //needLoadUnload;
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

  Widget pickupLocation(BuildContext context, firestoreUser) {
    return Stack(children: [
      SizedBox(
          height: (MediaQuery.of(context).size.height - 60),
          child: ListView(padding: const EdgeInsets.all(30), children: <Widget>[
            getMapArea(context, 'pick'),
            const Divider(
              height: 20,
            ),
            TextField(
              maxLines: 3, //or null
              controller: pickAddressController,
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
              //or null
              decoration: const InputDecoration(
                fillColor: Colors.white,
                labelText: 'Address',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const Divider(
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
              value: pickState.isNotEmpty
                  ? pickState
                  : null, // guard it with null if empty

              icon: const Icon(Icons.arrow_downward),
              elevation: 12,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
              hint: pickState != null
                  ? null
                  : const Text(
                      'State',
                      style: TextStyle(color: Colors.black),
                    ),

              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  pickState = value!;
                });
                getPickCitiesListData(value!);
              },
              items: statesData.map((String value) {
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
              value: (pickCity.isNotEmpty && pickCity != '')
                  ? pickCity
                  : null, // guard it with null if empty

              icon: const Icon(Icons.arrow_downward),
              elevation: 12,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
              hint: pickCity != null
                  ? null
                  : const Text(
                      'City',
                      style: TextStyle(color: Colors.black),
                    ),

              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  pickCity = value!;
                });
              },
              items: pickCitiesList.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Divider(
              height: 20,
            ),
            TextField(
              controller: pickZipController,
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
              //or null
              decoration: const InputDecoration(
                fillColor: Colors.white,
                labelText: 'Zip',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const Divider(
              height: 20,
            ),
          ])),
      Positioned(
        bottom: 0,
        child: Row(children: [
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  setState(() {
                    _screenIndex = 1;
                    pageTitle = 'Basic Info';
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
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  pickAddress = pickAddressController.text;
                  pickZip = pickZipController.text;

                  bool isError = false;
                  if (pickLan == '' ||
                      pickLat == '' ||
                      pickAddress == '' ||
                      pickZip == '' ||
                      pickCity == '' ||
                      pickState == '') {
                    isError = true;
                  }

                  if (!isError) {
                    setState(() {
                      dropMapController?.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(dropLat, dropLan), zoom: 20)));
                      _currentDropPosition = CameraPosition(
                        target: LatLng(dropLat, dropLan),
                        zoom: 20,
                      );

                      pageTitle = 'Drop Address';
                      _screenIndex = 3;
                    });
                    setState(() {});
                  } else {
                    Get.defaultDialog(
                      title: "Alert!",
                      content: const Text("All Fields are required"),
                    );
                  }
                },
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ))
        ]),
      )
    ]);
  }

  Widget dropLocation(BuildContext context, firestoreUser) {
    return Stack(children: [
      Container(
          height: (MediaQuery.of(context).size.height - 60),
          child: ListView(padding: const EdgeInsets.all(30), children: <Widget>[
            getMapArea(context, 'drop'),
            Divider(
              height: 20,
            ),
            TextField(
              maxLines: 3, //or null
              controller: dropAddressController,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              //or null
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Address',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            Divider(
              height: 20,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
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
              value: dropState.isNotEmpty
                  ? dropState
                  : null, // guard it with null if empty

              icon: const Icon(Icons.arrow_downward),
              elevation: 12,
              style: TextStyle(color: Colors.grey, fontSize: 15),
              hint: dropState != null
                  ? null
                  : Text(
                      'State',
                      style: TextStyle(color: Colors.black),
                    ),

              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropState = value!;
                });
                getDropCitiesListData(value!);
              },
              items: statesData.map((String value) {
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
              value: (dropCity.isNotEmpty && dropCity != '')
                  ? dropCity
                  : null, // guard it with null if empty

              icon: const Icon(Icons.arrow_downward),
              elevation: 12,
              style: TextStyle(color: Colors.grey, fontSize: 15),
              hint: dropCity != null
                  ? null
                  : Text(
                      'City',
                      style: TextStyle(color: Colors.black),
                    ),

              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropCity = value!;
                });
              },
              items: dropCitiesList.map((String value) {
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
              controller: dropZipController,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              //or null
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Zip',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            Divider(
              height: 20,
            ),
          ])),
      Positioned(
        bottom: 0,
        child: Row(children: [
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  setState(() {
                    pickMapController?.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(pickLat, pickLan), zoom: 20)));
                    currentPickPosition = CameraPosition(
                      target: LatLng(pickLat, pickLan),
                      zoom: 20,
                    );
                    _screenIndex = 2;
                    pageTitle = 'Pick Address';
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
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  dropAddress = dropAddressController.text;
                  dropZip = dropZipController.text;

                  bool isError = false;
                  if (dropLan == '' ||
                      dropLat == '' ||
                      dropAddress == '' ||
                      dropZip == '' ||
                      dropCity == '' ||
                      dropState == '') {
                    isError = true;
                  }

                  if (!isError) {
                    setState(() {
                      pageTitle = 'Verify Address';
                      _screenIndex = 4;
                    });
                    setState(() {});
                  } else {
                    Get.defaultDialog(
                      title: "Alert!",
                      content: const Text("All Fields are required"),
                    );
                  }
                },
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ))
        ]),
      )
    ]);
  }

  Widget confirmLocation(BuildContext context, firestoreUser) {
    return Stack(children: [
      Container(
          height: (MediaQuery.of(context).size.height - 60),
          child: ListView(padding: const EdgeInsets.all(30), children: <Widget>[
            Container(
              height: 400,
              child: GoogleMapsWidget(
                apiKey: googleApikey,
                sourceLatLng: LatLng(pickLat, pickLan),
                destinationLatLng: LatLng(dropLat!, dropLan!),

                ///////////////////////////////////////////////////////
                //////////////    OPTIONAL PARAMETERS    //////////////
                ///////////////////////////////////////////////////////

                routeWidth: 2,
                sourceMarkerIconInfo: MarkerIconInfo(
                  assetPath: "assets/images/marker.png",
                ),
                destinationMarkerIconInfo: MarkerIconInfo(
                  assetPath: "assets/images/marker.png",
                ),
                driverMarkerIconInfo: MarkerIconInfo(
                  assetPath: "assets/images/marker.png",
                  // assetMarkerSize: Size.square(125),
                  rotation: 90,
                ),
                updatePolylinesOnDriverLocUpdate: true,
                totalTimeCallback: (time) =>
                    print("Time Required" + time.toString()),
                totalDistanceCallback: (distance) => {
                  setState(() {
                    totalDistence = distance.toString();
                  })
                },
              ),
            ),
            Divider(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text('Total Distance : ' + totalDistence),
            ),
            Divider(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Text(
                    "Pick Address",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  Divider(
                    height: 10,
                  ),
                  Text(
                    pickAddress +
                        '\n' +
                        pickCity +
                        '\n' +
                        pickState +
                        '\n' +
                        pickZip,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            Divider(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Text(
                    "Drop Address",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  Divider(
                    height: 10,
                  ),
                  Text(
                    dropAddress +
                        '\n' +
                        dropCity +
                        '\n' +
                        dropState +
                        '\n' +
                        dropZip,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            Divider(
              height: 60,
            ),
          ])),
      Positioned(
        bottom: 0,
        child: Row(children: [
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  setState(() {
                    pickMapController?.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(pickLat, pickLan), zoom: 20)));
                    currentPickPosition = CameraPosition(
                      target: LatLng(pickLat, pickLan),
                      zoom: 20,
                    );

                    _screenIndex = 2;
                    pageTitle = 'Pick Address';
                  });
                },
                child: const Text(
                  'Update ',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              )),
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  setState(() {
                    pageTitle = 'Contact  Person';
                    _screenIndex = 5;
                  });
                  setState(() {});
                },
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ))
        ]),
      )
    ]);
  }

  Widget contactPersonDetails(BuildContext context, firestoreUser) {
    return Stack(children: [
      SizedBox(
          height: (MediaQuery.of(context).size.height - 60),
          child: ListView(padding: const EdgeInsets.all(30), children: <Widget>[
            TextField(
              controller: contactPersonNameController,
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
              //or null
              decoration: const InputDecoration(
                fillColor: Colors.white,
                labelText: 'Contact Person Name',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const Divider(
              height: 20,
            ),
            TextField(
              controller: contactPersonMobileController,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              //or null
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Contact Person Mobile',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            Divider(
              height: 20,
            ),
            TextField(
              controller: contactPersonAlternateMobileController,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              //or null
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Contact Person Alternate Mobile',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            Divider(
              height: 20,
            ),
            Divider(
              height: 20,
            ),
          ])),
      Positioned(
        bottom: 0,
        child: Row(children: [
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  setState(() {
                    _screenIndex = 4;
                    pageTitle = 'Confirm Address';
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
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  contactPersonName = contactPersonNameController.text;
                  contactPersonMobile = contactPersonMobileController.text;
                  contactPersonAlternateMobile =
                      contactPersonAlternateMobileController.text;
                  bool isError = false;
                  if (contactPersonName == '' ||
                      contactPersonMobile == '' ||
                      contactPersonAlternateMobile == '') {
                    isError = true;
                  }

                  if (!isError) {
                    setState(() {
                      pageTitle = 'Details Date & Time';
                      _screenIndex = 6;
                    });
                    setState(() {});
                  } else {
                    Get.defaultDialog(
                      title: "Alert!",
                      content: const Text("All Fields are required"),
                    );
                  }
                },
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ))
        ]),
      )
    ]);
  }

  Widget dateAndTime(BuildContext context, firestoreUser) {
    return Stack(children: [
      Container(
          height: (MediaQuery.of(context).size.height - 60),
          child: ListView(padding: const EdgeInsets.all(30), children: <Widget>[
            TextButton(
                onPressed: () {
                  DatePicker.showDatePicker(context, showTitleActions: true,
                      onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    setState(() {
                      dateForPickup = date;
                    });
                    setState(() {});
                    print('confirm $date');
                  }, currentTime: DateTime.now());
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.white, width: 1)),
                  child: Text(
                    'When to Deliver (Date for Pickup)',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
            Divider(
              height: 20,
            ),
            Center(
                child: Text(
              DateFormat('MM / dd / yyyy ').format(dateForPickup),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
            Divider(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  DatePicker.showTime12hPicker(context, showTitleActions: true,
                      onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    print('confirm $date');

                    setState(() {
                      timeForPickupLoad = date;
                    });
                    setState(() {});
                  }, currentTime: DateTime.now());
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.white, width: 1)),
                  child: const Text(
                    'When to Deliver (Time Pickup Load)',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
            const Divider(
              height: 20,
            ),
            Center(
                child: Text(
              DateFormat('kk:mm').format(timeForPickupLoad),
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
            const Divider(
              height: 60,
            ),
            const Divider(
              height: 20,
            ),
            Row(children: [
              Container(
                padding: EdgeInsets.only(left: 15),
                height: 30,
                width: MediaQuery.of(context).size.width / 2 - 30,
                child: Text(
                  "is Auto Bid?",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width / 2 - 30,
                child: Switch(
                  onChanged: setIsAutoBid,
                  value: isAutoBid,
                  activeColor: Colors.green,
                  activeTrackColor: Colors.yellow,
                  inactiveThumbColor: Colors.redAccent,
                  inactiveTrackColor: Colors.red,
                ),
              )
            ]),
            Divider(
              height: 20,
            ),
            isAutoBid
                ? TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        print('confirm $date');

                        setState(() {
                          autoBidStartDateTime = date;
                        });
                        setState(() {});
                      }, currentTime: DateTime.now());
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Text(
                        'Date And Time For Auto Bid',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ))
                : Container(),
            Divider(
              height: 20,
            ),
            isAutoBid
                ? Center(
                    child: Text(
                    DateFormat('MM / dd / yyyy ').format(autoBidStartDateTime),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))
                : Container(),
            Divider(
              height: 20,
            ),
          ])),
      Positioned(
        bottom: 0,
        child: Row(children: [
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  setState(() {
                    _screenIndex = 5;
                    pageTitle = 'Contact Person Detail';
                  });
                },
                child: const Text(
                  'Previous ',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              )),
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  // PickUpJobModel job = PickUpJobModel(
                  //   uid: firestoreUser.value!.uid,
                  //   uname: firestoreUser.value!.name,
                  //   title: title,
                  //   inputMethod: inputMethod,
                  //   barCodeItemNumber: barCodeItemNumber,
                  //   barCodeItem: barCodeItem,
                  //   weight: weight,
                  //   length: length,
                  //   height: height,
                  //   numberOfItem: numberOfItem,
                  //   itemImage: itemImage,
                  //   needLoadUnload: needLoadUnload,
                  //   needLoadUnloadTime: needLoadUnloadTime,
                  //   pickLat: pickLat,
                  //   pickLan: pickLan,
                  //   pickAddress: pickAddress,
                  //   pickState: pickState,
                  //   pickCity: pickCity,
                  //   pickZip: pickZip,
                  //   dropLat: dropLat,
                  //   dropLan: dropLan,
                  //   dropAddress: dropAddress,
                  //   dropState: dropState,
                  //   dropCity: dropCity,
                  //   dropZip: dropZip,
                  //   contactPersonName: contactPersonName,
                  //   contactPersonMobile: contactPersonMobile,
                  //   contactPersonAlternateMobile: contactPersonAlternateMobile,
                  //   dateForPickup: dateForPickup,
                  //   timeForPickupLoad: timeForPickupLoad,
                  //   isAutoBid: isAutoBid,
                  //   autoBidStartDateTime: autoBidStartDateTime,
                  //   createdon: DateTime.now(),
                  //   isDone: false,
                  //   status: 'Open',
                  //   amount: 0,
                  //   bid_id: "",
                  //   driver_id: "",
                  //   driver_name: "",
                  //   vehicle_id: "",
                  //   vehicle_name: "",
                  //   // after pickup start

                  //   driver_on_way_to_pickup: "",
                  //   driver_at_pickup_location: "",
                  //   user_picture_of_driver_with_driver_id: "",
                  //   driver_image_of_pickup_job: "",
                  //   driver_image_of_pickup_job_on_truck: "",
                  //   driver_confirm_pickup_job: "",
                  //   user_confirm_pickup_job: "",
                  //   driver_at_drop_off_loaction: "",
                  //   driver_pickupjob_delivered: "",
                  //   user_release_payment: "",
                  //   rating_to_driver: "",
                  //   rating_to_user: "",
                  //   review_for_customer: "",
                  //   review_for_user: "",
                  // );

                  // print(job);
                  // showLoadingIndicator();
                  // await FirestoreDb.addPickupJobs(job);
                  // hideLoadingIndicator();
                  // Get.offAll(userHome());

                  setState(() {
                    _screenIndex = 7;
                    pageTitle = 'Review Details';
                  });
                },
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ))
        ]),
      )
    ]);
  }

  Widget getMapArea(BuildContext context, locationType) {
    return Container(
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        height: 300,
        child: ListView(children: <Widget>[
          (locationType == 'pick')
              ? TextField(
                  controller: _pickSearchController,
                  decoration: const InputDecoration(
                    labelText: "Search",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      if (predictions.length > 0 && mounted) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    }
                  },
                )
              : TextField(
                  controller: _dropSearchController,
                  decoration: const InputDecoration(
                    labelText: "Search",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      if (predictions.length > 0 && mounted) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    }
                  },
                ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: (predictions.length > 0) ? 200 : 0,
            child: ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.pin_drop,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(predictions[index].description.toString()),
                  onTap: () async {
                    print(predictions[index].description);
                    debugPrint(predictions[index].placeId);

                    var result = await this
                        .googlePlace
                        .details
                        .get(predictions[index].placeId.toString());

                    // if (result != null && result.result != null && mounted) {
                    print("result detail Start " + locationType);
                    print(result?.result!.addressComponents);

                    var address = predictions[index].description;

                    double? latitude = result?.result!.geometry?.location?.lat;
                    double? longitude = result?.result!.geometry?.location?.lng;

                    setLocations(latitude!, longitude!, address, locationType);
                    //  }

                    setState(() {
                      if (locationType == 'pick') {
                        _pickSearchController.text =
                            predictions[index].description!;
                      } else {
                        _dropSearchController.text =
                            predictions[index].description!;
                      }
                      predictions = [];
                    });
                    setState(() {});
                  },
                );
              },
            ),
          ),
          SizedBox(
              height: 200,
              child: (locationType == 'pick')
                  ? GoogleMap(
                      key: pickMapKey,
                      onTap: (latLng) async {
                        placemarks = await placemarkFromCoordinates(
                            latLng.latitude, latLng.longitude);

                        setLocations(latLng.latitude, latLng.longitude,
                            placemarks[0].name, 'pick');

                        print(placemarks[0]);

                        print("hjhhjhjhjjhP");
                      },
                      initialCameraPosition: currentPickPosition,
                      onMapCreated: (pickController) {
                        print("pick map created start");
                        print(pickLat);
                        print(pickLan);
                        print("pick map created");
                        //method called when map is created
                        setState(() {
                          pickMapController = pickController;
                        });
                      },
                    )
                  : GoogleMap(
                      key: dropMapKey,
                      onTap: (latLng) async {
                        placemarks = await placemarkFromCoordinates(
                            latLng.latitude, latLng.longitude);

                        setLocations(latLng.latitude, latLng.longitude,
                            placemarks[0].name, 'drop');
                        print('Drop map is printed');

                        print('${latLng.latitude}, ${latLng.longitude}');

                        print("hjhhjhjhjjhP");
                      },
                      initialCameraPosition: _currentDropPosition,
                      onMapCreated: (dropController) {
                        //method called when map is created
                        setState(() {
                          print("drop map created start");
                          print(dropLat);
                          print(dropLan);
                          print("drop map created");

                          dropMapController = dropController;
                        });
                      },
                    ))
        ]));
  }

  void setLocations(double lat, double lan, address, type) {
    if (type == 'pick') {
      setState(() {
        pickLat = lat;
        pickLan = lan;
        pickAddress = address;
        pickAddressController.text = address;
        pickMapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lan), zoom: 25)));
      });
    } else {
      print("check drop location start ");
      print(lat);
      print(lan);
      print(address);
      print(type);

      print("check drop location end ");

      setState(() {
        dropLat = lat;
        dropLan = lan;
        dropAddress = address;
        dropAddressController.text = address;

        dropMapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lan), zoom: 25)));
      });
    }
  }

// Added Code for Review Details -->
  Widget reviewDetails(BuildContext context, firestoreUser) {
    return Stack(children: [
      SizedBox(
          height: (MediaQuery.of(context).size.height - 60),
          child: ListView(padding: const EdgeInsets.all(30), children: <Widget>[
            // Column for the Job Title, and Street Address -->
            detailsListWidget('Job Title', titleController.text,
                '$pickCity, $pickState, $pickZip'),
            Visibility(
              visible: barCodeItemNumber != '',
              child: detailsListWidget(
                  'Barcode Item Number', barCodeItemNumber, ''),
            ),
            detailsListWidget('Item Type', barCodeItem, ''),
            detailsListWidget('Number of Items', numberOfItem.toString(), ''),

            SizedBox(
              height: paddingMedium,
            ),
            // ListView for the Images Uploaded -->
            const Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Text('Items Pictures'),
            ),
            SizedBox(
              height: Get.height * 0.15,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: paddingSmall),
                      child: Card(
                          color: Colors.black,
                          child: SizedBox(
                            width: 100.0,
                            child: Image.network(
                              itemImage,
                              fit: BoxFit.fill,
                            ),
                          )),
                    );
                  }),
            ),
            SizedBox(
              height: paddingMedium,
            ),
            detailsListWidget('Need Loading Help?', needLoadUnload, ''),
            detailsListWidget('Pickup Address', pickAddressController.text,
                '$pickCity, $pickState, $pickZip'),
            detailsListWidget('Drop-off Address', dropAddressController.text,
                '$dropCity, $dropState, $dropZip'),
            detailsListWidget(
                'Job Date & Time',
                '${DateFormat.yMd().format(dateForPickup)} \n${DateFormat.jms().format(timeForPickupLoad)}',
                ''),
            detailsListWidget('Contact Time:',
                DateFormat.jms().format(timeForPickupLoad), ''),

            const SizedBox(
              height: 60.0,
            )
          ])),
      Positioned(
        bottom: 0,
        child: Row(children: [
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  setState(() {
                    _screenIndex = 5;
                    pageTitle = 'Contact Person Detail';
                  });
                },
                child: const Text(
                  'Previous ',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              )),
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  PickUpJobModel job = PickUpJobModel(
                    uid: firestoreUser.value!.uid,
                    uname: firestoreUser.value!.name,
                    title: title,
                    inputMethod: inputMethod,
                    barCodeItemNumber: barCodeItemNumber,
                    barCodeItem: barCodeItem,
                    weight: weight,
                    length: length,
                    height: height,
                    numberOfItem: numberOfItem,
                    itemImage: itemImage,
                    needLoadUnload: needLoadUnload,
                    needLoadUnloadTime: needLoadUnloadTime,
                    pickLat: pickLat,
                    pickLan: pickLan,
                    pickAddress: pickAddress,
                    pickState: pickState,
                    pickCity: pickCity,
                    pickZip: pickZip,
                    dropLat: dropLat,
                    dropLan: dropLan,
                    dropAddress: dropAddress,
                    dropState: dropState,
                    dropCity: dropCity,
                    dropZip: dropZip,
                    contactPersonName: contactPersonName,
                    contactPersonMobile: contactPersonMobile,
                    contactPersonAlternateMobile: contactPersonAlternateMobile,
                    dateForPickup: dateForPickup,
                    timeForPickupLoad: timeForPickupLoad,
                    isAutoBid: isAutoBid,
                    autoBidStartDateTime: autoBidStartDateTime,
                    createdon: DateTime.now(),
                    isDone: false,
                    status: 'Open',
                    amount: 0,
                    bid_id: "",
                    driver_id: "",
                    driver_name: "",
                    vehicle_id: "",
                    vehicle_name: "",
                    // after pickup start

                    driver_on_way_to_pickup: "",
                    driver_at_pickup_location: "",
                    user_picture_of_driver_with_driver_id: "",
                    driver_image_of_pickup_job: "",
                    driver_image_of_pickup_job_on_truck: "",
                    driver_confirm_pickup_job: "",
                    user_confirm_pickup_job: "",
                    driver_at_drop_off_loaction: "",
                    driver_pickupjob_delivered: "",
                    user_release_payment: "",
                    rating_to_driver: "",
                    rating_to_user: "",
                    review_for_customer: "",
                    review_for_user: "",
                  );

                  print(job);
                  showLoadingIndicator();
                  await FirestoreDb.addPickupJobs(job);
                  hideLoadingIndicator();
                  Get.offAll(userHome());
                },
                child: const Text(
                  'Save Order',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ))
        ]),
      )
    ]);
  }

// Review Details List Tile Widget -->
  Widget detailsListWidget(
      String title, String subtitle, String additionalText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: appWhite, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            subtitle,
            style: TextStyle(color: appWhite, fontWeight: FontWeight.w400),
          ),
          Visibility(
              visible: additionalText != '',
              child: Text(
                additionalText,
                style: TextStyle(color: appWhite, fontWeight: FontWeight.w400),
              ))
        ],
      ),
    );
  }
}
