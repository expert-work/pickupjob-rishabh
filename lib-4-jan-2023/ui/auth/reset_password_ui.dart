import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pickupjob/ui/auth/auth.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:pickupjob/helpers/helpers.dart';
import 'package:pickupjob/controllers/controllers.dart';

import '../main_carousel.dart';

class ResetPasswordUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(195, 22, 21, 21),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/pickup-truck.png')),
          Container(
            margin: EdgeInsets.all(30),
            padding: EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 10), //BoxShadow
              ],
            ),
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 10, bottom: 10),
                    child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter valid email id as abc@gmail.com'),
                        controller: authController.emailController,
                        validator: Validator().email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => null,
                        onSaved: (value) => authController
                            .emailController.text = value as String),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await authController.sendPasswordResetEmail(context);
                        }
                      },
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(5)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        Get.offAll(() => const mainCarousel());
                      },
                      child: const Text(
                        'Go Home',
                        style: TextStyle(color: Colors.black38, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          )
        ],
      ),
    );
  }
}
