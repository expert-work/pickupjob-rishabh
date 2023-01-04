import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/helpers/card_helper.dart';
import 'package:pickupjob/models/models.dart';
import 'package:get/get.dart';

import '../ui.dart';

class Cards extends StatefulWidget {
  const Cards({super.key});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) => controller.firestoreUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.black87,
                  title: const Text('Cards'),
                  actions: [
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.to(CardsAdd());
                        }),
                  ],
                ),
                body: GetX<CardController>(
                  init: Get.put<CardController>(CardController()),
                  builder: (CardController cardController) {
                    return Container(
                      color: Colors.black87,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: cardController.cards.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(cardController.cards[index]);
                          final cardData = cardController.cards[index];
                          return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              child: Stack(children: [
                                CreditCardWidget(
                                  cardNumber: cardData.card_number.toString(),
                                  expiryDate: cardData.expiry_date.toString(),
                                  cardHolderName:
                                      cardData.name_on_card.toString(),
                                  obscureCardNumber: true,
                                  obscureCardCvv: true,
                                  isHolderNameVisible: true,
                                  cardBgColor: const Color(0xff1b447b),
                                  isSwipeGestureEnabled: true,
                                  cvvCode: '',
                                  onCreditCardWidgetChange:
                                      (CreditCardBrand) {},
                                  showBackView: false,
                                ),
                                Container(
                                  child: InkWell(
                                    child: Text('Pay Now'),
                                    onTap: () {
                                      Get.to(CardPayment());
                                    },
                                  ),
                                ),
                                Positioned(
                                    top: -5,
                                    right: -5,
                                    child: Container(
                                      child: IconButton(
                                        onPressed: () async {
                                          await FirestoreCardDb.deleteCard(
                                              cardData.id);

                                          if (controller.firestoreUser.value!
                                                  .userType ==
                                              'DRIVER') {
                                            Get.offAll(driverHome());
                                          } else {
                                            Get.offAll(userHome());
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ))
                              ]));
                        },
                      ),
                    );
                  },
                )));
  }
}
