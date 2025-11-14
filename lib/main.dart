// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sp1/login/login.dart';
import 'package:sp1/menu/menu.dart';
import 'package:sp1/fingure/fingure.dart';
import 'package:sp1/dataProvider/loginDetail';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:pdf/widgets.dart';
import 'package:provider/provider.dart';
// import 'dart:ui_web' as ui;
// import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

Future<void> main() async {
  //  ui.platformViewRegistry.registerViewFactory(
  //     'example', (_) => DivElement()..innerText = 'Hello, HTML!');
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  final LocalAuthentication auth = LocalAuthentication();
  // 1. Check if biometrics are supported
  final bool canAuthenticate =
      await auth.canCheckBiometrics || await auth.isDeviceSupported();
  runApp(MyApp(canAuthenticate));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final bool canAuthenticate;
  String routesStr = '/';
  MyApp(this.canAuthenticate, {super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (canAuthenticate) {
      // You can now use biometric authentication features
      routesStr = '/fingure';
    }
    // else {

    //   // Handle the case where biometrics are not supported
    // }

    return MultiProvider(
      providers: [Provider<LoginDetail>(create: (_) => LoginDetail())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        routes: {
          '/': (context) => MyLoginPage(title: 'เข้าระบบ'),
          '/menu': (context) => Menu(title: 'ระบบสลิปใบรับรองภาษี'),
          '/fingure': (context) =>
              MyFingurePage(title: 'ยืนยันตัวตนด้วยลายนิ้วมือ'),
        },
        initialRoute: routesStr,
        theme: ThemeData(
          fontFamily: 'Noto Sans Thai',
          unselectedWidgetColor: Colors.red,
          primarySwatch: Colors.green,
          // colorScheme: ColorScheme(
          //       brightness: Brightness.light,
          //       primary: Colors.black,
          //       onPrimary: Colors.black,
          //       secondary: Colors.blue.shade500,
          //       onSecondary: Colors.blue.shade500,

          //       surface: Colors.green.shade500,
          //       onSurface: Colors.green.shade500,
          //       error: Colors.red,
          //       onError: Colors.red,
          //     ),
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        ),
        // home:MyLoginPage(title: 'เข้าระบบ'),  // MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

/*
// unselectedWidgetColor: Colors.red,
          // primarySwatch: Colors.green,
        /*  colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.black,
            onPrimary: Colors.black,
            secondary: Colors.green.shade200,
            onSecondary: Colors.green.shade200,
            background: Colors.white,
            onBackground: Colors.white,
            surface: Colors.green.shade500,
            onSurface: Colors.green.shade500,
            error: Colors.red,
            onError: Colors.red,
          ),
             //  textTheme: GoogleFonts.latoTextTheme(
          //   Theme.of(context).textTheme,
          // ),
*/
*/
