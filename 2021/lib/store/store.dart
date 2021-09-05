import 'dart:convert';

import 'package:AttenBuddy/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Store extends ChangeNotifier {
  final Services scv = Services();

  String theme = 'dark';
  int selectedIndex = 0;

  String userId = "";
  String password = "";
  bool authenticated = false;

  String level = "Denied";
  String dropsState = "none";
  String batchId = "0";
  DateTime selectedDate = DateTime.now();

  List<String> present;
  List<String> absent;

  List<dynamic> courses;
  List<dynamic> student;
  List<String> list = ['none'];

  void toggleTheme(context) {
    if (this.theme.compareTo('dark') == 0) {
      this.theme = 'light';
    } else {
      this.theme = 'dark';
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Theme Changed to ' + this.theme)));
    notifyListeners();
  }

  void navigate(int data, BuildContext context) async {
    switch (data) {
      case 0:
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(context, "Home", (r) => false);
        break;
      case 1:
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(context, "Account", (r) => false);
        break;
      case 2:
        SystemNavigator.pop();
        break;
    }
    this.selectedIndex = data;
  }

  Future setAuth() async {
    var url = Uri.https(dotenv.env['SERVER'], "/isauth");
    var response =
        await http.post(url, body: {'userid': userId, 'password': password});

    var decoded = json.decode(response.body);

    if (decoded['success'].toString().compareTo("True") == 0) {
      this.level = decoded['data']['level'];

      url = Uri.https(dotenv.env['SERVER'], "/getcourse");
      response = await http.get(url);
      decoded = json.decode(response.body);

      list = ['none'];
      for (var i = 0; i < decoded['data'].length; i++) {
        if (decoded['data'].elementAt(i)['teacher'].compareTo(userId) == 0) {
          list.add(decoded['data'].elementAt(i)['name']);
          if (courses == null)
            courses = [decoded['data'].elementAt(i)];
          else
            courses.add(decoded['data'].elementAt(i));
        }
      }

      url = Uri.https(dotenv.env['SERVER'], "/getstudent");
      response = await http.get(url);
      decoded = json.decode(response.body);

      student = [];
      absent = [];
      present = [];
      for (var i = 0; i < decoded['data'].length; i++) {
        if (student == null) {
          student = [decoded['data'].elementAt(i)];
          absent = [decoded['data'].elementAt(i)['userid']];
        } else {
          student.add(decoded['data'].elementAt(i));
          absent.add(decoded['data'].elementAt(i)['userid']);
        }
      }
    }
    notifyListeners();
  }

  take(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, "Attendance", (r) => false);
  }

  view(BuildContext context) async {
    if (await helper() == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, "AttendanceView", (r) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sheet Not Found')));
    }
    notifyListeners();
  }

  selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked == null) return;
    this.selectedDate = picked;
    notifyListeners();
  }

  toggle(String s) {
    String check =
        this.absent.singleWhere((element) => element == s, orElse: () => null);

    if (check == null) {
      if (this.absent == null) {
        this.absent = [s];
      } else {
        this.absent.add(s);
      }
      this.present.remove(s);
    } else {
      if (this.present == null) {
        this.present = [s];
      } else {
        this.present.add(s);
      }
      this.absent.remove(s);
    }
    notifyListeners();
  }

  List<Widget> listBuilder(BuildContext context) {
    List<Widget> wid = [];

    for (int i = 0; i < this.student.length; i++) {
      if (this.student[i]['batch'].compareTo(batchId) != 0) continue;
      String check = absent.singleWhere(
          (element) => element == this.student[i]['userid'],
          orElse: () => null);

      wid.add(Card(
        child: ListTile(
          leading: Icon(Icons.account_circle_rounded, color: Colors.black),
          title: Text(this.student[i]['userid']),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          hoverColor: (check != null) ? Colors.redAccent : Colors.green,
          tileColor: (check != null) ? Colors.redAccent : Colors.green,
          onTap: () {
            toggle(this.student[i]['userid']);
          },
        ),
      ));
    }

    return wid;
  }

  Future helper() async {
    final jsonEncoder = JsonEncoder();
    var url = Uri.https(dotenv.env['SERVER'], "/getsheet");
    var body = {
      'course': this.dropsState,
      'teacher': this.userId,
      'date': "${this.selectedDate.toLocal()}".split(' ')[0],
      'batch': this.batchId
    };

    var response = await http.post(url, body: body);

    if (json.decode(response.body)['data'].length != 0) {
      var decoded = json.decode(response.body)['data'][0]['attend'];

      this.absent = [];
      this.present = [];

      for (var i = 0; i < this.student.length; i++) {
        String check = decoded.singleWhere(
            (element) => element == this.student[i]['userid'],
            orElse: () => null);

        if (check == null) {
          if (this.absent == null)
            this.absent = [this.student[i]['userid']];
          else
            this.absent.add(this.student[i]['userid']);
        } else {
          if (this.present == null)
            this.present = [this.student[i]['userid']];
          else
            this.present.add(this.student[i]['userid']);
        }
      }
      return true;
    }
    return false;
  }

  List<Widget> listBuilder2(BuildContext context) {
    List<Widget> wid = [];

    for (int i = 0; i < this.student.length; i++) {
      if (this.student[i]['batch'].compareTo(this.batchId) != 0) continue;

      String check = this.absent.singleWhere(
          (element) => element == this.student[i]['userid'],
          orElse: () => null);

      wid.add(Card(
        child: ListTile(
          leading: Icon(Icons.account_circle_rounded, color: Colors.black),
          title: Text(this.student[i]['userid']),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          hoverColor: (check != null) ? Colors.redAccent : Colors.green,
          tileColor: (check != null) ? Colors.redAccent : Colors.green,
          onTap: () {
            (this.level == "teacher")
                ? toggle(this.student[i]['userid'])
                : () {};
          },
        ),
      ));
    }

    return wid;
  }

  save(BuildContext context) async {
    final jsonEncoder = JsonEncoder();
    var url = Uri.https(dotenv.env['SERVER'], "/savesheet");
    var body = {
      'course': this.dropsState,
      'teacher': this.userId,
      'date': "${this.selectedDate.toLocal()}".split(' ')[0],
      'batch': this.batchId,
      'attend': jsonEncoder.convert(this.present)
    };

    var response = await http.post(url, body: body);

    print(response.body);

    Navigator.pushNamedAndRemoveUntil(context, "Home", (r) => false);
    notifyListeners();
  }

  modify(BuildContext context) async {
    final jsonEncoder = JsonEncoder();
    var url = Uri.https(dotenv.env['SERVER'], "/modifysheet");
    var body = {
      'course': dropsState,
      'teacher': userId,
      'date': "${selectedDate.toLocal()}".split(' ')[0],
      'batch': batchId,
      'attend': jsonEncoder.convert(present)
    };

    var response = await http.post(url, body: body);

    print(response.body);

    Navigator.pushNamedAndRemoveUntil(context, "Home", (r) => false);
    notifyListeners();
  }
}
