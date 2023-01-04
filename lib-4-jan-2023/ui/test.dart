import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  double? latitude;
  double? longitude;
  late CameraPosition _currentPosition;
  String googleApikey = "AIzaSyCe2c5wnzwWCrtk-U-MvBIbvVn2rswuxpQ";
  GoogleMapController? mapController;
  final TextEditingController _searchController = TextEditingController();
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  late List<Placemark> placemarks;
  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude!, longitude!), zoom: 20)));
      _currentPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 20,
      );
    });
    setState(() {});
  }

  @override
  void initState() {
    googlePlace = GooglePlace(googleApikey);
    getLocation();
    super.initState();
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: (MediaQuery.of(context).size.height - 60),
          child: ListView(padding: const EdgeInsets.all(30), children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
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
            SizedBox(
              height: 10,
            ),
            Container(
              height: (predictions.length > 0) ? 200 : 0,
              child: ListView.builder(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
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

                      if (result != null && result.result != null && mounted) {
                        print("result detail start");
                        print(result?.result!.geometry?.location?.lat);
                        print(result?.result!.geometry?.location?.lng);
                        print("result detail end");
                        setState(() {
                          latitude = result?.result!.geometry?.location?.lat;
                          longitude = result?.result!.geometry?.location?.lng;
                          mapController?.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(latitude!, longitude!),
                                  zoom: 20)));
                        });
                      }

                      setState(() {
                        _searchController.text =
                            predictions[index].description!;
                        predictions = [];
                      });
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            Container(
                height: 400,
                child: GoogleMap(
                  onTap: (latLng) async {
                    placemarks = await placemarkFromCoordinates(
                        latLng.latitude, latLng.longitude);
                    print(placemarks);
                    print('${latLng.latitude}, ${latLng.longitude}');
                    mapController?.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(latLng.latitude, latLng.longitude),
                            zoom: 20)));
                    print("hjhhjhjhjjhP");
                  },
                  initialCameraPosition: _currentPosition,
                  onMapCreated: (controller) {
                    //method called when map is created
                    setState(() {
                      mapController = controller;
                    });
                  },
                ))
          ])),
    );
  }
}
