import 'dart:async';
import 'dart:io';
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

class addVehicle extends StatefulWidget {
  const addVehicle({super.key});

  @override
  State<addVehicle> createState() => _addVehicleState();
}

class _addVehicleState extends State<addVehicle> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  TextEditingController titleController = TextEditingController();
  TextEditingController ownThisVehicleController = TextEditingController();
  TextEditingController ownerOfVehicleController = TextEditingController();
  TextEditingController leaseContactInfoController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController pictureOfVehicleController = TextEditingController();
  TextEditingController pictureOfLicPlateController = TextEditingController();
  TextEditingController pictureOfVehicleRegController = TextEditingController();

  TextEditingController vehicleInsurenceProviderController =
      TextEditingController();
  TextEditingController vehicleInsurencePolicyNameController =
      TextEditingController();
  TextEditingController pictureOfVehicleInsurenceCardController =
      TextEditingController();
  TextEditingController ableToTransportController = TextEditingController();
  TextEditingController specialFeaturesCargoVansController =
      TextEditingController();
  TextEditingController specialFeaturespickupTrucksController =
      TextEditingController();

  String title = "";
  String ownThisVehicle = "You own this Vehicle?";
  String ownerOfVehicle = "";
  String leaseContactInfo = "";
  String year = "";
  String make = "";
  String model = "";
  String pictureOfVehicle = "";
  String pictureOfLicPlate = "";
  String pictureOfVehicleReg = "";
  String pictureOfVehicleInspection = "";
  String vehicleInsurenceProvider = "";
  String vehicleInsurencePolicyName = "";
  String pictureOfVehicleInsurenceCard = "";
  String ableToTransport = "";
  String specialFeaturesCargoVans = "";
  String specialFeaturespickupTrucks = "";

  var ownThisVehicleOptions = [
    'You own this Vehicle?',
    'Yes',
    'No',
  ];

  static List<OptionsModel> ableToTransportArray = [
    OptionsModel(id: 1, title: 'Applicance'),
    OptionsModel(id: 2, title: 'Auto Parts'),
    OptionsModel(id: 3, title: 'Bath All'),
    OptionsModel(id: 4, title: 'BBQ Grills'),
    OptionsModel(id: 5, title: 'Bricks/Pavers'),
    OptionsModel(id: 6, title: 'Boats On Trailers'),
    OptionsModel(id: 7, title: 'Bikes (All)'),
    OptionsModel(id: 8, title: 'Bikes Electric'),
    OptionsModel(id: 9, title: 'Building Materials'),
    OptionsModel(id: 10, title: 'Cabinets'),
    OptionsModel(id: 11, title: 'Cars on Trailers'),
    OptionsModel(id: 12, title: 'Canoes & Kayaks'),
    OptionsModel(id: 13, title: 'Cement Bags'),
    OptionsModel(id: 14, title: 'Cement Mixer'),
    OptionsModel(id: 15, title: 'Chickens Non-Commercial'),
    OptionsModel(id: 16, title: 'Chicken Coops'),
    OptionsModel(id: 17, title: 'Dirt & Gravel'),
    OptionsModel(id: 18, title: 'Drywall'),
    OptionsModel(id: 19, title: 'Firewood'),
    OptionsModel(id: 20, title: 'Furniture'),
    OptionsModel(id: 21, title: 'Furniture Antique'),
    OptionsModel(id: 22, title: 'Furniture Outdoor'),
    OptionsModel(id: 23, title: 'Fire Pits (Metal)'),
    OptionsModel(id: 24, title: 'Garden Tools'),
    OptionsModel(id: 25, title: 'Generators'),
    OptionsModel(id: 26, title: 'Gravel/Aggregate'),
    OptionsModel(id: 27, title: 'Heater Outdoor'),
    OptionsModel(id: 28, title: 'Heater Indoor'),
    OptionsModel(id: 29, title: 'Horses in Horse Trailer'),
    OptionsModel(id: 30, title: 'HVAC'),
    OptionsModel(id: 31, title: 'JUNK'),
    OptionsModel(id: 32, title: 'Ladders'),
    OptionsModel(id: 33, title: 'Lawn Equipment'),
    OptionsModel(id: 34, title: 'Lights In/Outdoor'),
    OptionsModel(id: 35, title: 'Livestock'),
    OptionsModel(id: 36, title: 'Paint'),
    OptionsModel(id: 37, title: 'Plywood'),
    OptionsModel(id: 38, title: 'Produce All'),
    OptionsModel(id: 39, title: 'Matress'),
    OptionsModel(id: 40, title: 'Mowers - Push'),
    OptionsModel(id: 41, title: 'Mowers - Riding'),
    OptionsModel(id: 42, title: 'Motorcycle'),
    OptionsModel(id: 43, title: 'Mulch'),
    OptionsModel(id: 44, title: 'Rugs'),
    OptionsModel(id: 45, title: 'Sheds'),
    OptionsModel(id: 46, title: 'Sand/Gravel'),
    OptionsModel(id: 47, title: 'Scouters Electric'),
    OptionsModel(id: 48, title: 'Scouters Gas Riding'),
    OptionsModel(id: 49, title: 'Scouters Handicap'),
    OptionsModel(id: 50, title: 'Solar Panels'),
    OptionsModel(id: 51, title: 'Table And Chairs'),
    OptionsModel(id: 52, title: 'Tires/Parts'),
    OptionsModel(id: 53, title: 'Trash Cans')
  ];
  final ableToTransportOptions = ableToTransportArray
      .map((item) => MultiSelectItem<OptionsModel>(item, item.title))
      .toList();
  List ableToTransportSelected = [];

  static List<OptionsModel> specialFeaturesCargoVansArray = [
    OptionsModel(id: 1, title: 'Blankets'),
    OptionsModel(id: 2, title: 'Cargo Straps'),
    OptionsModel(id: 3, title: 'Cube Feet Less 100'),
    OptionsModel(id: 3, title: 'Cube Feet Less 200'),
    OptionsModel(id: 3, title: 'Cube Feet Less 500'),
    OptionsModel(id: 3, title: 'Cube Feet Less 800'),
    OptionsModel(id: 4, title: 'Util Rack'),
    OptionsModel(id: 5, title: 'Ladder Rack')
  ];
  final specialFeaturesCargoVansOptions = specialFeaturesCargoVansArray
      .map((item) => MultiSelectItem<OptionsModel>(item, item.title))
      .toList();
  List specialFeaturesCargoVansSelected = [];

  static List<OptionsModel> specialFeaturespickupTrucksArray = [
    OptionsModel(id: 1, title: 'Bed Cover (Soft Top)'),
    OptionsModel(id: 2, title: 'Bed Cover (Hard Top)'),
    OptionsModel(id: 3, title: 'Cargo Straps'),
    OptionsModel(id: 4, title: 'Cargo Tommy Lift'),
    OptionsModel(id: 5, title: 'Enclosed Back CAB'),
    OptionsModel(id: 6, title: 'Extended Bed'),
    OptionsModel(id: 7, title: 'Flatbed Tow Truck'),
    OptionsModel(id: 8, title: 'Ladder Rack'),
    OptionsModel(id: 9, title: 'Tailgate Step'),
    OptionsModel(id: 10, title: 'Tow Hitch'),
    OptionsModel(id: 11, title: 'Tow Truck'),
    OptionsModel(id: 12, title: 'Utility Lawn Trailer'),
    OptionsModel(id: 12, title: 'Utility Dump Trailer'),
  ];
  final specialFeaturespickupTrucksOptions = specialFeaturespickupTrucksArray
      .map((item) => MultiSelectItem<OptionsModel>(item, item.title))
      .toList();
  List specialFeaturespickupTrucksSelected = [];

  Future<String> uploadImageToFirebase() async {
    final XFile? image = await _picker.pickImage(
        // source: ImageSource.gallery,
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);

    var imageFile = File(image!.path);
    String fileName = basename(imageFile.path);
    print("image upload started");
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
    }
  }

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
                  title: const Text('Add Vehicle'),
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
                body: Stack(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          color: Colors.black87,
                        ),
                        height: (MediaQuery.of(context).size.height - 60),
                        child: ListView(
                            padding: const EdgeInsets.all(30),
                            children: <Widget>[
                              TextField(
                                controller: titleController,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: 'Nick Name Of Vehicle',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 14,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.white),
                                  ),
                                ),
                                padding: EdgeInsets.only(top: 10, bottom: 3),
                                child: DropdownButton(
                                  value: ownThisVehicle,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items:
                                      ownThisVehicleOptions.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      ownThisVehicle = newValue!;
                                    });
                                    setState(() {});
                                  },
                                  style: const TextStyle(
                                      color: Colors.white, //Font color
                                      fontSize:
                                          20 //font size on dropdown button
                                      ),
                                  dropdownColor: Colors.black87,
                                  underline: Container(), //remove underline
                                  //dropdown background color
                                  isExpanded: true,
                                ),
                              ),
                              Divider(
                                height: 14,
                              ),
                              (ownThisVehicle == 'No')
                                  ? TextField(
                                      controller: ownerOfVehicleController,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        labelText: 'Owner Of Vehicle',
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              (ownThisVehicle == 'No')
                                  ? Divider(
                                      height: 24,
                                    )
                                  : Container(),
                              (ownThisVehicle == 'No')
                                  ? TextField(
                                      controller: leaseContactInfoController,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        labelText: 'Lease Contact Info',
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              (ownThisVehicle == 'No')
                                  ? Divider(
                                      height: 24,
                                    )
                                  : Container(),
                              TextField(
                                controller: yearController,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: 'Year',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 14,
                              ),
                              TextField(
                                controller: makeController,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: 'Make',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 14,
                              ),
                              TextField(
                                controller: modelController,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: 'Model',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 14,
                              ),
                              TextField(
                                controller: vehicleInsurenceProviderController,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: 'Insurence Provider',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 14,
                              ),
                              TextField(
                                controller:
                                    vehicleInsurencePolicyNameController,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: 'Vehicle Insurence Policy Name',
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
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Picture Of Vehicle InsurenceCard',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              Container(
                                child: InkWell(
                                  child: Image.network(
                                    (pictureOfVehicleInsurenceCard == '')
                                        ? "https://cdn-icons-png.flaticon.com/512/4653/4653792.png"
                                        : pictureOfVehicleInsurenceCard,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
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
                                  onTap: () async {
                                    String url = await uploadImageToFirebase();

                                    setState(() {
                                      pictureOfVehicleInsurenceCard = url;
                                    });
                                    setState(() {});
                                  },
                                ),
                              ),
                              Divider(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Picture Of Vehicle',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              Container(
                                child: InkWell(
                                  child: Image.network(
                                    (pictureOfVehicle == '')
                                        ? "https://cdn-icons-png.flaticon.com/512/4653/4653792.png"
                                        : pictureOfVehicle,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
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
                                  onTap: () async {
                                    String url = await uploadImageToFirebase();

                                    setState(() {
                                      pictureOfVehicle = url;
                                    });
                                    setState(() {});
                                  },
                                ),
                              ),
                              Divider(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Picture Of Lic Plate',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              Container(
                                child: InkWell(
                                  child: Image.network(
                                    (pictureOfLicPlate == '')
                                        ? "https://cdn-icons-png.flaticon.com/512/4653/4653792.png"
                                        : pictureOfLicPlate,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
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
                                  onTap: () async {
                                    String url = await uploadImageToFirebase();

                                    setState(() {
                                      pictureOfLicPlate = url;
                                    });
                                    setState(() {});
                                  },
                                ),
                              ),
                              Divider(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Picture Of Vehicle Reg',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              Container(
                                child: InkWell(
                                  child: Image.network(
                                    (pictureOfVehicleReg == '')
                                        ? "https://cdn-icons-png.flaticon.com/512/4653/4653792.png"
                                        : pictureOfVehicleReg,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
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
                                  onTap: () async {
                                    String url = await uploadImageToFirebase();

                                    setState(() {
                                      pictureOfVehicleReg = url;
                                    });
                                    setState(() {});
                                  },
                                ),
                              ),
                              Divider(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Picture Of Vehicle Inspection',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              Container(
                                child: InkWell(
                                  child: Image.network(
                                    (pictureOfVehicleInspection == '')
                                        ? "https://cdn-icons-png.flaticon.com/512/4653/4653792.png"
                                        : pictureOfVehicleInspection,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
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
                                  onTap: () async {
                                    String url = await uploadImageToFirebase();

                                    setState(() {
                                      pictureOfVehicleInspection = url;
                                    });
                                    print(pictureOfVehicleInspection);
                                    setState(() {});
                                  },
                                ),
                              ),
                              Divider(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Able To Transport',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              //ableToTransport

                              MultiSelectBottomSheetField(
                                initialChildSize: 0.4,
                                listType: MultiSelectListType.CHIP,
                                searchable: true,
                                buttonText: Text("Able To Transport"),
                                title: Text("Able To Transport"),
                                items: ableToTransportOptions,
                                onConfirm: (values) {
                                  ableToTransportSelected = values;
                                  var temp = [];
                                  values
                                      .toList()
                                      .cast<OptionsModel>()
                                      .forEach((element) {
                                    temp.add(element.title);

                                    // print(element.title);
                                  });
                                  setState(() {
                                    ableToTransport = temp.toString();
                                  });
                                  print(ableToTransportSelected);
                                },
                                chipDisplay: MultiSelectChipDisplay(
                                  onTap: (value) {
                                    setState(() {
                                      ableToTransportSelected.remove(value);
                                    });
                                  },
                                ),
                              ),

                              const Divider(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: const Text(
                                  'Special Features Cargo Vans',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              //specialFeaturesCargoVans
                              MultiSelectBottomSheetField(
                                initialChildSize: 0.4,
                                listType: MultiSelectListType.CHIP,
                                searchable: true,
                                buttonText: Text("Special Features Cargo Vans"),
                                title: Text("Special Features Cargo Vans"),
                                items: specialFeaturesCargoVansOptions,
                                onConfirm: (values) {
                                  specialFeaturesCargoVansSelected = values;
                                  var temp = [];
                                  values
                                      .toList()
                                      .cast<OptionsModel>()
                                      .forEach((element) {
                                    temp.add(element.title);

                                    // print(element.title);
                                  });
                                  setState(() {
                                    specialFeaturesCargoVans = temp.toString();
                                  });
                                },
                                chipDisplay: MultiSelectChipDisplay(
                                  onTap: (value) {
                                    setState(() {
                                      specialFeaturesCargoVansSelected
                                          .remove(value);
                                    });
                                  },
                                ),
                              ),

                              Divider(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Special Features Pickup Trucks',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              //specialFeaturespickupTrucks

                              MultiSelectBottomSheetField(
                                initialChildSize: 0.4,
                                listType: MultiSelectListType.CHIP,
                                searchable: true,
                                buttonText:
                                    Text("Special Features Pickup Trucks"),
                                title: Text("Special Features Pickup Trucks"),
                                items: specialFeaturespickupTrucksOptions,
                                onConfirm: (values) {
                                  specialFeaturespickupTrucksSelected = values;
                                  var temp = [];
                                  values
                                      .toList()
                                      .cast<OptionsModel>()
                                      .forEach((element) {
                                    temp.add(element.title);

                                    // print(element.title);
                                  });

                                  setState(() {
                                    specialFeaturespickupTrucks =
                                        temp.toString();
                                  });
                                  print(specialFeaturespickupTrucksSelected);
                                },
                                chipDisplay: MultiSelectChipDisplay(
                                  onTap: (value) {
                                    setState(() {
                                      specialFeaturespickupTrucksSelected
                                          .remove(value);
                                    });
                                  },
                                ),
                              ),

                              Divider(
                                height: 80,
                              ),
                            ])),
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
                                title = titleController.text;
                                ownerOfVehicle = ownerOfVehicleController.text;
                                leaseContactInfo =
                                    leaseContactInfoController.text;

                                year = yearController.text;
                                make = makeController.text;
                                model = modelController.text;
                                vehicleInsurenceProvider =
                                    vehicleInsurenceProviderController.text;
                                vehicleInsurencePolicyName =
                                    vehicleInsurencePolicyNameController.text;

                                bool canSubmit = false;
                                if (ownThisVehicle == "You own this Vehicle?") {
                                  Get.defaultDialog(
                                    title: "Alert!",
                                    content: Text(
                                        "You own this Vehicle? please select"),
                                  );
                                } else {
                                  if (ownThisVehicle == "Yes") {
                                    if (title == "" ||
                                        year == "" ||
                                        make == "" ||
                                        model == "" ||
                                        pictureOfVehicle == "" ||
                                        pictureOfLicPlate == "" ||
                                        pictureOfVehicleReg == "" ||
                                        pictureOfVehicleInspection == "" ||
                                        vehicleInsurenceProvider == "" ||
                                        vehicleInsurencePolicyName == "" ||
                                        pictureOfVehicleInsurenceCard == "" ||
                                        ableToTransport == "" ||
                                        specialFeaturesCargoVans == "" ||
                                        specialFeaturespickupTrucks == "") {
                                      Get.defaultDialog(
                                        title: "Alert!",
                                        content: const Text(
                                            "All Fields are required"),
                                      );
                                    } else {
                                      canSubmit = true;
                                    }
                                  }

                                  if (ownThisVehicle == "No") {
                                    if (title == "" ||
                                        ownerOfVehicle == "" ||
                                        leaseContactInfo == "" ||
                                        year == "" ||
                                        make == "" ||
                                        model == "" ||
                                        pictureOfVehicle == "" ||
                                        pictureOfLicPlate == "" ||
                                        pictureOfVehicleReg == "" ||
                                        pictureOfVehicleInspection == "" ||
                                        vehicleInsurenceProvider == "" ||
                                        vehicleInsurencePolicyName == "" ||
                                        pictureOfVehicleInsurenceCard == "" ||
                                        ableToTransport == "" ||
                                        specialFeaturesCargoVans == "" ||
                                        specialFeaturespickupTrucks == "") {
                                      Get.defaultDialog(
                                        title: "Alert!",
                                        content: const Text(
                                            "All Fields are required"),
                                      );
                                    } else {
                                      canSubmit = true;
                                    }
                                  }
                                }

                                if (canSubmit) {
                                  VehicleModel _data = VehicleModel(
                                      uid: controller.firestoreUser.value!.uid,
                                      uname:
                                          controller.firestoreUser.value!.name,
                                      driverId:
                                          controller.firestoreUser.value!.uid,
                                      title: title,
                                      ownThisVehicle: ownThisVehicle,
                                      ownerOfVehicle: ownerOfVehicle,
                                      leaseContactInfo: leaseContactInfo,
                                      year: year,
                                      make: make,
                                      model: model,
                                      pictureOfVehicle: pictureOfVehicle,
                                      pictureOfLicPlate: pictureOfLicPlate,
                                      pictureOfVehicleReg: pictureOfVehicleReg,
                                      pictureOfVehicleInspection:
                                          pictureOfVehicleInspection,
                                      vehicleInsurenceProvider:
                                          vehicleInsurenceProvider,
                                      vehicleInsurencePolicyName:
                                          vehicleInsurencePolicyName,
                                      pictureOfVehicleInsurenceCard:
                                          pictureOfVehicleInsurenceCard,
                                      ableToTransport: ableToTransport,
                                      specialFeaturesCargoVans:
                                          specialFeaturesCargoVans,
                                      specialFeaturespickupTrucks:
                                          specialFeaturespickupTrucks,
                                      status: 'Open');

                                  print(_data);
                                  showLoadingIndicator();
                                  await FirestoreDb.addVehicle(_data);
                                  hideLoadingIndicator();
                                  Get.offAll(driverHome());
                                }
                                print(vehicleInsurencePolicyName);
                                print(pictureOfVehicleInsurenceCard);
                                print(ableToTransport);
                                print(specialFeaturesCargoVans);
                                print(specialFeaturespickupTrucks);

                                print(title);
                                print(ownThisVehicle);
                                print(ownerOfVehicle);
                                print(leaseContactInfo);

                                print(year);
                                print(make);
                                print(model);

                                print(pictureOfVehicle);
                                print(pictureOfLicPlate);

                                print(pictureOfVehicleReg);
                                print(pictureOfVehicleInspection);
                                print(vehicleInsurenceProvider);

// title
// ownThisVehicle
// ownerOfVehicle
// leaseContactInfo

// year
// make
// model

// pictureOfVehicle
// pictureOfLicPlate

// pictureOfVehicleReg
// pictureOfVehicleInspection
// vehicleInsurenceProvider

// vehicleInsurencePolicyName
// pictureOfVehicleInsurenceCard
// ableToTransport
// specialFeaturesCargoVans
// specialFeaturespickupTrucks

                                if (specialFeaturesCargoVans == "") {
                                  print("not clicked");
                                }
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ))
                      ]),
                    )
                  ],
                )));
  }
}

class OptionsModel {
  final int id;
  final String title;

  OptionsModel({
    required this.id,
    required this.title,
  });
}
