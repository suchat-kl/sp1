// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

// import 'dart:io';

import 'dart:convert';
// import 'dart:core' as debug;

// import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:responsive_ui/responsive_ui.dart';

import 'package:url_launcher/url_launcher.dart';

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

  String pwdType = "none";
  String pwd = "x";
  bool accType = true;
  bool register2FA = false;
  final formKey = GlobalKey<FormState>();
  bool disableAll = false;

  MouseCursor _currentCursor = SystemMouseCursors.basic;
  // final _editableKey = GlobalKey<EditableState>();
  // bool _isBiometricAvailable = false;
  // String _authorized = 'Not Authorized';
  String appTitle = "",
      code2FA = "",
      taxYear = "",
      curMonth = "",
      curYear = ""; // "ลงทะเบียน";
  // List<BiometricType> availableBiometrics = [];
  // List tabName = ['ลงทะเบียน', 'เข้าระบบ', 'ภาษี', 'สลิป', 'รายละเอียด'];
  List tabName = ['เข้าระบบ', 'ภาษี', 'สลิป'];
  List<DropdownMenuItem<String>> monthName = [
    DropdownMenuItem(value: "01", child: Text("มกราคม")),
    DropdownMenuItem(value: "02", child: Text("กุมภาพันธ์")),
    DropdownMenuItem(value: "03", child: Text("มีนาคม")),
    DropdownMenuItem(value: "04", child: Text("เมษายน")),
    DropdownMenuItem(value: "05", child: Text("พฤษภาคม")),
    DropdownMenuItem(value: "06", child: Text("มิถุนายน")),
    DropdownMenuItem(value: "07", child: Text("กรกฎาคม")),
    DropdownMenuItem(value: "08", child: Text("สิงหาคม")),
    DropdownMenuItem(value: "09", child: Text("กันยายน")),
    DropdownMenuItem(value: "10", child: Text("ตุลาคม")),
    DropdownMenuItem(value: "11", child: Text("พฤศจิกายน")),
    DropdownMenuItem(value: "12", child: Text("ธันวาคม")),
  ];

  @override
  @override
  void initState() {
    super.initState();
    // _checkBiometric();
    appTitle = widget.title; // tabName[itemIndex];
    DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    taxYear = formatted.split("-")[0];
    taxYear = (int.parse(taxYear) - 1 + 543).toString().trim(); //tax year
    curMonth = formatted.split("-")[1];
    curYear = (int.parse(taxYear) + 1).toString().trim();
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
    return MouseRegion(
      cursor: _currentCursor,
      child: Scaffold(
        appBar:
            //  AppBar(title: Text('ระบบสลิปใบภาษีกรมทางหลวง')),
            AppBar(
              // automaticallyImplyLeading: false,
              backgroundColor: Colors.green.shade400,
              title: Text(
                appTitle,
                style: GoogleFonts.notoSansThai(
                  fontSize: 15,
                  color: Colors.white,
                ),

                // style: TextStyle(color: Colors.white, fontSize: 15,),
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
                return visibilityPage(loginDetail) ?? SizedBox.shrink();
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
            selectedIconTheme: IconThemeData(
              color: Colors.amberAccent,
              size: 35,
            ),
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
              if (disableAll) return;
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
      ),
    );
  }

  void signOut(BuildContext context, LoginDetail loginDetail) {
    if (disableAll) return;
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

  Widget? visibilityPage(LoginDetail loginDetail) {
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

    return Visibility(
      visible: show,
      child: selectMethod(choice, loginDetail) ?? SizedBox.shrink(),
    );
  }

  Widget? selectMethod(int choice, LoginDetail loginDetail) {
    switch (choice) {
      case 1:
        return loginDetail.use2FA == "1"
            ? login(loginDetail)
            : loginDetail.use2FA == "0"
            ? register(loginDetail)
            : Text("");
      //register(loginDetail);
      case 2:
        return repTax(loginDetail);
      case 3:
        return repSlip(loginDetail);
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
        "รหัสผ่านสองขั้นตอนต้องเท่ากับหกหลัก",
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
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
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
        "ยินดีต้อนรับ ${loginDetail.userName} เข้าสู่ระบบ...",
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
    String hint = "", defaultVal = "";
    int maxLen = 0;
    if (code == "code") {
      hint = "รหัสผ่าน2ขั้นตอน";
      maxLen = 6;
    } else if (code == "year") {
      hint = "ปี พ.ศ.";
      maxLen = 4;
      if (itemIndex == 1) //tax
      {
        defaultVal = taxYear;
      } else if (itemIndex == 2) //slip
      {
        defaultVal = curYear;
      }
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
                icon: code == "code"
                    ? Icon(Icons.wifi_password)
                    : Icon(Icons.date_range_rounded),
              ),
              // style: TextStyle(fontSize: 15, color: Colors.black),
              initialValue: defaultVal,
              style: GoogleFonts.notoSansThai(
                fontSize: 15,
                color: Colors.black,
              ),
              // validator: (value) => value.toString().length != maxLen
              //     ? 'ความยาวตัวอักษรไม่เท่ากับ $maxLen'
              //     : null,
              // onSaved: (value) {
              //   if (code == "code") {
              //     code2FA = value.toString();
              //   }
              // },
              onChanged: (value) {
                if (code == "code") {
                  code2FA = value.toString();
                } else if (code == "year") {
                  if (itemIndex == 1) //tax
                  {
                    taxYear = value.toString();
                  } else if (itemIndex == 2) //slip
                  {
                    curYear = value.toString();
                  }
                }
              },

              maxLength: maxLen,
              keyboardType: TextInputType.number,
              // keyboardType: code == "code"
              //     ? TextInputType.number
              //     : TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPwdRep() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        // color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Responsive(
        children: <Widget>[
          itemIndex == 1
              ? Text("")
              : Div(
                  divison: const Division(colS: 12, colM: 12, colL: 12),
                  child: Expanded(
                    child: CheckboxListTile(
                      activeColor: Colors.green,
                      title: Text(
                        "แสดงเลขบัญชีธนาคาร",
                        style: GoogleFonts.notoSansThai(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      value: accType,
                      onChanged: (bool? value) {
                        setState(() {
                          accType = value!;
                        });
                      },
                      controlAffinity:
                          ListTileControlAffinity.leading, // checkbox at start
                    ),
                  ),
                ),

          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "ไม่ใช้รหัสผ่านในการสร้างรายงาน",
                  style: GoogleFonts.notoSansThai(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                leading: Radio<String>(
                  toggleable: false, //unselect ==null
                  value: "none",
                  // ignore: deprecated_member_use
                  groupValue: pwdType,
                  // ignore: deprecated_member_use
                  onChanged: (String? value) {
                    setState(() {
                      pwdType = "none";
                      pwd = "x";
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
            ),
          ),

          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "ใช้เลขบัตรประชาชนในการสร้างรหัสผ่าน13ตัว",
                  style: GoogleFonts.notoSansThai(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                leading: Radio<String>(
                  toggleable: false, //unselect ==null
                  value: "idcard",
                  // ignore: deprecated_member_use
                  groupValue: pwdType,
                  // ignore: deprecated_member_use
                  onChanged: (String? value) {
                    setState(() {
                      pwdType = "idcard";
                      pwd = "x";
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
            ),
          ),
          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "ใช้วันเกิดในการสร้างรหัสผ่าน(วันที่2หลักเดือน2หลักพศ4หลัก)",
                  style: GoogleFonts.notoSansThai(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                leading: Radio<String>(
                  toggleable: false, //unselect ==null
                  value: "birthdate",
                  // ignore: deprecated_member_use
                  groupValue: pwdType,
                  // ignore: deprecated_member_use
                  onChanged: (String? value) {
                    setState(() {
                      pwdType = "birthdate";
                      pwd = "x";
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
            ),
          ),

          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "กำหนดรหัสผ่านเอง",
                  style: GoogleFonts.notoSansThai(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                leading: Radio<String>(
                  toggleable: false, //unselect ==null
                  value: "custom",
                  // ignore: deprecated_member_use
                  groupValue: pwdType,
                  // ignore: deprecated_member_use
                  onChanged: (String? value) {
                    setState(() {
                      pwdType = "custom";
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
            ),
          ),
          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: Expanded(
              child: TextFormField(
                // onTap: ()=>{colors.},
                decoration: InputDecoration(
                  labelText: "กำหนดรหัสผ่าน3-10ตัว",
                  hintText: "กำหนดรหัสผ่าน3-10ตัว",
                  icon: Icon(Icons.vpn_key_rounded),
                ),
                // style: TextStyle(fontSize: 15, color: Colors.black),
                style: GoogleFonts.notoSansThai(
                  fontSize: 15,
                  color: Colors.black,
                ),
                enabled: pwdType == "custom" ? true : false,
                maxLength: 10,
                validator: (value) =>
                    value.toString().length < 3 || value.toString().length > 10
                    ? 'ความยาวตัวอักษรต้องอยู่ระหว่าง 3-10 ตัว'
                    : null,
                onChanged: (value) {
                  pwd = value.toString();
                },

                // maxLength: maxLen,
                keyboardType: TextInputType.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(LoginDetail loginDetail) {
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
                      fontSize: 15,
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
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "ใช้งานล่าสุด:",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Noto Sans Thai',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      loginDetail.lastLoginMsg,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Noto Sans Thai',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> buildQrCode(LoginDetail loginDetail) async {
    if (loginDetail.idcard == "") {
      return Text("");
    }
    String url =
        "${loginDetail.urlSal}/setup-2fa?username=${loginDetail.userName}";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer   ${loginDetail.token}',
      },
      // body: jsonEncode(<String, String>{
      //   "username": userName,
      //   "password": password,
      // }),
    );

    // Map map = json.decode(response.body);

    // print(response.statusCode);

    if (response.statusCode == 200) {
    } else {
      Message().showMsg(
        "ไม่สามารถสร้าง QR Code ได้!!!",
        TypeMsg.warning,
        context,
      );
      return Text("");
    }

    url =
        "${loginDetail.urlSal}/downloadRep/${loginDetail.idcard}?yt=88&mt=88&period=qr";
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(vertical: 5),
      // decoration: BoxDecoration(
      //     color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
      child: Responsive(
        children: <Widget>[
          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: Column(
              children: <Widget>[
                // Text("สแกน QR Code ด้วยแอป Google Authenticator",
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontFamily: 'Noto Sans Thai',
                //       color: Colors.black,
                //     )),
                SizedBox(height: 5),

                Image.network(url, fit: BoxFit.cover, height: 300, width: 300),
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
                          buildImage(loginDetail),
                          // SizedBox(height: 5),

                          // Text('Available biometrics: ${_availableBiometrics.join(', ')}'),
                          SizedBox(height: 5),
                          buildTextField("code"),
                          SizedBox(height: 5),
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
                                      fontSize: 15,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget register(LoginDetail loginDetail) {
    disableAll = true;
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
                          buildImage(loginDetail),
                          SizedBox(height: 5),
                          FutureBuilder<Widget>(
                            future: buildQrCode(loginDetail),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Text("ERROR: ${snapshot.error}");
                              } else {
                                return snapshot.data ?? Text("");
                              }
                            },
                          ),
                          // Text('Available biometrics: ${_availableBiometrics.join(', ')}'),
                          SizedBox(height: 5),
                          Text(
                            "นำมือถือมาสแกน qrcode ด้วยแอป Google Authenticator เสร็จแล้วกดปุ่มลงทะเบียน",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Noto Sans Thai',
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),

                          Row(
                            children: [
                              register2FA
                                  ? Text("")
                                  : ElevatedButton.icon(
                                      onPressed: () async {
                                        disableAll = false;
                                        register2FA = true;
                                        await update2FA(loginDetail);
                                        signOut(context, loginDetail);

                                        // setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.app_registration_rounded,
                                      ),
                                      label: Text('ลงทะเบียน'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.blue.shade900,
                                        // backgroundColor: Colors.lightGreenAccent,
                                        textStyle: GoogleFonts.notoSansThai(
                                          fontSize: 15,
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
                              SizedBox(width: 5),
                              ElevatedButton.icon(
                                onPressed:
                                    // _isBiometricAvailable ? _authenticate : null,
                                    () async {
                                      disableAll = false;
                                      signOut(context, loginDetail);
                                      // setState(() {});
                                    },
                                icon: Icon(Icons.exit_to_app),
                                label: Text('ยกเลิก'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.blue.shade900,
                                  // backgroundColor: Colors.lightGreenAccent,
                                  textStyle: GoogleFonts.notoSansThai(
                                    fontSize: 15,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget repTax(LoginDetail loginDetail) {
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
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
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
                          buildImage(loginDetail),
                          SizedBox(height: 5),
                          buildTextField("year"),
                          SizedBox(height: 5),
                          // buildPwdRep(),
                          SizedBox(height: 5),
                          loginDetail.pass2FA || loginDetail.use2FA == "0"
                              ? ElevatedButton.icon(
                                  onPressed: () async =>
                                      await processTax(loginDetail),
                                  icon: Icon(Icons.login_sharp),
                                  label: Text('รายงานภาษี'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blue.shade900,
                                    // backgroundColor: Colors.lightGreenAccent,
                                    textStyle: GoogleFonts.notoSansThai(
                                      fontSize: 15,
                                      // fontWeight: FontWeight.bold
                                    ),
                                    // minimumSize: Size(30, 100),
                                    // maximumSize: "25",
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 15,
                                    ),
                                  ),
                                )
                              : Text(""),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget repSlip(LoginDetail loginDetail) {
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
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
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
                          buildImage(loginDetail),
                          SizedBox(height: 5),
                          buildTextField("year"),
                          SizedBox(height: 5),
                          buildDropDownMonth(loginDetail),
                          SizedBox(height: 5),
                          // buildPwdRep(),
                          SizedBox(height: 5),
                          loginDetail.pass2FA || loginDetail.use2FA == "0"
                              ? ElevatedButton.icon(
                                  onPressed: () async =>
                                      await processSlip(loginDetail),
                                  icon: Icon(Icons.login_sharp),
                                  label: Text('รายงานสลิป'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blue.shade900,
                                    // backgroundColor: Colors.lightGreenAccent,
                                    textStyle: GoogleFonts.notoSansThai(
                                      fontSize: 15,
                                      // fontWeight: FontWeight.bold
                                    ),
                                    // minimumSize: Size(30, 100),
                                    // maximumSize: "25",
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 15,
                                    ),
                                  ),
                                )
                              : Text(""),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildDropDownMonth(LoginDetail loginDetail) {
    //loginDetail.getMonth.toString();
    return Container(
      constraints: BoxConstraints(
        minWidth: 500.0,
        // maxWidth: 500.0,
      ),
      // width: 500,
      // alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        // color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButton<String>(
        // hint: Text("month"),
        focusColor: Colors.black,
        elevation: 8,

        //  autofocus: true,
        //  icon: Icon(Icons.share_arrival_time_outlined,textDirection: TextDirection.ltr,) ,
        style: TextStyle(
          fontSize: 15, //loginDetail.logicalWidth * 0.06 * (1 / 3), //16,
          color: Colors.black,
          fontFamily: 'Noto Sans Thai',
        ),
        value: curMonth,
        items: monthName,
        onChanged: (value) {
          setState(() {
            curMonth = value.toString();
          });
        },
      ),
    );
  }

  Future<void> processTax(LoginDetail loginDetail) async {
    setState(() {
      _currentCursor = SystemMouseCursors.wait;
    });
    String yt = taxYear;
    String mt = "00";
    String period = "2";
    // String pwdType = "none";
    // String pwd = "";
    // String accType = "true";
    String bkno = accType ? "true" : "false";
    String url =
        "${loginDetail.urlSal}/repYT/${loginDetail.idcard}?yt=$yt&mt=$mt&period=$period&pwdTyep=$pwdType&pwd=$pwd&bkno=$bkno";
    // AlertDialogMsg().showAlertDialog(context, code2FA, url);

    http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer   ${loginDetail.token}',
      },
      // body: jsonEncode(<String, String>{
      //   "username": userName,
      //   "password": password,
      // }),
    );

    // Map map = json.decode(response.body);

    // print(response.statusCode);

    if (response.statusCode == 200) {
      url =
          "${loginDetail.urlSal}/downloadRep/${loginDetail.idcard}?yt=$yt&mt=$mt&period=$period";

      final Uri url0 = Uri.parse(url);

      if (!await launchUrl(url0)) {
        throw 'Could not launch $url0';
      }
    }
    if (mounted) {
      setState(() {
        _currentCursor = SystemMouseCursors.basic;
      });
    }
    // setState(() {});
    // return null;
  }

  Future<void> processSlip(LoginDetail loginDetail) async {
    setState(() {
      _currentCursor = SystemMouseCursors.wait;
    });
    String yt = curYear;
    String mt = curMonth;
    String period = "2";
    // String pwdType = "none";
    // String pwd = "";
    // String accType = "true";
    String bkno = accType ? "true" : "false";
    String url =
        "${loginDetail.urlSal}/repYT/${loginDetail.idcard}?yt=$yt&mt=$mt&period=$period&pwdTyep=$pwdType&pwd=$pwd&bkno=$bkno";
    // AlertDialogMsg().showAlertDialog(context, code2FA, url);
    // AlertDialogMsg().showAlertDialog(context, "url", url);
    http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer   ${loginDetail.token}',
      },
      // body: jsonEncode(<String, String>{
      //   "username": userName,
      //   "password": password,
      // }),
    );

    // Map map = json.decode(response.body);

    // print(response.statusCode);

    if (response.statusCode == 200) {
      url =
          "${loginDetail.urlSal}/downloadRep/${loginDetail.idcard}?yt=$yt&mt=$mt&period=$period";

      final Uri url0 = Uri.parse(url);

      if (!await launchUrl(url0)) {
        throw 'Could not launch $url0';
      }
    }
    if (mounted) {
      setState(() {
        _currentCursor = SystemMouseCursors.basic;
      });
    }
    // setState(() {});
    // return null;
  }

  Future<void> update2FA(LoginDetail loginDetail) async {
    if (mounted) {
      setState(() {
        _currentCursor = SystemMouseCursors.wait;
      });
    }
    String url =
        "${loginDetail.urlSal}/update-2fa?idcard=${loginDetail.idcard}";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer   ${loginDetail.token}',
      },
      // body: jsonEncode(<String, String>{
      //   "username": userName,
      //   "password": password,
      // }),
    );

    // Map map = json.decode(response.body);
    if (response.statusCode == 200) {
    } else {
      Message().showMsg(
        "ไม่สามารถ update 2FA ได้!!!",
        TypeMsg.warning,
        context,
      );
    }
    if (mounted) {
      setState(() {
        _currentCursor = SystemMouseCursors.basic;
      });
    }
  }
}
