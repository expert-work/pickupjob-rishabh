import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pickupjob/models/user_model.dart';
import 'package:pickupjob/ui/driver/driver_home.dart';
import '../../ui/components/components.dart';

import '../constants.dart';

class FirestoreUserDb {
  static updateUserProfilePic(id, photoUrl) async {
    await firebaseFirestore
        .collection('users')
        .doc(id)
        .update({'photoUrl': photoUrl});
    showSnackBar('Profile Pic Successfully Updated', '');
  }

  static Future<bool> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    bool success = false;

    if (currentPassword.trim() == '' ||
        newPassword.trim() == '' ||
        confirmPassword.trim() == '') {
      showSnackBar('All Fields are required', '');
      return success;
    }
    if (newPassword.length < 6) {
      showSnackBar('Passwords must have 6 alphanumeric characters ', '');
      return success;
    }
    if (newPassword != confirmPassword) {
      showSnackBar('Confirm password must be same', '');
      return success;
    }

    //Create an instance of the current user.
    var user = await FirebaseAuth.instance.currentUser!;
    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.
    final cred = await EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        success = true;
      }).catchError((error) {
        showSnackBar('Something went wrong', '');
        print(error);
      });
    }).catchError((err) {
      print(err);
      showSnackBar(
          'Please enter correct passoword, current passowrd is wrong', '');
      return success;
    });
    if (success) {
      print("Password successfully updated");
      //Get.offAll(driverHome());
      showSnackBar('Password successfully updated', '');
    }
    return success;
  }

  static Future<UserModel> getUsersId(id) async {
    return await firebaseFirestore.collection('users').doc(id).get().then(
        (documentSnapshot) => UserModel.fromMap(documentSnapshot.data()!));
  }

  static showSnackBar(title, subtitle) {
    Get.snackbar(title, subtitle,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);
  }
}
