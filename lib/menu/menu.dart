// ignore_for_file: library_private_types_in_public_api

// import 'dart:io';

import 'dart:convert';
// import 'dart:core' as debug;

// import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// import 'package:local_auth/local_auth.dart';
// import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:responsive_ui/responsive_ui.dart';
// import 'package:sp1/showAlertDialog.dart';
import '../dataProvider/loginDetail';
import '../message.dart';

// import 'package:permission_handler/permission_handler.dart';
class Menu extends StatefulWidget {
  const Menu({super.key, required this.title});
  final String title;
  @override
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // final LocalAuthentication _localAuth = LocalAuthentication();
  // Check if biometric authentication is available
  int itemIndex = 1;
  bool cursorWait = false;
  final formKey = GlobalKey<FormState>();
  // final _editableKey = GlobalKey<EditableState>();
  // bool _isBiometricAvailable = false;
  // String _authorized = 'Not Authorized';
  String appTitle = "", code2FA = ""; // "ลงทะเบียน";
  // List<BiometricType> availableBiometrics = [];
  // List tabName = ['ลงทะเบียน', 'เข้าระบบ', 'ภาษี', 'สลิป', 'รายละเอียด'];
  List tabName = ['เข้าระบบ', 'ภาษี', 'สลิป'];
  @override
  @override
  void initState() {
    super.initState();
    // _checkBiometric();
    appTitle = widget.title; // tabName[itemIndex];
  }

  /*
  Future<void> _checkBiometric() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuth.canCheckBiometrics;
      availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (!mounted) return;
       Message().showMsg(
          "isAvailable=$isAvailable, availableBiometrics=$availableBiometrics",
          TypeMsg.warning,
          context,
        );
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }

    if (!mounted) return;

    setState(() {
      _isBiometricAvailable = isAvailable;
    });
  }

  Future<void> _authenticate() async {
    bool isAuthenticated = false;
    try {
      if (!_isBiometricAvailable) {
        Message().showMsg(
          "ไม่มีระบบสแกนลายนิ้วมือ!!!",
          TypeMsg.warning,
          context,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Biometric authentication not available')),
        );
        return;
      }

      if (!availableBiometrics.contains(BiometricType.fingerprint)) {
        return;
      }
      isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'สแกนลายนิ้วมือเพื่อเข้าระบบ',
        options: const AuthenticationOptions(
          biometricOnly:
              true, // If set to true, it will only use biometrics and not fallback to device credentials
          useErrorDialogs:
              true, // If set to true, the system will handle error dialogs
          stickyAuth:
              true, // If set to true, the authentication dialog will stay until the user completes the auth or cancels
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }

    if (!mounted) return;

    setState(() {
      _authorized = isAuthenticated ? 'Authorized' : 'Not Authorized';
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          //  AppBar(title: Text('ระบบสลิปใบภาษีกรมทางหลวง')),
          AppBar(
            // automaticallyImplyLeading: false,
            backgroundColor: Colors.green.shade400,
            title: Text(
              appTitle,
              style: GoogleFonts.notoSansThai(
                fontSize: 20,
                color: Colors.white,
              ),

              // style: TextStyle(color: Colors.white, fontSize: 20,),
            ),
            centerTitle: true,
            actions: <Widget>[
              Consumer<LoginDetail>(
                builder: (context, loginDetail, child) => IconButton(
                  icon: Icon(Icons.exit_to_app),
                  color: Colors.white,
                  tooltip: "ออกจากระบบ",
                  iconSize: 50,
                  alignment: Alignment.center,
                  onPressed: () {
                    signOut(context, loginDetail);
                  },
                ),
              ),
            ],
          ),
      body: Consumer<LoginDetail>(
        builder: (context, loginDetail, child) => FutureBuilder(
          future: getDocumentRep(loginDetail),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("ERROR: ${snapshot.error}");
            }
            // else if (snapshot.connectionState == ConnectionState.waiting)
            //   return Center(child: CircularProgressIndicator());
            else
            // return Center(child: CircularProgressIndicator());
            {
              return visibilityPage(loginDetail);
            }
          },
        ),
      ),
      bottomNavigationBar: Consumer<LoginDetail>(
        builder: (context, loginDetail, child) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 35,
          mouseCursor: SystemMouseCursors.grab,
          selectedFontSize: 16,
          unselectedFontSize: 14,
          selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 35),
          selectedItemColor: Colors.amberAccent,
          unselectedLabelStyle: GoogleFonts.notoSansThai(
            fontWeight: FontWeight.normal,
          ),
          selectedLabelStyle: GoogleFonts.notoSansThai(
            fontWeight: FontWeight.bold,
          ),
          // TextStyle(
          //   fontWeight: FontWeight.bold,

          // ),
          backgroundColor: Colors.blueGrey,
          unselectedIconTheme: IconThemeData(
            color: Colors.deepOrange.shade50, //Accent
          ),
          unselectedItemColor: Colors.deepOrange.shade50,
          items: [
            BottomNavigationBarItem(
              label: tabName[0],
              icon: Icon(Icons.handyman_outlined),
            ),
            BottomNavigationBarItem(
              label: tabName[1],
              icon: Icon(Icons.print_rounded),
            ),
            BottomNavigationBarItem(
              label: tabName[2],
              icon: Icon(Icons.print_rounded),
            ),
            // BottomNavigationBarItem(
            //   label: tabName[3],
            //   icon: Icon(Icons.print_rounded),
            // ),
            // BottomNavigationBarItem(
            //   label: tabName[4],
            //   icon: Icon(Icons.attribution_outlined),
            // ),
          ],
          currentIndex: itemIndex,
          onTap: (index) async {
            // manaualView = false;
            switch (index) {
              case 0:
                loginDetail.titleBar = tabName[0];
                break;
              case 1:
                loginDetail.titleBar = tabName[1];
                // await chkFingerPrint(uuid, "");
                break;
              case 2:
                loginDetail.titleBar = tabName[2];
                break;
              // case 3:
              //   loginDetail.titleBar = tabName[3];
              //   break;
              // case 4:
              //   loginDetail.titleBar = tabName[4];
              //   break;
              default:
            }
            setState(() {
              itemIndex = index;
              appTitle = loginDetail.titleBar;
              // _selectMenu = SelectMenu.mnuNull;
            });
            // if (itemIndex == 1 && foundFingerPrint) {
            //   await popupFingerPrint();
            // }
          },
        ),
      ),
    );
  }

  void signOut(BuildContext context, LoginDetail loginDetail) {
    Navigator.pushNamed(context, "/");
    loginDetail.idcard = "";
    loginDetail.token = "";
    loginDetail.userName = "";
    loginDetail.passLogin = false;
    loginDetail.use2FA = "0";
    loginDetail.has2Period = "false";
    loginDetail.lastLoginMsg = "";
    loginDetail.uploadFile = "0";
    loginDetail.downloadFile = "0";
    loginDetail.firstChk2FA = false;
    loginDetail.pass2FA = false;
    // manaualView = false;
    /*
    this.itemIndex = 0;
   
    _imageRegister = null;
    _imageLogin = null;
    validReport = false;
    isChecked = false;
    networkImg = false;
    fingerPrint = false;
    foundFingerPrint=false;
*/
    // if (Platform.isAndroid) {
    //   SystemNavigator.pop();
    //   // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    // } else if (Platform.isIOS) {
    //   exit(0);
    // }

    setState(() {});
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => MyLoginPage()),
    //     ModalRoute.withName('/'));
  }

  Future<void> getDocumentRep(LoginDetail loginDetail) async {
    if (!loginDetail.firstChk2FA) {
      return;
    } else {
      loginDetail.firstChk2FA = false;
    }
    if (loginDetail.use2FA == "1") {
      itemIndex = 0;
    } else {
      itemIndex = 2;
    }
    // return null;

    /*
    if (logicalWidth == 0.0) {
      var pixelRatio = View.of(context).devicePixelRatio;
      var logicalScreenSize = View.of(context).physicalSize / pixelRatio;
      logicalWidth = logicalScreenSize.width;
    }
    // readyFingerPrint = await fingerPrintReady();
    await countRegister(loginDetail);
    // if (uuid==""){
    List l = await getDeviceDetails();
    uuid = l[2];

    switch (_selectMenu) {
      case SelectMenu.mnuCancelFingerprint:
        await cancelFingerPrint(loginDetail);
        _selectMenu = SelectMenu.mnuNull;
        break;
      case SelectMenu.mnuCancelPhone:
        await cancelPhone(loginDetail);
        _selectMenu = SelectMenu.mnuNull;
        break;
      default:
    }
    */
  }

  Widget visibilityPage(LoginDetail loginDetail) {
    int choice = 0;
    bool show = false;

    switch (itemIndex) {
      case 0:
        choice = 1;
        show = true;
        // networkImg = false;
        break;
      case 1:
        choice = 2;
        show = true;
        // networkImg = false;
        break;
      case 2:
        choice = 3;
        show = true;

        break;
      // case 3:
      //   choice = 4;
      //   show = true;

      //   break;
      // case 4:
      //   choice = 5;
      //   show = true;
      //   break;
      default:
    }

    // if (this.showPreview) {
    //   choice = 4;
    //   show = true;
    // }

    return Visibility(visible: show, child: selectMethod(choice, loginDetail));
  }

  Widget selectMethod(int choice, LoginDetail loginDetail) {
    switch (choice) {
      case 1:
        return login(loginDetail);
      //register(loginDetail);
      case 2:
        return Text("");
      case 3:
        return Text("");
      case 4:
      //return preview(loginDetail);
      case 5:
      // return slip(loginDetail);
      case 6:
      // return about(loginDetail);
      default:
    }

    return Text("");
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<void> processLogin(LoginDetail loginDetail) async {
    if (code2FA.length < 6) {
      Message().showMsg(
        "รหัสผ่านสองขั้นตอนต้องเท่ากับสิบสองหลัก",
        TypeMsg.warning,
        context,
      );
      return;
    }
    //RegExp specialCharacters = RegExp(r'[.,+\-]');
    if (code2FA.contains(RegExp(r'[.,+\-]'))) {
      Message().showMsg(
        "รหัสผ่านสองขั้นตอนต้องไม่มีสัญลักษณ์ . + -",
        TypeMsg.warning,
        context,
      );
      return;
    }
    if (!isNumeric(code2FA)) {
      Message().showMsg(
        "รหัสผ่านสองขั้นตอนต้องเป็นตัวเลขเท่านั้น",
        TypeMsg.warning,
        context,
      );
      return;
    }
    String url =
        "${loginDetail.urlSal}/verify-2fa?username=${loginDetail.userName}&code=$code2FA";
    // AlertDialogMsg().showAlertDialog(context, code2FA, url);

    http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        // 'Access-Control-Allow-Origin': '*',
        // 'Content-Type': 'application/json;charset=UTF-8',
        // 'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer   ${loginDetail.token}',
      },
      // body: jsonEncode(<String, String>{
      //   "username": userName,
      //   "password": password,
      // }),
    );

    Map map = json.decode(response.body);

    // print(response.statusCode);

    if (response.statusCode == 200) {
      // Message().showMsg(url, TypeMsg.warning, context);
      // if (kDebugMode) {
      //   debug.print(map["valid"]);
      // }
      if (map["valid"] == "true") {
        loginDetail.pass2FA = true;
        // Message().showMsg(map["valid"], TypeMsg.warning, context);
      }
    }

    if (loginDetail.pass2FA) {
      Message().showMsg(
        "ยินดีต้อนรับเข้าสู่ระบบ...",
        TypeMsg.information,
        context,
      );
      itemIndex = 2;
      // setState(() {

      // });
    } else {
      Message().showMsg(
        "รหัสผ่าน 2 ขั้นตอนไม่ถูกต้อง!!!",
        TypeMsg.warning,
        context,
      );
    }
    setState(() {});
    // return null;
  }

  Widget buildTextField(String code) {
    String hint = "";
    if (code == "code") {
      hint = "รหัสผ่าน2ขั้นตอน";
    }
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        // color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Responsive(
        children: <Widget>[
          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: TextFormField(
              // onTap: ()=>{colors.},
              decoration: InputDecoration(
                labelText: hint,
                hintText: hint,
                icon: Icon(Icons.password_rounded),
              ),
              // style: TextStyle(fontSize: 20, color: Colors.black),
              style: GoogleFonts.notoSansThai(
                fontSize: 20,
                color: Colors.black,
              ),
              // validator: (value) => value.toString().length != 3
              //     ? 'ชื่อผู้ใช้งานไม่ถูกต้อง'
              //     : null,
              // onSaved: (value) {
              //   if (code == "code") {
              //     code2FA = value.toString();
              //   }
              // },
              onChanged: (value) {
                if (code == "code") {
                  code2FA = value.toString();
                }
              },

              maxLength: code == "code" ? 12 : 4,
              keyboardType: code == "code"
                  ? TextInputType.number
                  : TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }

  Container buildImage(LoginDetail loginDetail) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(vertical: 5),
      // decoration: BoxDecoration(
      //     color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
      child: Responsive(
        children: <Widget>[
          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: Row(
              children: <Widget>[
                Image.asset("assets/images/doh.png", height: 100, width: 150),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    "ระบบงานสลิปใบรับรองภาษี กรมทางหลวง",
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    // style: TextStyle(fontSize: 15, color: Colors.black)
                    style: GoogleFonts.notoSansThai(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  "เข้าใช้งานครั้งล่าสุดเมื่อ:",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Noto Sans Thai',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  loginDetail.lastLoginMsg,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Noto Sans Thai',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget login(LoginDetail loginDetail) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Center(
            child: Container(
              width: 800,
              constraints: BoxConstraints(
                maxWidth: double.infinity,
                minWidth: 450.0,
              ),
              // width: 450.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade200],
                ),
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  //Image.file(image)
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.fingerprint, size: 80, color: Colors.blue),
                          // Image.asset(
                          //   "assets/images/doh.png", // The path registered in pubspec.yaml
                          //   width: 150, // Optional: set width
                          //   height: 100, // Optional: set height
                          //   fit: BoxFit
                          //       .cover, // Optional: control how the image fits
                          // ),
                          buildImage(loginDetail),
                          // SizedBox(height: 20),

                          // Text('Available biometrics: ${_availableBiometrics.join(', ')}'),
                          SizedBox(height: 15),
                          buildTextField("code"),
                          SizedBox(height: 20),
                          loginDetail.pass2FA || loginDetail.use2FA == "0"
                              ? Text("")
                              : ElevatedButton.icon(
                                  onPressed:
                                      // _isBiometricAvailable ? _authenticate : null,
                                      () async =>
                                          await processLogin(loginDetail),
                                  icon: Icon(Icons.login_sharp),
                                  label: Text('เข้าระบบ'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blue.shade900,
                                    // backgroundColor: Colors.lightGreenAccent,
                                    textStyle: GoogleFonts.notoSansThai(
                                      fontSize: 20,
                                      // fontWeight: FontWeight.bold
                                    ),
                                    // minimumSize: Size(30, 100),
                                    // maximumSize: "25",
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 15,
                                    ),
                                  ),
                                ),

                          SizedBox(height: 20),
                          // Text('Status: $_authorized'),
                        ],
                      ),
                    ),

                    // buildImage("เข้าระบบ ", loginDetail),
                    // showImg("login", loginDetail),
                    (Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   child: selectGallery("login"),
                          //   width: (logicalWidth / 2) - 25,
                          // ),
                          SizedBox(width: 5),
                          // SizedBox(
                          //   child: selectCamera("login"),
                          //   width: (logicalWidth / 2) - 25,
                          // ),
                        ],
                      ),
                    )),
                    // buildButtonRegister(loginDetail, "login"),
                    // loginDetail.token == ""
                    //     ? Text("")
                    //     : buildButtonRegister(loginDetail, "saveImg"),
                    /*
                      loginDetail.token == ""
                          ? Text("")
                          : foundPhoneId && (!errPhone)
                              ? buildButtonRegister(loginDetail, "cancelPhone")
                              : Text(""),
                      loginDetail.token == ""
                          ? Text("")
                          : foundFingerPrint
                              ? buildButtonRegister(
                                  loginDetail, "cancelFingerPrint")
                              : Text(""),

                              */
                    // buildButtonRegister(loginDetail, "manual"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
