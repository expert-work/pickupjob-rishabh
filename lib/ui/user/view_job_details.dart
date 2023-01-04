import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';

class ViewJob extends StatefulWidget {
  const ViewJob({super.key});

  @override
  State<ViewJob> createState() => _ViewJobState();
}

class _ViewJobState extends State<ViewJob> {
  dynamic argumentData = Get.arguments;

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
    print("argumentData start");
    print(argumentData);
    print(argumentData['title']);

    //print(argumentData.data);
    print("argumentData End");

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        padding: EdgeInsets.all(10),
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

          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(color: Color.fromARGB(255, 32, 89, 34)),
            child: Center(
                child: Text(
              "Edit",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )),
          ),

          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.red),
            child: Center(
                child: Text(
              "View Applications",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ]));
  }
}
