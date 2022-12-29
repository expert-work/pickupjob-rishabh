import 'package:pickupjob/models/bid_model.dart';
import 'package:pickupjob/helpers/firestore_db.dart';
import 'package:get/get.dart';

class BidController extends GetxController {
  Rx<List<BidModel>> bidList = Rx<List<BidModel>>([]);
  Rx<List<BidModel>> bidListUser = Rx<List<BidModel>>([]);

  List<BidModel> get bids => bidList.value;
  List<BidModel> get bidsUser => bidListUser.value;

  @override
  void onReady() {
    bidList.bindStream(FirestoreDb.bidStream());
    bidListUser.bindStream(FirestoreDb.bidsUserStream());
  }
}
