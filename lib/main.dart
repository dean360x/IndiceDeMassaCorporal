import 'package:flutter/material.dart';
import 'package:indicedemassacorporal/login.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {


//SERVE PARA INICIALIZAR O FIREBASE
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();  //do firebase core

FirebaseFirestore db = FirebaseFirestore.instance;






  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Login(),
    theme: ThemeData(
      primaryColor: const Color.fromARGB(255, 72, 50, 78),
     
    ),
  ));
}

