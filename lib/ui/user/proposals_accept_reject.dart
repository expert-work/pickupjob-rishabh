import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pickupjob/models/models.dart';
import 'package:pickupjob/models/pickupjob_model.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

import '../../controllers/controllers.dart';
import '../../helpers/firestore_db.dart';

class ProposalsAcceptReject extends StatefulWidget {
  const ProposalsAcceptReject({super.key});

  @override
  State<ProposalsAcceptReject> createState() => _ProposalsAcceptRejectState();
}

class _ProposalsAcceptRejectState extends State<ProposalsAcceptReject> {
  dynamic argumentData = Get.arguments;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthController authController = AuthController.to;
  late PickUpJobModel pickupjob;
  late BidModel bidsData;

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
  @override
  void initState() {
    print(argumentData);
    pickupjob = argumentData['pickupjob'];
    bidsData = argumentData['bidsData'];
    print(pickupjob.pickLat);
    print(argumentData['bidsData']);

    //print(argumentData.data);
    print("argumentData End");
    pickLat = pickupjob.pickLat!;
    pickLan = pickupjob.pickLan!;
    pickAddress = pickupjob.pickAddress!;
    pickState = pickupjob.pickState!;
    pickCity = pickupjob.pickCity!;
    pickZip = pickupjob.pickZip!;

    dropLat = pickupjob.dropLat!;
    dropLan = pickupjob.dropLan!;
    dropAddress = pickupjob.dropAddress!;
    dropState = pickupjob.dropState!;
    dropCity = pickupjob.dropCity!;
    dropZip = pickupjob.dropZip!;

    needLoadUnload = pickupjob.needLoadUnload!;

    barCodeItemNumberController.text = pickupjob.barCodeItemNumber!;
    titleController.text = pickupjob.title!;

    barCodeItemController.text = pickupjob.barCodeItem!;
    weightController.text = pickupjob.weight!;

    lengthController.text = pickupjob.length!;
    heightController.text = pickupjob.height!;
    numberOfItemController.text = pickupjob.numberOfItem!;
    needLoadUnloadTimeController.text = pickupjob.needLoadUnloadTime!;
    super.initState();
  }

  var status = ['Accepted', 'Rejected'];
  String selectedStatus = '';

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
                  title: Text('Bid'),
                ),
                body: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                  ),
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      Container(
                          padding: EdgeInsets.all(15),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 160,
                                    child: Text(
                                      bidsData.job_title.toString(),
                                      style: TextStyle(
                                          overflow: TextOverflow.clip,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            //  Get.to(ProposalsAcceptReject());
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            100,
                                    child: Image.network(
                                      bidsData.selected_vehicle_picture
                                          .toString(),
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
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
                                  Container(
                                    child: Column(
                                      children: [
                                        Text(bidsData.selected_vehicle_title
                                            .toString()),
                                        Text(
                                          bidsData.bid_amount.toString() +
                                              ' USD',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text(bidsData.createdon.toString())],
                              )
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (bidsData.status == "applied")
                              ? Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      50,
                                  child: InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                        'Accept/Reject',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                    onTap: () {
                                      _acceptReject();
                                    },
                                  ))
                              : Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      50,
                                  child: Container(
                                    width: double.infinity,
                                    child: Center(
                                        child: Text(
                                      bidsData.status.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                          Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width / 2 - 50,
                              child: InkWell(
                                child: Container(
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    'Message',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                                onTap: () async {
                                  UserModel user = await _db
                                      .doc('/users/${bidsData.user_id}')
                                      .get()
                                      .then((documentSnapshot) =>
                                          UserModel.fromMap(
                                              documentSnapshot.data()!));
                                  UserModel driver = await _db
                                      .doc('/users/${bidsData.driver_id}')
                                      .get()
                                      .then((documentSnapshot) =>
                                          UserModel.fromMap(
                                              documentSnapshot.data()!));

                                  ChatListModel chatListModel = ChatListModel(
                                      chat_id: bidsData.job_id.toString() +
                                          '_' +
                                          bidsData.user_id.toString() +
                                          '_' +
                                          bidsData.driver_id
                                              .toString(), //jobid_userid_driverid
                                      user_id: bidsData.user_id,
                                      user_name: bidsData.user_name,
                                      user_image: user.photoUrl,
                                      driver_id: bidsData.driver_id,
                                      driver_name: bidsData.driver_name,
                                      driver_image: driver.photoUrl,
                                      job_id: bidsData.job_id,
                                      job_title: bidsData.job_title,
                                      status: '1',
                                      updatedon: DateTime.now(),
                                      createdon: DateTime.now());

                                  await FirestoreDb.addChatList(chatListModel);
                                  print({
                                    "chat_id": bidsData.job_id.toString() +
                                        '_' +
                                        bidsData.user_id.toString() +
                                        '_' +
                                        bidsData.driver_id
                                            .toString(), //jobid_userid_driverid
                                    "user_id": bidsData.user_id,
                                    "user_name": bidsData.user_name,
                                    "user_image": user.photoUrl,
                                    "driver_id": bidsData.driver_id,
                                    "driver_name": bidsData.driver_name,
                                    "driver_image": driver.photoUrl,
                                    "job_id": bidsData.job_id,
                                    "job_title": bidsData.job_title,
                                    "status": '1',
                                    "updatedon": DateTime.now(),
                                    "createdon": DateTime.now()
                                  });
                                },
                              ))
                        ],
                      ),
                      Divider(
                        height: 20,
                      ),
                      (bidsData.status == "Accepted")
                          ? Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              child: InkWell(
                                child: Center(
                                  child: Text('Hire Now',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                onTap: () {
                                  hireNow();
                                },
                              ),
                            )
                          : Container(),
                      Divider(
                        height: 20,
                      ),

                      Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border:
                                  Border.all(width: 1.0, color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              TextField(
                                readOnly: true,
                                controller: titleController,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    3 -
                                                21,
                                        child: TextField(
                                          readOnly: true,
                                          controller: weightController,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                          //or null
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            labelText: 'Weight (Pound)',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    3 -
                                                21,
                                        child: TextField(
                                          readOnly: true,
                                          controller: lengthController,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                          //or null
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            labelText: 'Length (Feet)',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    3 -
                                                21,
                                        child: TextField(
                                          readOnly: true,
                                          controller: heightController,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                          //or null
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            labelText: 'Height (Feet)',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
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
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              Container(
                                child: Image.network(
                                  pickupjob.itemImage!,
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
                              ),
                              Divider(
                                height: 24,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Do you need help to load/unload? (A charge of  USD 1 Per minute. 10 min minimum )',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
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
                                          controller:
                                              needLoadUnloadTimeController,
                                          keyboardType: TextInputType.number,

                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                          //or null
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            labelText:
                                                'How Much time you need?',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
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
                          // mock stream
                          // driverCoordinatesStream: Stream.periodic(
                          //   Duration(milliseconds: 500),
                          //       (i) => LatLng(
                          //     40.47747872288886 + i / 10000,
                          //     -3.368043154478073 - i / 10000,
                          //   ),
                          // ),
                          // sourceName: "This is source name",
                          // driverName: "Alex",
                          // onTapDriverMarker: (currentLocation) {
                          //   print("Driver is currently at $currentLocation");
                          // },
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
                              border:
                                  Border.all(width: 1.0, color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
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
                              child: Text(
                                  pickupjob.contactPersonName.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
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
                              child: Text(
                                  pickupjob.contactPersonMobile.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
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
                                  pickupjob.contactPersonAlternateMobile
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                          ])),

                      //Edit
                      //View Applications
                    ],
                  ),
                )));
  }

  _acceptReject() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
              child: ListView(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(15),
                      child: DropdownButtonFormField(
                        style: TextStyle(color: Colors.black, fontSize: 20.0),

                        decoration: InputDecoration(
                          fillColor: Colors.black,
                          labelText: 'Accept or Reject Bid',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        hint:
                            Text('Select Status'), // Not necessary for Option 1

                        items: status.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value as String;
                          });

                          print(selectedStatus);
                        },
                      )),
                  InkWell(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(10),
                        width: 170,
                        decoration: BoxDecoration(color: Colors.black),
                        child: Center(
                            child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      onTap: () async {
                        bidsData.status = selectedStatus;
                        if (selectedStatus != '') {
                          await FirestoreDb.editBidS(bidsData);
                        }
                      })
                ],
              ),
              padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).viewInsets.collapsedSize.height));
        });
  }

  hireNow() {
    Get.defaultDialog(
        title: 'Hire Now',
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Container(
                margin: EdgeInsets.all(5),
                width: 120,
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Center(
                    child: Text(
                  'Canecl',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              onTap: () {
                Get.back();
              },
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                width: 120,
                color: Colors.green,
                child: Center(
                    child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              onTap: () async {
                bidsData.status = 'Hired';

                pickupjob.bid_id = bidsData.id;
                pickupjob.driver_id = bidsData.driver_id;
                pickupjob.driver_name = bidsData.driver_name;
                pickupjob.vehicle_id = bidsData.selected_vehicle;
                pickupjob.vehicle_name = bidsData.selected_vehicle_title;
                pickupjob.status = "In Progress";

                pickupjob.amount = int.parse(bidsData.bid_amount as String);
                print(bidsData.job_id);
                await FirestoreDb.hire(bidsData, pickupjob);
              },
            )
          ],
        ),
        radius: 10.0);
  }
}
