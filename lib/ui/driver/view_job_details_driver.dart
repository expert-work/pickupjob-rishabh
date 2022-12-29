import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import '../../constants.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import 'package:pickupjob/helpers/firestore_db.dart';

class ViewJobDriver extends StatefulWidget {
  const ViewJobDriver({super.key});

  @override
  State<ViewJobDriver> createState() => _ViewJobDriverState();
}

class _ViewJobDriverState extends State<ViewJobDriver> {
  dynamic argumentData = Get.arguments;
  final authController = Get.find<AuthController>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String googleApikey = "AIzaSyCe2c5wnzwWCrtk-U-MvBIbvVn2rswuxpQ";
//drop
  static Key dropMapKey = ObjectKey('dropMapKey');

  static Key pickMapKey = ObjectKey('pickMapKey');

  TextEditingController barCodeItemNumberController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController barCodeItemController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController numberOfItemController = TextEditingController();
  TextEditingController needLoadUnloadTimeController = TextEditingController();
  //pick Addreess

  TextEditingController bid_amountController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();

  late double pickLat;
  late double pickLan;
  String pickAddress = '';
  String pickState = '';
  String pickCity = '';
  String pickZip = '';

  late double dropLat;
  late double dropLan;
  String dropAddress = '';
  String dropState = '';
  String dropCity = '';
  String dropZip = '';

  String totalDistence = "0";
  String needLoadUnload = "No";

  String selected_vehicle = "";
  bool isApplied = false;
  @override
  void initState() {
    pickLat = argumentData['pickLat'];
    pickLan = argumentData['pickLan'];
    pickAddress = argumentData['pickAddress'];
    pickState = argumentData['pickState'];
    pickCity = argumentData['pickCity'];
    pickZip = argumentData['pickZip'];

    dropLat = argumentData['dropLat'];
    dropLan = argumentData['dropLan'];
    dropAddress = argumentData['dropAddress'];
    dropState = argumentData['dropState'];
    dropCity = argumentData['dropCity'];
    dropZip = argumentData['dropZip'];

    needLoadUnload = argumentData['needLoadUnload'];

    barCodeItemNumberController.text = argumentData['barCodeItemNumber'];
    titleController.text = argumentData['title'];

    barCodeItemController.text = argumentData['barCodeItem'];
    weightController.text = argumentData['weight'];

    lengthController.text = argumentData['length'];
    heightController.text = argumentData['height'];
    numberOfItemController.text = argumentData['numberOfItem'];
    needLoadUnloadTimeController.text = argumentData['needLoadUnloadTime'];
    checkIsAlreadyApplied();
    super.initState();
  }

  checkIsAlreadyApplied() async {
    int check = await firebaseFirestore
        .collection('bids')
        .where("driver_id", isEqualTo: auth.currentUser!.uid)
        .where("job_id", isEqualTo: argumentData['id'])
        .get()
        .then((res) => res.size);

    setState(() {
      isApplied = (check > 0);
    });
    print("JobAlreayAppliedOrnt");
    print(check);
    print("JobAlreayAppliedOrntend");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black87,
          title: Text(argumentData['title'].toString()),
        ),
        body: ListView(padding: const EdgeInsets.all(10), children: <Widget>[
          Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 1.0, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  TextField(
                    readOnly: true,
                    controller: titleController,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                    //or null
                    decoration: InputDecoration(
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
                  Divider(
                    height: 24,
                  ),
                  TextField(
                    readOnly: true,
                    controller: barCodeItemNumberController,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                    //or null
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'Barcode item Number',
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
                    readOnly: true,
                    controller: barCodeItemController,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                    //or null
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'Barcode item',
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
                  Container(
                    height: 60,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3 - 20,
                            child: TextField(
                              readOnly: true,
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              //or null
                              decoration: InputDecoration(
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
                          Container(
                            width: MediaQuery.of(context).size.width / 3 - 20,
                            child: TextField(
                              readOnly: true,
                              controller: lengthController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              //or null
                              decoration: InputDecoration(
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
                          Container(
                            width: MediaQuery.of(context).size.width / 3 - 20,
                            child: TextField(
                              readOnly: true,
                              controller: heightController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              //or null
                              decoration: InputDecoration(
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
                  Divider(
                    height: 24,
                  ),
                  Divider(
                    height: 24,
                  ),
                  Divider(
                    height: 24,
                  ),
                  TextField(
                    readOnly: true,
                    controller: numberOfItemController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                    //or null
                    decoration: InputDecoration(
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
                  Divider(
                    height: 24,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      'Pic of Item',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Container(
                    child: Image.network(
                      argumentData['itemImage'],
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
                  ),
                  Divider(
                    height: 24,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      'Do you need help to load/unload? (A charge of  USD 1 Per minute. 10 min minimum )',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: (needLoadUnload == 'Yes')
                                ? Color.fromARGB(255, 30, 73, 31)
                                : Colors.white),
                        child: Center(
                            child: Text(
                          needLoadUnload.toString(),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      Divider(
                        height: 20,
                      ),
                      (needLoadUnload == 'Yes')
                          ? TextField(
                              readOnly: true,
                              controller: needLoadUnloadTimeController,
                              keyboardType: TextInputType.number,

                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              //or null
                              decoration: InputDecoration(
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
                      Divider(
                        height: 80,
                      ),
                    ],
                  ),
                ],
              )),
          Divider(
            height: 24,
          ),
          Container(
            height: 400,
            color: Colors.black,
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
                color: Colors.black,
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
                color: Colors.black,
                border: Border.all(width: 1.0, color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Pick Address",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                Divider(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    pickAddress +
                        '\n' +
                        pickCity +
                        '\n' +
                        pickState +
                        '\n' +
                        pickZip,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(width: 1.0, color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Drop Address",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                Divider(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dropAddress +
                        '\n' +
                        dropCity +
                        '\n' +
                        dropState +
                        '\n' +
                        dropZip,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 60,
          ),
          Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 1.0, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Contact Person Name",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(argumentData['contactPersonName'].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                Divider(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Contact Person Mobile",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(argumentData['contactPersonMobile'].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                Divider(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Contact Alternate Mobile",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      argumentData['contactPersonAlternateMobile'].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ])),

          //Edit
          //View Applications
          isApplied
              ? Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.green),
                  child: Center(
                      child: Text(
                    "Already Appled",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )),
                )
              : InkWell(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.red),
                    child: Center(
                        child: Text(
                      "Bid Now",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  onTap: () => {bidNow(context, argumentData)},
                )
        ]));
  }

  bidNow(context, job) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
              child: ListView(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // SizedBox(
                  //   height: 100,
                  // ),
                  Container(
                    child: TextField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      minLines: 2, //Normal textInputField will be displayed
                      maxLines: 6,
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                      //or null
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.all(15),
                  ),

                  GetBuilder<VehicleController>(
                      init: VehicleController(),
                      builder: (VehicleController vehicleController) {
                        return Container(
                            padding: EdgeInsets.all(15),
                            child: DropdownButtonFormField(
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),

                              decoration: InputDecoration(
                                fillColor: Colors.black,
                                labelText: 'Vehicle',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              hint: Text(
                                  'Select Vehicle'), // Not necessary for Option 1

                              items: vehicleController.myVehiclesOpen
                                  .map((VehicleModel value) {
                                return DropdownMenuItem(
                                  value: value.id,
                                  child: Text(value.title.toString()),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selected_vehicle = value as String;
                                });

                                print(selected_vehicle);
                              },
                            ));
                      }),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 140,
                          child: TextField(
                            controller: bid_amountController,
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            //or null
                            decoration: InputDecoration(
                              fillColor: Colors.black,
                              labelText: 'Bid Amount (USD)',
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.all(15),
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.all(10),
                            width: 130,
                            decoration: BoxDecoration(color: Colors.black),
                            child: Center(
                                child: Text(
                              "Bid",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          onTap: () async {
                            var driver =
                                (await authController.getFirestoreUser());

                            var selected_vehicle_data = await _db
                                .doc('/vehicles/${selected_vehicle}')
                                .get()
                                .then((documentSnapshot) =>
                                    VehicleModel.fromMap(
                                        documentSnapshot.data()!));

                            print("selected_vehicle_data");
                            print(selected_vehicle_data);
                            print(selected_vehicle_data.title);
                            print("selected_vehicle_data");

                            BidModel _data = BidModel(
                              user_id: job['uid'].toString(),
                              user_name: job['uname'].toString(),
                              job_id: job['id'].toString(),
                              job_title: job['title'].toString(),
                              job_image: job['itemImage'].toString(),
                              selected_vehicle: selected_vehicle,
                              selected_vehicle_title:
                                  selected_vehicle_data.title.toString(),
                              selected_vehicle_picture:
                                  selected_vehicle_data.pictureOfVehicle,
                              make: selected_vehicle_data.make,
                              model: selected_vehicle_data.model,
                              year: selected_vehicle_data.year,
                              bid_amount: bid_amountController.text,
                              message: messageController.text,
                              status: "applied",
                              driver_id: auth.currentUser!.uid,
                              driver_name: driver.name,
                              updatedon: DateTime.now().toString(),
                              createdon: DateTime.now().toString(),
                            );

                            await FirestoreDb.addBids(_data);
                            FirestoreDb.sendPushMessage(
                                _data.user_id.toString(),
                                'Received New Bid On ' +
                                    _data.job_title.toString(),
                                _data.driver_name.toString() +
                                    ' Submitted a bid on ' +
                                    _data.job_title.toString());
                          },
                        ),
                      ]),
                ],
              ),
              padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).viewInsets.collapsedSize.height));
        });
  }
}
