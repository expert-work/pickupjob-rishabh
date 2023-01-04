import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class CardPayment extends StatefulWidget {
  const CardPayment({super.key});

  @override
  State<CardPayment> createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: TextButton(
          child: const Text('Make Payment'),
          onPressed: () async {
            //await createcustomer();
            await makePayment();
          },
        ),
      ),
    );
  }

  Future createcustomer() async {
    try {
      var body = {
        "shipping": {
          "address": {
            "line2": "",
            "line1": "City New ",
            "state": "AL",
            "city": " Montgomery",
            "postal_code": "36043",
            "country": "US"
          },
          "phone": "+17905134906",
          "name": "Ankit Tiwari"
        },
        "description": "MIG 1A Bheekampur Colony Nishatganj",
        "next_invoice_sequence": "1",
        "phone": "+17905134906",
        "preferred_locales": ["en-US"],
        "timezone": "",
        "currency": "usd",
        "tax_exempt": "none",
        "invoicing": {"email_cc": "", "email_to": ""},
        "email": "ankit@mail.com",
        "address": {
          "line2": "",
          "line1": "City New ",
          "state": "AL",
          "postal_code": "36043",
          "city": " Montgomery",
          "country": "US"
        },
        "name": "Ankit Tiwari"
      };

      body = {
        "description": "My First Stripe Customer",
        "email": "jane.smith@email.com",
        "name": "Jane Smith"
      };
      //final response  = await http.post(Uri.parse("https://api.stripe.com/v1/customers"),
      final response = await http.post(
        Uri.parse("https://api.stripe.com/v1/customers"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization":
              "Bearer sk_test_51ItsmRC34o80P4Ycny3IeBEvuwv4s2Qx5lrYTRAZGKDak3CLSuZm4MRJX3qkHUbcIqDgi9DTR4p4C2uJGshsB6qG00Xls9xCK8",
        },
        body: body,
      );
      print('resvfdg: ${jsonDecode(response.body)}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('1', 'USD');
      print('paymentIntent start');
      print(paymentIntent);
      print('paymentIntent end');

      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(
                  //   merchantCountryCode: '+91',
                  // ),
                  // googlePay: const PaymentSheetGooglePay(
                  //     testEnv: true,
                  //     currencyCode: "US",
                  //     merchantCountryCode: "+91"),
                  style: ThemeMode.dark,
                  billingDetails: BillingDetails(
                      address: Address(
                          city: "Lucknow",
                          country: "India",
                          line1: "MIG 1A Bheekampur Colony Nishatganj",
                          postalCode: "226006",
                          state: "UP",
                          line2: "efef"),
                      email: 'gmishra@gobizgrow.com',
                      phone: "7905134906",
                      name: "Ankits M"),
                  merchantDisplayName: 'Adnan'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51ItsmRC34o80P4Ycny3IeBEvuwv4s2Qx5lrYTRAZGKDak3CLSuZm4MRJX3qkHUbcIqDgi9DTR4p4C2uJGshsB6qG00Xls9xCK8',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
