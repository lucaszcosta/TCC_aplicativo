import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class telaInformativo extends StatelessWidget {
  const telaInformativo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      //key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF2B9F3F),
        automaticallyImplyLeading: true,
        title: Align(
          alignment: AlignmentDirectional(0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0x00EEEEEE),
            ),
            child: Row(
              children: [
                Align(
                  //alignment: AlignmentDirectional(0, 0),
                  child: Text(
                    'Informativo',
                    style: GoogleFonts.poppins(fontStyle: FontStyle.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFF80CC28),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(0, -0.72),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1, -0.8),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0x00EEEEEE),
                      ),
                      child: Image.asset(
                        'images/mask_info.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(0, -0.8),
                      child: Text(
                        '1. Certifique que a máscara está posicionada corretamente',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(-0.99, -0.28),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0x00EEEEEE),
                    ),
                    child: Image.asset(
                      'images/mobile_info.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0, -0.3),
                    child: Text(
                      '2. Se posicione em frente a câmera',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(-0.97, 0.25),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0x00EEEEEE),
                    ),
                    child: Image.asset(
                      'images/cam_info.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0.05, 0.15),
                    child: Text(
                      '3. Clique no ícone de câmera para fazer a checagem',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 0.8),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0x00EEEEEE),
                    ),
                    child: Image.asset(
                      'images/mask2_info.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0, 0.7),
                    child: Text(
                      '4. O resultado será mostrado em cima de sua foto',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


























/*
myTimestamp = firebase.firestore.Timestamp.fromDate(new Date());


https://www.utctime.net/utc-timestamp
 */
