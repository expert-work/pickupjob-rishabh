import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  String? id;
  String? user_id;
  String? name_on_card;
  String? card_number;
  String? expiry_date;
  bool? is_default;
  DateTime? updatedon;
  DateTime? createdon;

  CardModel(
      {this.id,
      required this.user_id,
      required this.name_on_card,
      required this.card_number,
      required this.expiry_date,
      this.is_default,
      this.updatedon,
      this.createdon});

  CardModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    user_id = documentSnapshot["user_id"];
    name_on_card = documentSnapshot["name_on_card"];
    card_number = documentSnapshot["card_number"];

    expiry_date = documentSnapshot["expiry_date"];
    is_default = documentSnapshot["is_default"];

    updatedon = documentSnapshot["updatedon"].toDate();
    createdon = documentSnapshot["createdon"].toDate();
  }

  factory CardModel.fromMap(Map data) {
    return CardModel(
// id : data.id,
        user_id: data["user_id"],
        name_on_card: data["name_on_card"],
        card_number: data["card_number"],
        expiry_date: data["expiry_date"],
        is_default: data["is_default"],
        updatedon: data["updatedon"].toDate(),
        createdon: data["createdon"].toDate());
  }
}
