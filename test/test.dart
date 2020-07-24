import 'package:flutter/material.dart';
import 'package:freelancer_flutter/pages/login.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {

  test("get right thing", ()async {
    final url = "http://localhost:8080/getJobs";
    var res = await http.get(url);
    print(res.headers);
    expect(res.statusCode, 200);
  });
  test("get right thing", ()async {
//    final login = LoginScreen();
//    var res = await http.get(url);
//    print(res.headers);
//    expect(res.statusCode, 200);
  });
}
