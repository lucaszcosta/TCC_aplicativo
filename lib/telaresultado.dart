import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'telainformativo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class telaResultado extends StatefulWidget {
  File? image;
  String salaEscolhida;
  var possui_mascara;
  var confianca;
  var possui_mascaraString;

  telaResultado(
      {this.image,
      required this.salaEscolhida,
      this.possui_mascara,
      this.confianca});

  @override
  _telaResultadoState createState() =>
      _telaResultadoState(image, salaEscolhida, possui_mascara, confianca);
}

class _telaResultadoState extends State<telaResultado> {
  File? image;
  String salaEscolhida = "";
  var possui_mascara;
  var possui_mascaraString;
  var confianca;

  _telaResultadoState(
      this.image, this.salaEscolhida, this.possui_mascara, this.confianca);

  //var url = "http://10.0.2.2:5000/req/imagem";
  var url = "http://pesquisa05.lages.ifsc.edu.br:5000/req/imagem";

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  var response;
  var dia;
  var horas;
  var sala;
  var cor;
  var timestamp;

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

      //print("aaaaaaa"+confianca);
      try {
        var data = json
            .encode({"link da imagem": "$imagem64", "sala": "$salaEscolhida"});

        response = await post(Uri.parse(url),
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

        //print("possui_mascara:" + possui_mascara + "possui_mascaraString:" + possui_mascaraString);

        Map<String, dynamic> datad = {
          "confidence": confianca,
          "timestamp" : timestamp,
          "possui_mascara": possui_mascara,
          "sala": sala
        };

        FirebaseFirestore.instance.collection('user').add(datad);

        confianca = double.parse(confianca) * 100;
        confianca = confianca.toStringAsFixed(2);
      } catch (er) {}
    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }

    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => telaResultado(image: image)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(-1, -0.86),
              child: Container(
                width: 999,
                height: 999,
                decoration: BoxDecoration(
                  color: Color(0xFF80CC28),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, -1),
              child: Container(
                width: 999,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF2B9F3F),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, -0.98),
              child: Container(
                width: 275,
                height: 55,
                decoration: BoxDecoration(
                    color: possui_mascara == true
                        ? Color(0xFFF5F5F5)
                        : Color(0xFFE58E8E),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0x00EEEEEE),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0, -1),
                                  child: Text(
                                    possui_mascara == true
                                        ? 'Com Máscara'
                                        : 'Sem Máscara',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        color: Color(0xFF2B9F3F),
                                        fontSize: 14),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0.5),
                                  child: Text(
                                    '$confianca' + '%',
                                    style: GoogleFonts.poppins(
                                        fontStyle: FontStyle.normal,
                                        color: Color(0xFF2B9F3F),
                                        fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, -0.11),
              child: Container(
                width: MediaQuery.of(context).size.width* 1,
                height: MediaQuery.of(context).size.height* 0.70,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
                child: Image.file(image!,
                    width: 0.5, height: 0.5, fit: BoxFit.cover),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.94),
              child: Container(
                width: MediaQuery.of(context).size.width* 0.7,
                height: MediaQuery.of(context).size.height* 0.11,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  shape: BoxShape.circle,
                ),
                child: TextButton(
                  child: Image.asset("images/cam_info2.png"),
                  onPressed: () {
                    pickImage();
                  },
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.89, 0.94),
              child: Container(
                width: MediaQuery.of(context).size.width* 0.2,
                height: MediaQuery.of(context).size.height* 0.10,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  shape: BoxShape.circle,
                ),
                child: TextButton(
                  child: Image.asset("images/info2.png"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => telaInformativo()));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
