import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickupjob/models/user_model.dart';
import '../../helpers/firestore_user_db.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
import '../ui.dart';

class TabProfileDriver extends StatefulWidget {
  const TabProfileDriver({super.key});

  @override
  State<TabProfileDriver> createState() => _TabProfileDriverState();
}

class _TabProfileDriverState extends State<TabProfileDriver> {
  @override
  Future<String> uploadImageToFirebase(uid) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);

    var imageFile = File(image!.path);
    String fileName = basename(imageFile.path);
    try {
      showLoadingIndicator();
      Reference storageReference =
          FirebaseStorage.instance.ref().child("images/$fileName");
      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();
      await FirestoreUserDb.updateUserProfilePic(uid, url);
      print(url);
      hideLoadingIndicator();
      return url;
    } on FirebaseException catch (e) {
      hideLoadingIndicator();
      return "";
    }
  }

  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) => controller.firestoreUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Stack(
                            children: [
                              Avatar(controller.firestoreUser.value!),
                              Container(
                                margin: EdgeInsets.only(top: 50, left: 60),
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: IconButton(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(0),
                                    iconSize: 15,
                                    onPressed: () async {
                                      await uploadImageToFirebase(
                                          controller.firestoreUser.value!.uid);
                                    },
                                    icon: const Icon(Icons.edit)),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(controller.firestoreUser.value!.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  ((controller
                                          .firestoreUser.value!.isIndividual)
                                      ? 'Individual'
                                      : 'Carporate'),
                                  style: const TextStyle(fontSize: 16)),
                              Text(controller.firestoreUser.value!.email,
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(color: Colors.white),
                      child: ListTile(
                        onTap: () {
                          Get.to(UpdatePassowrdDriver());
                        },
                        trailing: Icon(Icons.arrow_right),
                        title: Text('Update Password'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(color: Colors.white),
                      child: ListTile(
                        onTap: () {
                          Get.to(DriverUpdateProfile());
                        },
                        trailing: Icon(Icons.arrow_right),
                        title: Text('Update Profile'),
                      ),
                    )
                  ],
                )));
  }
}
