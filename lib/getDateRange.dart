// import 'package:flutter/material.dart';
import 'package:sp1/dataProvider/loginDetail';
import 'dart:convert';

import 'package:http/http.dart' as http;

class DateRange {
  Future<void> getRangeDate(LoginDetail loginDetail) async {
    if (!(loginDetail.beginDate == "")) return;
    String url = "https://dbdoh.doh.go.th/dpay/api/auth/getrangeDate";
// print(url);
    http.Response response;

    response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer ' + loginDetail.getToken
      },
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      loginDetail.beginDate = jsonData["beginDate"].toString();
      loginDetail.endDate = jsonData["endDate"].toString();
    }
  }
}
