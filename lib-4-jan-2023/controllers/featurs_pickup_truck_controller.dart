import 'package:pickupjob/models/featurs_pickup_truck_model.dart';
import 'package:pickupjob/helpers/firestore_db.dart';
import 'package:get/get.dart';

class FeatursPickupTruckController extends GetxController {
  Rx<List<FeatursPickupTruckModel>> FeatursPickupTruck =
      Rx<List<FeatursPickupTruckModel>>([]);

  List<FeatursPickupTruckModel> get data => FeatursPickupTruck.value;

  @override
  void onReady() {
    FeatursPickupTruck.bindStream(FirestoreDb.featursPickupTruckStream());
  }
}
