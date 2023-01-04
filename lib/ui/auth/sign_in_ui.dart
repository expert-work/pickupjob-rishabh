import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:core';
import 'package:get/get.dart';
import 'package:pickupjob/ui/auth/auth.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:pickupjob/helpers/helpers.dart';
import 'package:pickupjob/controllers/controllers.dart';

class SignInUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(195, 22, 21, 21),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/pickup-truck.png'),
              width: 80,
            ),
            Container(
              margin: const EdgeInsets.all(30),
              padding: const EdgeInsets.all(30),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 10, bottom: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // The validator receives the text that the user has entered.
                        validator: Validator().email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => null,
                        onSaved: (value) =>
                            authController.emailController.text = value!,

                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter valid email id as abc@gmail.com'),

                        controller: authController.emailController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 10, bottom: 10),
                      child: TextFormField(
                        controller: authController.passwordController,
                        validator: Validator().password,
                        obscureText: true,
                        onChanged: (value) => null,
                        onSaved: (value) =>
                            authController.passwordController.text = value!,
                        maxLines: 1,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Enter secure password'),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      child: const Text('Forgot Password',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                          )),
                      onTap: () {
                        Get.offAll(() => ResetPasswordUI());
                      },
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
                            authController.signInWithEmailAndPassword(context);
                          }
                        },
                        child: const Text(
                          'Login',
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
                          Get.offAll(() => SignUpUserUI());

                          // Get.offAll(() => const signupUser());
                        },
                        child: const Text(
                          'Signup as User',
                          style: TextStyle(color: Colors.black38, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                          Get.offAll(() => SignUpDriverUI());

                          // Get.offAll(() => const signupDriver());
                        },
                        child: const Text(
                          'Signup as Driver',
                          style: TextStyle(color: Colors.black38, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
