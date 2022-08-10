import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF007FFE);
const Color secondaryColor = Colors.deepOrange;
const Color textColorWhite = Colors.white;
const Color textColorGrey = Color(0xFFF1F2F6);
const Color textColorBlue = Color(0xFF7FB9FE);
const Color colorBlack = Color(0xFF000000);
const Color colorGreyBlack = Color(0xFF727272);
const Color colorRed = Color(0xFFDB3545);
const Color colorMenu = Color(0xFF1DABFB);
const Color colorWhiteBlue = Color(0xFFE4F7FE);
const Color colorLinearStart = Color(0xFF26CAFE);
const Color colorLinearEnd = Color(0xFF697FFB);
const Color textFieldColorGrey = Color(0xFF9FA2BC);
const Color colorDashboardRed = Color(0xFFE42E2E);
const Color colorDashboardGreen = Color(0xFF12BE24);
const Color colorDashboardPurple = Color(0xFF8832FE);
const Color colorDashboardOrange = Color(0xFFFC6632);
const Color colorDashboardBlue = Color(0xFF3361FE);
const Color colorDashboardPattern1 = Color(0xFF375D96);
const Color colorDashboardPattern2 = Color(0xFFF96442);
const Color colorDashboardPattern3 = Color(0xFFFDB801);
const Color colorDashboardPattern4 = Color(0xFF3F661C);

ThemeData lightTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  textTheme: myTextThemePoppins,
  appBarTheme: const AppBarTheme(
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: secondaryColor,
      textStyle: const TextStyle(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: secondaryColor,
    unselectedItemColor: Colors.grey,
  ),
);

final myTextThemePoppins = TextTheme(
  headline1: GoogleFonts.poppins(
      fontSize: 93, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.poppins(
      fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.poppins(fontSize: 46, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.poppins(
      fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.poppins(
      fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.poppins(
      fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.poppins(
      fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.poppins(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
