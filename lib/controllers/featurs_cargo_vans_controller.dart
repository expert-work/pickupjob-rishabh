import 'package:pickupjob/models/featurs-cargo-vans_model.dart';
import 'package:pickupjob/helpers/firestore_db.dart';
import 'package:get/get.dart';

class FeatursCargoVansController extends GetxController {
  Rx<List<FeatursCargoVansModel>> FeatursCargoVans =
      Rx<List<FeatursCargoVansModel>>([]);

  List<FeatursCargoVansModel> get data => FeatursCargoVans.value;

  @override
  void onReady() {
    FeatursCargoVans.bindStream(FirestoreDb.featursCargoVansStream());
  }
}
