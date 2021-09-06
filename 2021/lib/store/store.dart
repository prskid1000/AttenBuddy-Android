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
  int selectedAIndex = 0;

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
  List<dynamic> teacher;
  List<String> list = ['none'];

  String cName = "";
  String cTeacher = "";
  String cYear = "";

  String tUserId = "";
  String tPassword = "";

  String sUserId = "";
  String sBatch = "";
  String sPassword = "";

  Future addCourse() async {
    var url = Uri.https(dotenv.env['SERVER'], "/add_course");
    var response = await http.post(url, body: {
      'course': this.cName,
      'teacher': this.cTeacher,
      'year': this.cYear
    });
    print(response.body);
    await this.globSync();
    return true;
  }

  Future addTeacher() async {
    var url = Uri.https(dotenv.env['SERVER'], "/add_teacher");
    var response = await http.post(url, body: {
      'userid': this.tUserId,
      'password': this.tPassword,
    });
    await this.globSync();
    return true;
    ;
  }

  Future addStudent() async {
    var url = Uri.https(dotenv.env['SERVER'], "/add_student");
    var response = await http.post(url, body: {
      'userid': this.sUserId,
      'password': this.sPassword,
      'batch': this.sBatch
    });
    await this.globSync();
    return true;
  }

  Future deleteCourse(String crs, String tch, String yrs) async {
    var url = Uri.https(dotenv.env['SERVER'], "/delete_course");
    var response = await http
        .post(url, body: {'course': crs, 'teacher': tch, 'year': yrs});
    var decoded = json.decode(response.body);
    await this.globSync();
    return true;
  }

  Future deleteTeacher(String user, String pass) async {
    var url = Uri.https(dotenv.env['SERVER'], "/delete_teacher");
    var response =
        await http.post(url, body: {'userid': user, 'password': pass});
    var decoded = json.decode(response.body);
    await this.globSync();
    return true;
  }

  Future deleteStudent(String user, String pass) async {
    var url = Uri.https(dotenv.env['SERVER'], "/delete_student");
    var response =
        await http.post(url, body: {'userid': user, 'password': pass});
    var decoded = json.decode(response.body);
    await this.globSync();
    return true;
  }

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
        Navigator.pushNamedAndRemoveUntil(context, "Home", (r) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, "Account", (r) => false);
        break;
      case 2:
        SystemNavigator.pop();
        break;
    }
    this.selectedIndex = data;
    notifyListeners();
  }

  void aNavigate(int data, BuildContext context) async {
    switch (data) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, "AHome", (r) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, "Student", (r) => false);
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(context, "Teacher", (r) => false);
        break;
      case 3:
        Navigator.pushNamedAndRemoveUntil(context, "Course", (r) => false);
        break;
    }
    this.selectedAIndex = data;
    notifyListeners();
  }

  Future globSync() async {
    var url = Uri.https(dotenv.env['SERVER'], "/getcourse");
    var response = await http.get(url);
    var decoded = json.decode(response.body);

    this.list = ['none'];
    this.courses = [];
    for (var i = 0; i < decoded['data'].length; i++) {
      if (decoded['data'].elementAt(i)['teacher'].compareTo(this.userId) == 0) {
        if (this.list == null) {
          this.list = [decoded['data'].elementAt(i)['name']];
        } else {
          this.list.add(decoded['data'].elementAt(i)['name']);
        }
      }
      if (this.courses == null) {
        this.courses = [decoded['data'].elementAt(i)];
      } else {
        this.courses.add(decoded['data'].elementAt(i));
      }
    }

    print(this.courses);

    url = Uri.https(dotenv.env['SERVER'], "/getteacher");
    response = await http.get(url);
    decoded = json.decode(response.body);

    this.teacher = [];
    for (var i = 0; i < decoded['data'].length; i++) {
      if (this.teacher == null) {
        this.teacher = [decoded['data'].elementAt(i)];
      } else {
        this.teacher.add(decoded['data'].elementAt(i));
      }
    }

    url = Uri.https(dotenv.env['SERVER'], "/getstudent");
    response = await http.get(url);
    decoded = json.decode(response.body);

    this.student = [];
    this.absent = [];
    this.present = [];
    for (var i = 0; i < decoded['data'].length; i++) {
      if (this.student == null) {
        this.student = [decoded['data'].elementAt(i)];
        this.absent = [decoded['data'].elementAt(i)['userid']];
      } else {
        this.student.add(decoded['data'].elementAt(i));
        this.absent.add(decoded['data'].elementAt(i)['userid']);
      }
    }

    notifyListeners();
  }

  Future setAuth() async {
    var url = Uri.https(dotenv.env['SERVER'], "/isauth");
    var response =
        await http.post(url, body: {'userid': userId, 'password': password});

    var decoded = json.decode(response.body);

    print(response.body);

    if (decoded['success'].toString().compareTo("True") == 0) {
      this.level = decoded['data']['level'];
      this.globSync();
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

  List<Widget> listBuilder3(BuildContext context) {
    List<Widget> wid = [];
    if (this.student == null) return [];
    for (int i = 0; i < this.student.length; i++) {
      wid.add(Card(
          child: Column(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    'UserId',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    this.student[i]['userid'],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    'Password',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    this.student[i]['password'],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    'Batch',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    this.student[i]['batch'],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed: () {
                      this.deleteStudent(this.student[i]['userid'],
                          this.student[i]['password']);
                    },
                  ),
                ],
              )),
        ],
      )));
    }

    return wid;
  }

  List<Widget> listBuilder4(BuildContext context) {
    List<Widget> wid = [];
    if (this.teacher == null) return [];
    for (int i = 0; i < this.teacher.length; i++) {
      wid.add(Card(
          child: Column(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    'UserId',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    this.teacher[i]['userid'],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    'Password',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    this.teacher[i]['password'],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed: () {
                      this.deleteTeacher(this.teacher[i]['userid'],
                          this.teacher[i]['password']);
                    },
                  ),
                ],
              )),
        ],
      )));
    }

    return wid;
  }

  List<Widget> listBuilder5(BuildContext context) {
    List<Widget> wid = [];
    if (this.courses == null) return [];
    for (int i = 0; i < this.courses.length; i++) {
      wid.add(Card(
          child: Column(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    'Name',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    this.courses[i]['name'],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    'Teacher',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    this.courses[i]['teacher'],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    'Year',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Row(
                children: [
                  Text(
                    this.courses[i]['year'],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            this.theme == 'dark' ? Colors.white : Colors.black),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed: () {
                      this.deleteCourse(this.courses[i]['name'],
                          this.courses[i]['teacher'], this.courses[i]['year']);
                    },
                  ),
                ],
              )),
        ],
      )));
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
