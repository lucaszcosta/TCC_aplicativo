import 'package:flutter/material.dart';
import 'package:flutter_flow_teste/telainicial.dart';
import 'telainicial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(appstart());

  //FirebaseFirestore.instance.collection('salas').doc().set({"sala": "sala 50"});
  /*
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('salas').get();
  snapshot.docs.forEach((d) {
    print(d.data());
  });*/


}

class appstart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaInicial(),
    );
  }
}

