import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pickupjob/controllers/controllers.dart';

final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
