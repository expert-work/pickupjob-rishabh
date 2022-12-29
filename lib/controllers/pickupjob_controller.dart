import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickupjob/models/pickupjob_model.dart';
import 'package:pickupjob/helpers/firestore_db.dart';
import 'package:get/get.dart';

import '../constants.dart';

class PickUpJobController extends GetxController {
  static PickUpJobController to = Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var _radius = 0.obs;

//pickupSearchjobsList
  Rx<List<PickUpJobModel>> pickupjobsList = Rx<List<PickUpJobModel>>([]);
  Rx<List<PickUpJobModel>> pickupOpenjobsList = Rx<List<PickUpJobModel>>([]);
  Rx<List<PickUpJobModel>> pickupSearchjobsList = Rx<List<PickUpJobModel>>([]);

  Rx<List<PickUpJobModel>> pickupInProgressjobsUserList =
      Rx<List<PickUpJobModel>>([]);
  Rx<List<PickUpJobModel>> pickupInProgressjobsDriverList =
      Rx<List<PickUpJobModel>>([]);

  List<PickUpJobModel> get pickupjobs => pickupjobsList.value;
  List<PickUpJobModel> get pickupOpenjobs => pickupOpenjobsList.value;
  List<PickUpJobModel> get pickupSearchjobs => pickupSearchjobsList.value;
  List<PickUpJobModel> get pickupInProgressjobsUser =>
      pickupInProgressjobsUserList.value;

  List<PickUpJobModel> get pickupInProgressjobsDriver =>
      pickupInProgressjobsDriverList.value;
  get radius => _radius.value;

  @override
  void onReady() {
    _radius.value = 30;
    pickupjobsList.bindStream(FirestoreDb.pickupJobsList());
    pickupOpenjobsList.bindStream(FirestoreDb.pickupOpenJobsList());
    pickupSearchjobsList.bindStream(FirestoreDb.pickupSearchJobsList(radius));
    pickupInProgressjobsUserList
        .bindStream(FirestoreDb.pickupInProgressjobsUserList());

    pickupInProgressjobsDriverList
        .bindStream(FirestoreDb.pickupInProgressjobsDriverList());
  }

  getJobByJobId(jobId) async {
    return await firebaseFirestore
        .collection('pickupjobs')
        .doc(jobId)
        .get()
        .then((documentSnapshot) =>
            PickUpJobModel.fromMap(documentSnapshot.data()!));
  }
}
