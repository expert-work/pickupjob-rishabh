import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:pickupjob/helpers/helpers.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/ui/auth/auth.dart';

class SignUpUserUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(195, 22, 21, 21),
      body: Column(
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
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 5, bottom: 5),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // The validator receives the text that the user has entered.

                      // validator: (val) => !isEmail(val!) ? "Invalid Email" : '',
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First name',
                          hintText: 'Enter valid first name'),
                      controller: authController.firstNameController,
                      validator: Validator().name,
                      onChanged: (value) => null,
                      onSaved: (value) =>
                          authController.firstNameController.text = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 5, bottom: 5),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // The validator receives the text that the user has entered.

                      // validator: (val) => !isEmail(val!) ? "Invalid Email" : '',
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last name',
                          hintText: 'Enter valid name  as Bob Paul'),
                      controller: authController.lastNameController,
                      validator: Validator().name,
                      onChanged: (value) => null,
                      onSaved: (value) =>
                          authController.lastNameController.text = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 5, bottom: 5),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // The validator receives the text that the user has entered.

                      // validator: (val) => !isEmail(val!) ? "Invalid Email" : '',
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter valid email id as abc@gmail.com'),
                      controller: authController.emailController,

                      validator: Validator().email,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => null,
                      onSaved: (value) =>
                          authController.emailController.text = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 5, bottom: 5),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter secure password'),
                      controller: authController.passwordController,
                      validator: Validator().password,
                      onChanged: (value) => null,
                      onSaved: (value) =>
                          authController.passwordController.text = value!,
                      maxLines: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //_launchInBrowser();
                    },
                    child: Text(
                      "By Clicking on Signup As User You agree to PickupJobs Agreement and Privacy Policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue, fontSize: 10),
                    ),
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
                          SystemChannels.textInput.invokeMethod(
                              'TextInput.hide'); //to hide the keyboard - if any
                          authController.registerWithEmailAndPassword(
                              context, 'USER');
                        }
                      },
                      child: const Text(
                        'Signup as User',
                        style: TextStyle(color: Colors.white, fontSize: 25),
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
                        Get.offAll(() => SignInUI());
                      },
                      child: const Text(
                        'Already have Account? Login',
                        style: TextStyle(color: Colors.black38, fontSize: 14),
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
