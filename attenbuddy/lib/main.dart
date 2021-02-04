import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
        create: (context) => Store(),
        child: MaterialApp(
          theme: ThemeData.dark(),
          initialRoute: 'Account',
          routes: {
            'Account': (context) => Account(),
            'Dash': (context) => Dash(),
            'viewAttendance': (context) => viewAttendance(),
            'Attendance': (context) => Attendance(),
          },
          debugShowCheckedModeBanner: false,
        )),
  );
}

class Store extends ChangeNotifier {
  String userId = "";
  String password = "";
  String level = "Denied";
  String dropsState = "none";
  String batchId = "0";
  DateTime selectedDate = DateTime.now();

  List<String> present;
  List<String> absent;

  List<dynamic> courses;
  List<dynamic> student;
  List<String> list = ['none'];

  Future setAuth(String userId, String password) async {
    this.userId = userId;
    this.password = password;
    var url = 'https://attenbuddy.herokuapp.com/isauth';
    var response =
        await http.post(url, body: {'userid': userId, 'password': password});

    print(response.body);
    var decoded = json.decode(response.body);

    if (decoded['success'].toString().compareTo("True") == 0) {
      this.level = decoded['data']['level'];

      url = 'https://attenbuddy.herokuapp.com/getcourse';
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
      print(decoded);

      url = 'https://attenbuddy.herokuapp.com/getstudent';
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
    await helper();
    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(context, "viewAttendance", (r) => false);
  }

  selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    print(picked);
    if (picked == null) return;
    selectedDate = picked;
    notifyListeners();
  }

  toggle(String s) {
    String check =
        absent.singleWhere((element) => element == s, orElse: () => null);

    if (check == null) {
      if (absent == null) {
        absent = [s];
      } else {
        absent.add(s);
      }
      present.remove(s);
    } else {
      if (present == null) {
        present = [s];
      } else {
        present.add(s);
      }
      absent.remove(s);
    }
    notifyListeners();
  }

  List<Widget> listBuilder(BuildContext context) {
    List<Widget> wid = [];

    for (int i = 0; i < this.student.length; i++) {
      String check = absent.singleWhere(
          (element) => element == this.student[i]['userid'],
          orElse: () => null);

      wid.add(Card(
        child: ListTile(
          leading: Icon(Icons.all_inclusive, color: Colors.black),
          title: Text(this.student[i]['userid']),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          hoverColor: (check != null) ? Colors.redAccent : Colors.greenAccent,
          tileColor: (check != null) ? Colors.redAccent : Colors.greenAccent,
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
    var url = 'https://attenbuddy.herokuapp.com/getsheet';
    var body = {
      'course': dropsState,
      'teacher': userId,
      'date': "${selectedDate.toLocal()}".split(' ')[0],
      'batch': batchId
    };

    var response = await http.post(url, body: body);
    var decoded = json.decode(response.body)['data'][0]['attend'];

    absent = [];
    present = [];

    for (var i = 0; i < student.length; i++) {
      String check = decoded.singleWhere(
          (element) => element == this.student[i]['userid'],
          orElse: () => null);

      if (check == null) {
        if (absent == null)
          absent = [this.student[i]['userid']];
        else
          absent.add(this.student[i]['userid']);
      } else {
        if (present == null)
          present = [this.student[i]['userid']];
        else
          present.add(this.student[i]['userid']);
      }
    }
  }

  List<Widget> listBuilder2(BuildContext context) {
    List<Widget> wid = [];

    for (int i = 0; i < this.student.length; i++) {
      String check = absent.singleWhere(
          (element) => element == this.student[i]['userid'],
          orElse: () => null);

      wid.add(Card(
        child: ListTile(
          leading: Icon(Icons.all_inclusive, color: Colors.black),
          title: Text(this.student[i]['userid']),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          hoverColor: (check != null) ? Colors.redAccent : Colors.greenAccent,
          tileColor: (check != null) ? Colors.redAccent : Colors.greenAccent,
          onTap: () {
            (level == "teacher") ? toggle(this.student[i]['userid']) : () {};
          },
        ),
      ));
    }

    return wid;
  }

  save(BuildContext context) async {
    final jsonEncoder = JsonEncoder();
    var url = 'https://attenbuddy.herokuapp.com/savesheet';
    var body = {
      'course': dropsState,
      'teacher': userId,
      'date': "${selectedDate.toLocal()}".split(' ')[0],
      'batch': batchId,
      'attend': jsonEncoder.convert(present)
    };

    var response = await http.post(url, body: body);

    print(response.body);

    Navigator.pushNamedAndRemoveUntil(context, "Dash", (r) => false);
    notifyListeners();
  }

  modify(BuildContext context) async {
    final jsonEncoder = JsonEncoder();
    var url = 'https://attenbuddy.herokuapp.com/modifysheet';
    var body = {
      'course': dropsState,
      'teacher': userId,
      'date': "${selectedDate.toLocal()}".split(' ')[0],
      'batch': batchId,
      'attend': jsonEncoder.convert(present)
    };

    var response = await http.post(url, body: body);

    print(response.body);

    Navigator.pushNamedAndRemoveUntil(context, "Dash", (r) => false);
    notifyListeners();
  }
}

class Account extends StatelessWidget {
  final TextEditingController text = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController event = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        return Scaffold(
            body: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(22),
                        child: Text(
                          'AttenBuddy',
                          style: TextStyle(fontSize: 44, color: Colors.green),
                        )),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'UserId',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        obscureText: true,
                        controller: password,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            height: 60,
                            width: 385,
                            padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.green,
                              child: Text('Log In'),
                              onPressed: () async {
                                await store.setAuth(text.text, password.text);
                                if (store.level.compareTo("Denied") != 0) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "Dash", (r) => false);
                                }
                              },
                            )),
                      ],
                    ),
                  ],
                )));
      },
    );
  }
}

class Dash extends StatelessWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final TextEditingController text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        return Scaffold(
            body: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(22),
                        child: Text(
                          'Dashboard',
                          style: TextStyle(fontSize: 48, color: Colors.green),
                        )),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(10, 50, 20, 20),
                      child: Text(
                        "${store.selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: RaisedButton(
                        onPressed: () => {store.selectDate(context)},
                        child: Text(
                          'Select date',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        color: Colors.green,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(40, 30, 40, 0),
                      child: TextFormField(
                        controller: text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Batch',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(50, 30, 0, 20),
                              child: Text(
                                'Course',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.greenAccent),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                              child: DropdownButton<String>(
                                value: store.dropsState,
                                elevation: 16,
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                                underline: Container(
                                  height: 2,
                                  color: Colors.greenAccent,
                                ),
                                onChanged: (String newValue) {
                                  store.dropsState = newValue;
                                  store.notifyListeners();
                                },
                                items: store.list.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            height: 60,
                            width: 380,
                            padding: EdgeInsets.fromLTRB(70, 20, 70, 0),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.green,
                              child: Text(
                                (store.level == "teacher") ? 'Review' : 'View',
                                style: TextStyle(fontSize: 22),
                              ),
                              onPressed: () async {
                                store.batchId = text.text;
                                store.view(context);
                              },
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: 380,
                          padding: EdgeInsets.fromLTRB(70, 20, 70, 0),
                          child: Opacity(
                              opacity: (store.level == "teacher") ? 1 : 0,
                              child: RaisedButton(
                                textColor: Colors.white,
                                color: Colors.green,
                                child: Text(
                                  'Take',
                                  style: TextStyle(fontSize: 22),
                                ),
                                onPressed: () async {
                                  store.batchId = text.text;
                                  store.take(context);
                                },
                              )),
                        ),
                      ],
                    ),
                  ],
                )));
      },
    );
  }
}

class Attendance extends StatelessWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(builder: (context, store, child) {
      return Scaffold(
          body: Padding(
        padding: EdgeInsets.fromLTRB(20, 80, 20, 10),
        child: ListView(children: <Widget>[
          Container(
            height: 550,
            padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
            child: ListView(
              children: store.listBuilder(context),
            ),
          ),
          Row(
            children: [
              Container(
                height: 60,
                width: 300,
                padding: EdgeInsets.fromLTRB(70, 20, 10, 5),
                child: Opacity(
                    opacity: (store.level == "teacher") ? 1 : 0,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 22),
                      ),
                      onPressed: () async {
                        store.save(context);
                      },
                    )),
              ),
            ],
          ),
        ]),
      ));
    });
  }
}

class viewAttendance extends StatelessWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(builder: (context, store, child) {
      return Scaffold(
          body: Padding(
        padding: EdgeInsets.fromLTRB(20, 80, 20, 10),
        child: ListView(children: <Widget>[
          Container(
            height: 550,
            padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
            child: ListView(
              children: store.listBuilder2(context),
            ),
          ),
          Row(
            children: [
              Container(
                  height: 60,
                  width: 300,
                  padding: EdgeInsets.fromLTRB(70, 20, 10, 5),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.green,
                    child: Text(
                      (store.level == "teacher") ? 'Modify' : 'Go Back',
                      style: TextStyle(fontSize: 22),
                    ),
                    onPressed: () async {
                      (store.level == "teacher")
                          ? store.modify(context)
                          : Navigator.pushNamedAndRemoveUntil(
                              context, "Dash", (r) => false);
                    },
                  )),
            ],
          ),
        ]),
      ));
    });
  }
}
