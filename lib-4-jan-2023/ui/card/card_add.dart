import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/helpers/card_helper.dart';
import 'package:pickupjob/models/models.dart';
import 'package:get/get.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import '../ui.dart';

class CardsAdd extends StatefulWidget {
  const CardsAdd({super.key});

  @override
  State<CardsAdd> createState() => _CardsAddState();
}

class _CardsAddState extends State<CardsAdd> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

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
                  title: const Text('Card Add'),
                ),
                body: Container(
                  decoration: const BoxDecoration(color: Colors.black87),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      CreditCardWidget(
                        glassmorphismConfig: useGlassMorphism
                            ? Glassmorphism.defaultConfig()
                            : null,
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        bankName: '',
                        showBackView: isCvvFocused,
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        isHolderNameVisible: true,
                        cardBgColor: const Color(0xff1b447b),
                        isSwipeGestureEnabled: true,
                        onCreditCardWidgetChange:
                            (CreditCardBrand creditCardBrand) {},
                        customCardTypeIcons: <CustomCardTypeIcon>[],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              CreditCardForm(
                                formKey: formKey,
                                obscureCvv: true,
                                obscureNumber: true,
                                cardNumber: cardNumber,
                                cvvCode: cvvCode,
                                isHolderNameVisible: true,
                                isCardNumberVisible: true,
                                isExpiryDateVisible: true,
                                cardHolderName: cardHolderName,
                                expiryDate: expiryDate,
                                themeColor: Colors.blue,
                                textColor: Colors.white,
                                cardNumberDecoration: InputDecoration(
                                  labelText: 'Number',
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  focusedBorder: border,
                                  enabledBorder: border,
                                ),
                                expiryDateDecoration: InputDecoration(
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  focusedBorder: border,
                                  enabledBorder: border,
                                  labelText: 'Expired Date',
                                  hintText: 'XX/XX',
                                ),
                                cvvCodeDecoration: InputDecoration(
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  focusedBorder: border,
                                  enabledBorder: border,
                                  labelText: 'CVV',
                                  hintText: 'XXX',
                                ),
                                cardHolderDecoration: InputDecoration(
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  focusedBorder: border,
                                  enabledBorder: border,
                                  labelText: 'Card Holder name',
                                ),
                                onCreditCardModelChange:
                                    onCreditCardModelChange,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  width: Get.width - 30,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff1b447b)),
                                  child: Text(
                                    'Save Card',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    await FirestoreCardDb.addCard(CardModel(
                                        user_id:
                                            controller.firestoreUser.value!.uid,
                                        name_on_card: cardHolderName,
                                        card_number: cardNumber,
                                        expiry_date: expiryDate));

                                    if (controller
                                            .firestoreUser.value!.userType ==
                                        'DRIVER') {
                                      Get.offAll(driverHome());
                                    } else {
                                      Get.offAll(userHome());
                                    }
                                  } else {
                                    print('invalid!');
                                  }
                                  print(cardNumber);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )));
  }
}
