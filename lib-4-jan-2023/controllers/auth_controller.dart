import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickupjob/models/models.dart';
import 'package:pickupjob/ui/ui.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:pickupjob/helpers/helpers.dart';
import 'package:pickupjob/helpers/firestore_db.dart';

class AuthController extends GetxController {
  final getStorage = GetStorage();

  static AuthController to = Get.find();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  final RxBool admin = false.obs;

  @override
  void onReady() async {
    //run every time auth state changes
    ever(firebaseUser, handleAuthChanged);
    getLocationPermission();
    firebaseUser.bindStream(user);

    super.onReady();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  handleAuthChanged(_firebaseUser) async {
    //get user data from firestore

    if (_firebaseUser?.uid != null) {
      firestoreUser.bindStream(streamFirestoreUser());
      await isAdmin();
    }

    if (_firebaseUser == null) {
      //  Get.offAll(const MapView());
      Get.offAll(mainCarousel());
    } else {
      UserModel user = await getFirestoreUser();

      if (user.userType == 'USER') {
        if (user.isProfileCompleted) {
          Get.offAll(userHome());
        } else {
          // Get.offAll(userHome());
          Get.offAll(userCompleteProfile());
        }
      }
      if (user.userType == 'DRIVER') {
        if (user.isProfileCompleted) {
          //Get Position Of Driver Start
          FirestoreDb.setLocation();
          //Get Position Of Driver End

          Get.offAll(driverHome());
        } else {
          Get.offAll(driverCompleteProfile());
        }
      }
    }
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser!;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  //Streams the firestore user from the firestore collection
  Stream<UserModel> streamFirestoreUser() {
    print('streamFirestoreUser()');
    print('streamFirestoreUser()');
    print('1234567890');

    return _db
        .doc('/users/${firebaseUser.value!.uid}')
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot.data()!));
  }

  //get the firestore user from the firestore collection
  Future<UserModel> getFirestoreUser() async {
    var deviceToken = await getStorage.read('deviceToken') ?? "";
    _db
        .doc('/users/${firebaseUser.value!.uid}')
        .update({'deviceToken': deviceToken});

    print("device token");
    print(deviceToken);
    print("xxxxxxxxxxxxxxxxxxxxx");

    return await _db.doc('/users/${firebaseUser.value!.uid}').get().then(
        (documentSnapshot) => UserModel.fromMap(documentSnapshot.data()!));
  }

  //Method to handle user sign in using email and password
  signInWithEmailAndPassword(BuildContext context) async {
    showLoadingIndicator();
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      emailController.clear();
      passwordController.clear();
      hideLoadingIndicator();
    } catch (error) {
      hideLoadingIndicator();
      Get.snackbar('auth.signInErrorTitle'.tr, 'auth.signInError'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 7),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  // User registration using email and password
  registerWithEmailAndPassword(BuildContext context, userType) async {
    showLoadingIndicator();
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((result) async {
        print('uID: ' + result.user!.uid.toString());
        print('email: ' + result.user!.email.toString());
        //get photo url from gravatar if user has one
        Gravatar gravatar = Gravatar(emailController.text);
        String gravatarUrl = gravatar.imageUrl(
          size: 200,
          defaultImage: GravatarImage.retro,
          rating: GravatarRating.pg,
          fileExtension: true,
        );
        //create the new user object
        UserModel _newUser = UserModel(
            uid: result.user!.uid,
            email: result.user!.email!,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            name: firstNameController.text + ' ' + lastNameController.text,
            photoUrl: gravatarUrl,
            userType: userType,
            isProfileCompleted: false,
            isIndividual: true,
            deviceToken: "",
            numberOfVehicle: 0);
        //create the user in firestore
        _createUserFirestore(_newUser, result.user!);
        emailController.clear();
        passwordController.clear();
        hideLoadingIndicator();
      });
    } on FirebaseAuthException catch (error) {
      hideLoadingIndicator();
      Get.snackbar('auth.signUpErrorTitle'.tr, error.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //handles updating the user when updating profile
  Future<void> updateUser(BuildContext context, UserModel user, String oldEmail,
      String password) async {
    String _authUpdateUserNoticeTitle = 'auth.updateUserSuccessNoticeTitle'.tr;
    String _authUpdateUserNotice = 'auth.updateUserSuccessNotice'.tr;
    try {
      showLoadingIndicator();
      try {
        await _auth
            .signInWithEmailAndPassword(email: oldEmail, password: password)
            .then((_firebaseUser) async {
          await _firebaseUser.user!
              .updateEmail(user.email)
              .then((value) => updateUserFirestore(user, _firebaseUser.user!));
        });
      } catch (err) {
        print('Caught error: $err');
        //not yet working, see this issue https://github.com/delay/pickupjob/issues/21
        if (err.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          _authUpdateUserNoticeTitle = 'auth.updateUserEmailInUse'.tr;
          _authUpdateUserNotice = 'auth.updateUserEmailInUse'.tr;
        } else {
          _authUpdateUserNoticeTitle = 'auth.wrongPasswordNotice'.tr;
          _authUpdateUserNotice = 'auth.wrongPasswordNotice'.tr;
        }
      }
      hideLoadingIndicator();
      Get.snackbar(_authUpdateUserNoticeTitle, _authUpdateUserNotice,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } on PlatformException catch (error) {
      //List<String> errors = error.toString().split(',');
      // print("Error: " + errors[1]);
      hideLoadingIndicator();
      print(error.code);
      String authError;
      switch (error.code) {
        case 'ERROR_WRONG_PASSWORD':
          authError = 'auth.wrongPasswordNotice'.tr;
          break;
        default:
          authError = 'auth.unknownError'.tr;
          break;
      }
      Get.snackbar('auth.wrongPasswordNoticeTitle'.tr, authError,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //updates the firestore user in users collection
  void updateUserFirestore(UserModel user, User _firebaseUser) {
    _db.doc('/users/${_firebaseUser.uid}').update(user.toJson());
    update();
  }

  Future<void> updateUserFirestoreById(UserModel user, String uid) async {
    showLoadingIndicator();
    await _db.doc('/users/${uid}').update(user.toJson());
    update();
    Get.snackbar("Successfully updated", "",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor);

    print(user);
    hideLoadingIndicator();
    Get.defaultDialog(
      title: "Alert!",
      content: Text("Successfully Updated"),
    );

    if (user.userType == 'USER') {
      if (user.isProfileCompleted) {
        Get.offAll(userHome());
      }
    }
    if (user.userType == 'DRIVER') {
      if (user.isProfileCompleted) {
        Get.offAll(driverHome());
      }
    }
  }

  //create the firestore user in users collection
  void _createUserFirestore(UserModel user, User _firebaseUser) {
    user.driverLicNumber = "";
    user.driverLicBack = "";
    user.driverLicFront = "";
    user.companyName = "";
    user.incorporationState = "";
    user.usdotLicNum = "";
    user.einTaxIdNum = "";
    user.fullAddress = "";
    user.city = "";
    user.zipCode = "";
    user.state = "";
    user.phoneNumber = "";
    user.otherPhoneNumber = "";
    user.websiteLink = "";
    print("user.toJson() start");
    print(user.toJson());
    print("user.toJson()  end");

    _db.doc('/users/${_firebaseUser.uid}').set(user.toJson());
    update();
  }

  //password reset email
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    showLoadingIndicator();
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      hideLoadingIndicator();
      Get.snackbar(
          'auth.resetPasswordNoticeTitle'.tr, 'auth.resetPasswordNotice'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } on FirebaseAuthException catch (error) {
      hideLoadingIndicator();
      Get.snackbar('auth.resetPasswordFailed'.tr, error.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //check if user is an admin user
  isAdmin() async {
    await getUser.then((user) async {
      DocumentSnapshot adminRef =
          await _db.collection('admin').doc(user.uid).get();
      if (adminRef.exists) {
        admin.value = true;
      } else {
        admin.value = false;
      }
      update();
    });
  }

  // Sign out
  Future<void> signOut() {
    lastNameController.clear();
    firstNameController.clear();
    emailController.clear();
    passwordController.clear();
    return _auth.signOut();
  }

  Future<void> getLocationPermission() async {
    if (await Permission.location.isRestricted ||
        await Permission.location.isDenied) {
      Get.defaultDialog(
        title: "PickUp Jobs",
        middleText: "Please enable location permission for app!",
        backgroundColor: Colors.black,
        titleStyle: TextStyle(color: Colors.white),
        middleTextStyle: TextStyle(color: Colors.white),
        textConfirm: "Confirm",
        onConfirm: () async =>
            {await openAppSettings(), Get.back(result: true)},
        cancelTextColor: Colors.white,
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        barrierDismissible: false,
        radius: 10,
      );

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      print(position.latitude);
      print('position.longitude');
      print(position.longitude);
      // The OS restricts access, for example because of parental controls.
    }
  }
}
