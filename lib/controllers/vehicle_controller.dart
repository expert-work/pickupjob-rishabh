import 'package:pickupjob/models/vehicle_model.dart';
import 'package:pickupjob/helpers/firestore_db.dart';
import 'package:get/get.dart';

class VehicleController extends GetxController {
  Rx<List<VehicleModel>> vehicleList = Rx<List<VehicleModel>>([]);
  Rx<List<VehicleModel>> vehicleOpenList = Rx<List<VehicleModel>>([]);
  Rx<List<VehicleModel>> myVehicleListOpenList = Rx<List<VehicleModel>>([]);

  List<VehicleModel> get vehicles => vehicleList.value;
  List<VehicleModel> get vehiclesOpen => vehicleOpenList.value;
  List<VehicleModel> get myVehiclesOpen => myVehicleListOpenList.value;

  @override
  void onReady() {
    vehicleList.bindStream(FirestoreDb.todoStream());
    vehicleOpenList.bindStream(FirestoreDb.vehicleListOpen());
    myVehicleListOpenList.bindStream(FirestoreDb.myVehicleListOpen());
  }
}
