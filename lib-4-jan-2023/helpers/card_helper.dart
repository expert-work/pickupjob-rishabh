import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pickupjob/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:pickupjob/constants.dart';
import 'package:pickupjob/models/models.dart';
import 'package:pickupjob/ui/ui.dart';

final getStorage = GetStorage();

class FirestoreCardDb {
  static addCard(CardModel cardModel) async {
    await firebaseFirestore.collection('cards').add({
      'user_id': cardModel.user_id,
      'name_on_card': cardModel.name_on_card,
      'card_number': cardModel.card_number,
      'expiry_date': cardModel.expiry_date,
      'updatedon': Timestamp.now(),
      'createdon': Timestamp.now(),
      'is_default': true
    });

    Get.snackbar("Success", "Card Successfully added",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
  }

  static Stream<List<CardModel>> cardStream() {
    return firebaseFirestore
        .collection('cards')
        .where("user_id", isEqualTo: auth.currentUser!.uid)
        .orderBy('createdon', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<CardModel> cards = [];
      for (var todo in query.docs) {
        final cardModel =
            CardModel.fromDocumentSnapshot(documentSnapshot: todo);
        cards.add(cardModel);
      }
      return cards;
    });
  }

  static editCard(CardModel cardModel) async {
    Get.snackbar("Success", "Bid Successfully ",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
    Get.offAll(listProposalsUser());
  }

  static deleteCard(card_id) async {
    await firebaseFirestore.collection('cards').doc(card_id).delete();

    Get.snackbar("Success", "Card Successfully deleted",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
  }
}
