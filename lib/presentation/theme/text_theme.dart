import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget titleText(String text, Color? color, double? fontSize) {
  return Text(text,
      style: GoogleFonts.zenKakuGothicNew(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ));
}
