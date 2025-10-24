// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:core' as debug;
import 'dart:core';
// import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sp1/dataProvider/loginDetail';
import 'package:sp1/message.dart';
// import 'package:sp1/ShowAlertMessage.dart';
// import 'package:sp1/getDateRange.dart';
// import 'package:dp/menu/menu.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast_example/toast_context.dart';

// GlobalKey globalKey = GlobalKey();

class MyLoginPage extends StatefulWidget {
  // MyLoginPage({Key key}) : super(key: key);
  const MyLoginPage({super.key, required this.title});
  final String title;
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final formKey = GlobalKey<FormState>();
  String userName = '';
  String password = '';
  bool cursorWait = false;
  String alertMsg = "";

  String urlSal = "https://dbdoh.doh.go.th/saldoh"; //:9000";
  // late FToast fToast;
  _MyLoginPageState() {
    //this.getMsg(loginDetail);
    //  _StatefulWidgetDemoState() {
    //   getTextFromFile().then((val) => setState(() {
    //         _textFromFile = val;
    //       }));
  }
  @override
  void initState() {
    super.initState();
    // fToast = FToast();
    // fToast.init(context);
  }

  // late var theme;
  @override
  Widget build(BuildContext context) {
    // theme = Theme.of(context);
    return Scaffold(
      //  key: globalKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Consumer<LoginDetail>(
        builder: (context, loginDetail, child) => ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            cursorWait ? Center(child: CircularProgressIndicator()) : Text(""),
            FutureBuilder(
              future: getMsg(loginDetail),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("ERROR: ${snapshot.error}");
                } else {
                  return Container(
                    color: Colors.green[50],
                    child: Center(
                      child: Container(
                        width: 800,
                        // height: 500,
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
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              buildImage(),
                              buildTextFieldEmail(),
                              buildTextFieldPassword(),
                              // buildButtonSignIn(loginDetail),
                              buildOptionRow(loginDetail),
                              buildMsg(loginDetail),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  //  late Widget toast;
  // ignore: unused_element
  // _showToast() {
  //     // ignore: unused_local_variable
  //      toast = Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  //         decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(25.0),
  //         color: Colors.greenAccent,
  //         ),
  //         child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //             Icon(Icons.check),
  //             SizedBox(
  //             width: 12.0,
  //             ),
  //             Text("This is a Custom Toast"),
  //         ],
  //         ),
  //     );

  // }

  //bool passLogin=false;
  // ignore: unnecessary_statements
  // Login msg = Login(
  //   id: "",
  //   accessToken: "",
  //   deptName: "",
  //   div: "",
  //   email: "",
  //   tokenType: "",
  //   username: "",
  //   roles: [],
  // );
  Future<bool> chkLogin(
    String userName,
    String password,
    LoginDetail loginDetail,
  ) async {
    String url = "$urlSal/login";
    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": userName,
        "password": password,
      }),
    );
    // if (!mounted) return false;
    // Message().showMsg(
    //         "ยินดีต้อนรับ $userName เข้าสู่ระบบ",
    //         TypeMsg.information,
    //         context,
    //       );
    // int code = response.statusCode;
    // Message().showMsg(
    //   code.toString(),
    //   TypeMsg.information,
    //   context,
    // );

    Map map = json.decode(response.body);

    // print(response.statusCode);

    if (response.statusCode == 200) {
      loginDetail.token = map["accessToken"];
      loginDetail.passLogin = true;

      // this.passLogin=true;
      //'Authorization': 'Bearer $token',
      // msg = Login.fromJson(map);
      //  msg.deptName=     map["deptName"];
      //  msg.username=map["username"];
      //  msg.div=map["div"];
      //  msg.roles=map["role"];
    } else {
      //  Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => ToastContext(),
      // ));
      // Fluttertoast.showToast(
      //   msg: "ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง",
      //   toastLength: Toast.LENGTH_LONG,
      //   timeInSecForIosWeb: 1,
      //   gravity: ToastGravity.CENTER,
      //   backgroundColor: Colors.red.shade100,
      //   textColor: Colors.white,
      //   fontSize: 30.0,
      // );
      // Message().showMsg(
      //     "ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง", TypeMsg.Warning, context);
      /*
      Flushbar(
        titleText: Text("ระบบหักหนี้",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.yellow.shade600)),
        // titleColor: Colors.white,
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.blueGrey,
        icon: Icon(
          Icons.warning_rounded,
          color: Colors.greenAccent,
        ),
        messageText: Text(
          "ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.yellow.shade600),
        ),
        duration: Duration(seconds: 3),
        // reverseAnimationCurve: Curves.decelerate,
        // forwardAnimationCurve: Curves.elasticOut,
        //  boxShadows: [
        //   BoxShadow(
        //       color: Colors.blue.shade800,
        //       offset: Offset(0.0, 2.0),
        //       blurRadius: 3.0)
        // ],
        // backgroundGradient:
        //     LinearGradient(colors: [Colors.blueGrey, Colors.black]),
        isDismissible: false,
        // backgroundColor: Colors.green.shade100,
        // messageSize: 16,
        // messageColor: Colors.red,
      )..show(context);
*/
      // Custom Toast Position
      // fToast.showToast(
      //     child: toast,
      //     toastDuration: Duration(seconds: 30),
      //     positionedToastBuilder: (context, child) {
      //       return Positioned(
      //         child: child,
      //         top: 160.0,
      //         left: 160.0,
      //       );
      //     });
      // showAnimatedDialog(
      //   context: context,
      //   barrierDismissible: true,
      //   builder: (BuildContext context) {
      //     return ClassicGeneralDialogWidget(
      //       titleText: 'ระบบหักหนี้',
      //       contentText: 'ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง',
      //       onPositiveClick: () {
      //         Navigator.of(context).pop();
      //       },
      //       onNegativeClick: () {
      //         Navigator.of(context).pop();
      //       },
      //     );
      //   },
      //   animationType: DialogTransitionType.fadeScale,
      //   curve: Curves.fastOutSlowIn,
      //   duration: Duration(seconds: 1),
      // );
      // throw Exception('Failed to ');
      Message().showMsg(
        "${response.statusCode} error  ==> ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง",
        TypeMsg.warning,
        context,
      );

      return false;
    }
    // print("msg= " + msg.username);
    return true;
  }

  Widget buildButtonSignIn(LoginDetail loginDetail) {
    return InkWell(
      onTap: () async {
        if (formKey.currentState!.validate()) {
          // SystemChannels.mouseCursor.invokeMethod<void>('setCursor', 'wait');
          cursorWait = true;
          formKey.currentState!.save();
          // print('$userName : $password');
          // ignore: unused_local_variable
          loginDetail.passLogin = await chkLogin(
            userName,
            password,
            loginDetail,
          );

          if (!loginDetail.passLogin) return;
          // print(msg.accessToken);
          //print(msg.roles);

          //print(msg.deptName);
          // loginDetail.setUserName = userName;//   msg.username;
          // loginDetail.setToken = msg.accessToken;
          // loginDetail.setPassLogin = true;
          // loginDetail.setRole = msg.roles;
          // loginDetail.setDeptName = msg.deptName;
          // loginDetail.div = msg.div;
          // loginDetail.setDeptE = "";
          // loginDetail.setDeptG = "";
          // loginDetail.setMonth = "";
          // loginDetail.setYear = "";

          //save last login
          //http.Response response;
          String url = "$urlSal/userLogin/$userName";
          //response =
          http.Response response = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Access-Control-Allow-Origin': '*',
              'Content-Type': 'application/json;charset=UTF-8',
              'Accept': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer   ${loginDetail.token}',
            },
            // body: jsonEncode(param_body2),
          );

          // await findDeptSuccess(loginDetail);
          // for (var item in loginDetail.getRole) {
          //   print(item);
          //   if (item=="ROLE_USER") print("user");
          // }
          //  print(passLogin);

          Map map = json.decode(response.body);
          loginDetail.userName = map["username"];
          loginDetail.id = map["id"].toString();
          loginDetail.idcard = map["idcard"];
          loginDetail.use2FA = map["use2FA"];
          if (map["roles"] != null) {
            try {
              for (var v in map["roles"]) {
                // if role entry is a map with an 'id' field, store the id; otherwise store the value
                if (v is Map && v.containsKey('id')) {
                  if (v['id'].toString() == ("2")) {
                    loginDetail.uploadFile = "1";
                  } else if (v['id'].toString() == ("1")) {
                    loginDetail.downloadFile = "1";
                  }
                } else {
                  loginDetail.downloadFile = "0";
                  loginDetail.uploadFile = "0";
                }
              }
            } catch (e) {
              // ignore malformed roles data
            }
          }
          url = "$urlSal/user2Period/$loginDetail.idcard";
          //response =
          response = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Access-Control-Allow-Origin': '*',
              'Content-Type': 'application/json;charset=UTF-8',
              'Accept': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer   ${loginDetail.token}',
            },
            // body: jsonEncode(param_body2),
          );

          map = json.decode(response.body);
          if (map["found"] == "true") {
            loginDetail.has2Period = map["found"];
            loginDetail.year2Period = map["year"];
          } else {
            loginDetail.has2Period = "false";
            loginDetail.year2Period = "";
          }

          loginDetail.lastLoginMsg = await getLastLogin(loginDetail.idcard);
          insertLastLogin(loginDetail.idcard, "sp"); //not need to use await

          // Message().showMsg(
          //             "ยินดีต้อนรับ ${loginDetail.userName} เข้าสู่ระบบ",
          //             TypeMsg.information,
          //             context,
          //           );
          if (kDebugMode) {
            debug.print("Login Detail:");
            debug.print(loginDetail.userName);
            debug.print(loginDetail.id);
            debug.print(loginDetail.idcard);
            debug.print(loginDetail.use2FA);
            debug.print(loginDetail.uploadFile);
            debug.print(loginDetail.downloadFile);
            debug.print(loginDetail.has2Period);
            debug.print(loginDetail.year2Period);
            debug.print(loginDetail.lastLoginMsg);
            debug.print("Login Detail:");
          }

          if (loginDetail.userName != "") {
            if (!mounted) return;
            Navigator.pushNamed(context, "/menu");
          }
          // else {
          //   print("not login");
          // }
          // SystemChannels.mouseCursor.invokeMethod<void>('setCursor', 'basic');
          cursorWait = false;
        }
      },
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // color: Colors.green[200],
        ),

        // child: TextFormField(
        //   showCursor: false,
        //   readOnly: true,

        //   decoration: InputDecoration(

        //       // labelText: "เข้าระบบ",
        //       hintText: "เข้าระบบ",
        //       icon: Icon(Icons.login_rounded)),
        //   style: TextStyle(fontSize: 18, color: Colors.black),
        //   textAlign: TextAlign.center,
        // ),
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.all(5),
        child: Responsive(
          children: <Widget>[
            Div(
              divison: const Division(colS: 12, colM: 12, colL: 12),
              child: RichText(
                // combine txt
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    // TextSpan(
                    //   text: "Click ",
                    // ),
                    WidgetSpan(child: Icon(Icons.login_rounded, size: 25)),
                    TextSpan(
                      text: " เข้าระบบ",
                      // style: theme.textTheme.bodyLarge!.copyWith(
                      //   fontSize: 20.0,
                      //   color: Colors.black,
                      // ),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Noto Sans Thai',
                        color: Colors.black,
                      ),

                      // style: GoogleFonts.notoSansThai(
                      //   fontSize: 20,
                      //   color: Colors.black,
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getLastLogin(String idcard) async {
    String url = "$urlSal/findLastLogin?idcard=$idcard";
    // print(url);
    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(
      //     <String, String>{"username": username, "password": password}),
    );
    Map map = json.decode(response.body);
    // print(map);
    // print(map.keys.first);
    if (response.statusCode == 200) {
      return map.keys.first;
    }

    return "";
  }

  Future<void> insertLastLogin(String idcard, String app) async {
    String type = "M";
    // DateTime datetime = DateTime.now();
    // String last = datetime.toString();
    String last = ""; //datetime.toString();
    NumberFormat formatter = NumberFormat("00");
    DateTime now = DateTime.now();
    String d = formatter.format(now.day);
    String m = formatter.format(now.month);
    String y = formatter.format(now.year + 543);
    String h = formatter.format(now.hour);
    String mi = formatter.format(now.minute);
    String s = formatter.format(now.second);
    last = "$d/$m/$y  $h:$mi:$s";

    String url =
        "$urlSal/insertLastLogin?idcard=$idcard&type=$type&last='$last'&app=$app";
    // print(url);
    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(
      //     <String, String>{"username": username, "password": password}),
    );
    // Map map = json.decode(response.body);
    // print(map);
    if (response.statusCode == 200) {}
  }

  Widget buildTextFieldEmail() {
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
                labelText: "ชื่อผู้ใช้งาน",
                hintText: "ชื่อผู้ใช้งาน",
                icon: Icon(Icons.supervised_user_circle),
              ),
              // style: TextStyle(fontSize: 20, color: Colors.black),
              style: GoogleFonts.notoSansThai(
                fontSize: 20,
                color: Colors.black,
              ),
              // validator: (value) => value.toString().length != 3
              //     ? 'ชื่อผู้ใช้งานไม่ถูกต้อง'
              //     : null,
              onSaved: (value) => userName = value.toString(),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Container buildTextFieldPassword() {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        // color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Responsive(
        children: <Widget>[
          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: TextFormField(
              validator: (value) =>
                  value.toString().isNotEmpty ? null : "ต้องบันทึกรหัสผ่าน",
              onSaved: (value) => password = value.toString(),
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "รหัสผ่าน",
                labelText: "รหัสผ่าน",
                icon: Icon(Icons.lock_outline),
              ),
              // style: TextStyle(fontSize: 18, color: Colors.black)
              style: GoogleFonts.notoSansThai(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildImage() {
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
        ],
      ),
    );
  }

  Future<void> getMsg(LoginDetail loginDetail) async {
    // await Menu(
    //   title: '',
    // ).createState().getMonthYear(loginDetail);
    // await Menu(
    //   title: '',
    // ).createState().allDeptList(loginDetail);
    // await ShowAlertMsg().getAlertMessage(loginDetail);
    // await DateRange().getRangeDate(loginDetail);
    if (loginDetail.alertMsg != "") return;
    loginDetail.alertMsg =
        "ใช้งานผ่านเว็บเบราว์เซอร์ได้ที่ลิงก์ https://dbdoh.doh.go.th/yt";
  }

  Widget buildMsg(LoginDetail loginDetail) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Responsive(
        children: <Widget>[
          Div(
            divison: const Division(colS: 12, colM: 12, colL: 12),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  // TextSpan(
                  //   text: "Click ",
                  // ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () async {
                        String url = "https://dbdoh.doh.go.th/yt/";
                        final Uri url0 = Uri.parse(url);

                        if (!await launchUrl(url0)) {
                          throw 'Could not launch $url0';
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.webhook_rounded, size: 40),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              loginDetail.alertMsg,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Noto Sans Thai',
                                color: Colors.black,
                              ),
                            ),
                          ),

                          //   text: loginDetail.alertMsg,
                          //   // style: TextStyle(fontSize: 18, color: Colors.black),
                          //   style: GoogleFonts.notoSansThai(
                          //     fontSize: 20,
                          //     color: Colors.black,

                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //row
  Widget buildOptionRow(LoginDetail loginDetail, {String colorBG = ""}) {
    //select_GE=_selectMenu == SelectMenu.mnuEditG ? 1:2;
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        // color: colorBG == "deduct" ? Colors.green[50] : Colors.yellow[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: buildButtonSignIn(loginDetail)),
              SizedBox(width: 10),
              Expanded(child: buildButtonManual(loginDetail)),
            ],
          ),
        ],
      ),
    );
  }

  //row
  Widget buildButtonManual(LoginDetail loginDetail) {
    return InkWell(
      onTap: () async {
        String url = "https://dbdoh.doh.go.th/yt/assets/images/ytManual.pdf";
        final Uri url0 = Uri.parse(url);

        if (!await launchUrl(url0)) throw 'Could not launch $url0';
      },
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // color: Colors.green[200],
        ),
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.all(5),
        child: Responsive(
          children: <Widget>[
            Div(
              divison: const Division(colS: 12, colM: 12, colL: 12),
              child: RichText(
                // combine txt
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    // TextSpan(
                    //   text: "Click ",
                    // ),
                    WidgetSpan(child: Icon(Icons.help, size: 25)),
                    TextSpan(
                      text: " คู่มือการใช้งาน",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Noto Sans Thai',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} //" ระบบงานอยู่ในสถานะการทดสอบการใช้งาน ชื่อผู้ใช้งานเป็นรหัสหน่วยงานตัวเลข 3 หลักรหัสผ่านเป็น doh123 ข้อมูลที่ทดสอบเป็นเดือน พ.ย. ปี 2564"
