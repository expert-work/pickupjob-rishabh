import 'package:pickupjob/models/able_to_transport_model.dart';
import 'package:pickupjob/helpers/firestore_db.dart';
import 'package:get/get.dart';

class AbleToTransportController extends GetxController {
  Rx<List<AbleToTransportModel>> ableToTransport =
      Rx<List<AbleToTransportModel>>([]);

  List<AbleToTransportModel> get data => ableToTransport.value;

  @override
  void onReady() {
    ableToTransport.bindStream(FirestoreDb.ableToTransportStream());
  }
}
