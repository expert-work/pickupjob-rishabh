import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickupjob/helpers/firestore_user_db.dart';

import '../../ui.dart';

class UpdatePassowrdUser extends StatefulWidget {
  const UpdatePassowrdUser({super.key});

  @override
  State<UpdatePassowrdUser> createState() => _UpdatePassowrdUserState();
}

class _UpdatePassowrdUserState extends State<UpdatePassowrdUser> {
  TextEditingController currentPassowrdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassowrdController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black87,
          title: Text('Update Password'),
        ),
        body: Stack(
          children: [
            Container(
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                height: (MediaQuery.of(context).size.height - 60),
                child: ListView(
                    padding: const EdgeInsets.all(30),
                    children: <Widget>[
                      TextField(
                        obscureText: true,
                        controller: currentPassowrdController,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Old Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      Divider(
                        height: 14,
                      ),
                      TextField(
                        obscureText: true,
                        controller: passwordController,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      Divider(
                        height: 14,
                      ),
                      TextField(
                        obscureText: true,
                        controller: confirmPassowrdController,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      Divider(
                        height: 80,
                      ),
                    ])),
            Positioned(
              bottom: 0,
              child: Row(children: [
                Container(
                    height: 60,
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
                        String currentPassowrd = currentPassowrdController.text;
                        String password = passwordController.text;
                        String confirmPassowrd = confirmPassowrdController.text;
                        bool response = await FirestoreUserDb.changePassword(
                            currentPassowrd, password, confirmPassowrd);
                        if (response) {
                          currentPassowrdController.text = "";
                          passwordController.text = "";
                          confirmPassowrdController.text = "";

                          print(" response got success");
                        }
                      },
                      child: const Text(
                        'Update Password',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ))
              ]),
            )
          ],
        ));
  }
}
