import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget boldText(String text, Color color, double fontSize) {
  return Text(text,
      style: GoogleFonts.zenKakuGothicNew(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      overflow: TextOverflow.ellipsis);
}

Widget mediumText(String text, Color color, double fontSize) {
  return Text(
    text,
    style: GoogleFonts.zenKakuGothicNew(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    overflow: TextOverflow.ellipsis,
  );
}

Widget regularText(String text, Color color, double fontSize) {
  return Text(
    text,
    style: GoogleFonts.zenKakuGothicNew(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    // overflow: TextOverflow.ellipsis
  );
}

Widget lightText(String text, Color color, double fontSize) {
  return Text(text,
      style: GoogleFonts.zenKakuGothicNew(
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        color: color,
      ),
      overflow: TextOverflow.ellipsis);
}
