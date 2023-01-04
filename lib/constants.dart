import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickupjob/controllers/controllers.dart';

final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

// Added Code after 30/Dec/2022 -->
double paddingExtraSmall = 5.0;
double paddingSmall = 10.0;
double paddingMedium = 12.0;
double paddingLarge = 15.0;
double paddingExtraLarge = 18.0;
double paddingOverLarge = 20.0;

// Added Colors -->
Color appWhite = Colors.white;
Color appBlack = Colors.black;
