import 'package:flutter/material.dart';

 var  theme = _buildTheme();
const kNotePink50 = const Color(0xFFFEEAE6);
const kNotePink100 = const Color(0xFFFEDBD0);
const kNotePink300 = const Color(0xFFFBB8AC);
const kNotePink400 = const Color(0xFFEAA4A4);
Color mCardColor = hexToColor('#f05f40');
const kNoteBrown900 = const Color(0xFF442B2D);

const kNoteErrorRed = const Color(0xFFC5032B);

const kNoteSurfaceWhite = const Color(0xFFFFFBFA);
const kNoteBackgroundWhite = Colors.white;

const groundColor=const Color(0xFFFBB8AC);

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: mCardColor,
    primaryColor: mCardColor,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: mCardColor,
      textTheme: ButtonTextTheme.normal,
    ),
    scaffoldBackgroundColor: kNoteBackgroundWhite,
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(color: mCardColor),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
          fontFamily: 'Nunito'
        ),
        title: base.title.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: 'Nunito',
        displayColor: mCardColor,
        bodyColor: mCardColor,
      );
}
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}