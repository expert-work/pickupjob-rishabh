import 'package:pickupjob/models/card_model.dart';
import 'package:pickupjob/helpers/card_helper.dart';
import 'package:get/get.dart';

class CardController extends GetxController {
  Rx<List<CardModel>> cardList = Rx<List<CardModel>>([]);

  List<CardModel> get cards => cardList.value;

  @override
  void onReady() {
    cardList.bindStream(FirestoreCardDb.cardStream());
  }
}
