//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow_teste/telaresultado.dart';
import 'package:image_picker/image_picker.dart';
import 'telainformativo.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final items = ['Sala 112', 'Sala 119'];
  String? value;

  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  //CollectionReference salas = FirebaseFirestore.instance.collection('salas');

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );

  File? image;
  String salaEscolhida = "";

  var url = "http://10.0.2.2:5000/req/imagem";
  //var url = "http://pesquisa05.lages.ifsc.edu.br:5000/req/imagem";

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  var confianca;
  var dia;
  var horas;
  var possui_mascara;
  var sala;
  var possui_mascaraString;
  var timestamp;

  //funcao pick image

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        return;
      }

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });

      var imagem64;
      File teste;
      teste = File(image.path);
      if (image != null) {
        imagem64 = base64String(teste.readAsBytesSync());
      }
      try {
        salaEscolhida = value!;

        var data = json.encode({"link da imagem": "$imagem64", "sala": "$salaEscolhida"});

        final response = await post(Uri.parse(url),
            headers: {"Content-Type": "application/json"}, body: data);
        print(response.body.toString());


        var convertDataToJson = json.decode(response.body);
        setState(() {
          confianca = convertDataToJson['confianca'];
          //dia = convertDataToJson['dia'];
          //horas = convertDataToJson['horas'];
          timestamp = convertDataToJson['timestamp'];
          possui_mascara = convertDataToJson['possui_mascara'];
          sala = convertDataToJson['sala'];


        });
        
        Map<String,dynamic> datad = {
          "confidence": confianca, "timestamp": timestamp, "possui_mascara": possui_mascara,
          "sala" : sala
        };
        //myTimestamp = firebase.firestore.Timestamp.fromDate(new Date());


        FirebaseFirestore.instance.collection('user').add(datad);




      } catch (er) {}
    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }


    print("foto tirada na ->"+ salaEscolhida);
    //print("possui_mascara:" + possui_mascara + "possui_mascaraString:" + possui_mascaraString);

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => telaResultado(image: image, salaEscolhida : salaEscolhida,
          possui_mascara : possui_mascara ,confianca: (double.parse(confianca)*100).toStringAsFixed(2))));
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    );

    return Scaffold(
        backgroundColor: Color(0xFF80CC28),
        body: SafeArea(
            child: Stack(children: [
          Align(
            alignment: AlignmentDirectional(1, 1),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x00EEEEEE),
              ),
              child: TextButton(
                child: Image.asset("images/info.png"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => telaInformativo()));
                },
              ),
            ),
          ),
          Align(
              alignment: AlignmentDirectional(-0.9, -0.95),
              child: Container(
                  width: MediaQuery.of(context).size.height* 0.18,
                  height: MediaQuery.of(context).size.height* 0.18,
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage('images/logoIFSC.png'),
                      fit: BoxFit.fill,

                    ),
                  ))),
          Align(
            alignment: AlignmentDirectional(0, -0.47),
            child: Container(
              width: MediaQuery.of(context).size.width* 0.45,
              height: MediaQuery.of(context).size.height* 0.30,
              decoration: BoxDecoration(
                color: Color(0x00EEEEEE),
              ),
              child: Image.asset(
                'images/mask.png',
                width: MediaQuery.of(context).size.width* 1,
                height: MediaQuery.of(context).size.height* 1,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0, 0.18),
                    child: Text(
                      'Reconhecedor de máscara',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontStyle: FontStyle.normal,
                          fontSize: 35,
                          color: Color(0xFFFFFFFF)),
                    ),
                  ),
                )
              ],
            ),
          ),


          Align(
            alignment: AlignmentDirectional(0, 0.45),
            child: Container(
              width: MediaQuery.of(context).size.width* 0.60,
              height: MediaQuery.of(context).size.height* 0.08,
              decoration: BoxDecoration(
                color: Color(0x00EEEEEE),
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('salas')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return DropdownButton<String>(
                      hint: Text("Selecione uma sala",
                          style: GoogleFonts.poppins(color: Color(0xFFFFFFFF))),
                      value: value,
                      onChanged: (value) => setState(() => this.value = value),

                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      isExpanded: true,
                      items:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                            value: document['sala'] as String,
                            child: Text(document['sala']));
                      }).toList(),
                    );
                  }),
            ),
          ),
              Align(
                  alignment: AlignmentDirectional(-0.05, 0.70),
                  child: Container(
                    width: MediaQuery.of(context).size.width* 0.45,
                    height: MediaQuery.of(context).size.height* 0.08,
                    decoration: BoxDecoration(
                      color: Color(0x00EEEEEE),
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFFFFFF),
                            minimumSize: Size(MediaQuery.of(context).size.width* 0.45, MediaQuery.of(context).size.height* 0.08),
                            shape: shape),
                        onPressed: () {
                          pickImage();
                        },
                        child: Text('Acessar',
                            style:
                            GoogleFonts.poppins(
                                color: Color(0xFF2B9F3F)))),
              )



              )])));
  }
}
