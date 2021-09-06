import 'package:AttenBuddy/store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AHome extends StatelessWidget {
  final TextEditingController c1 = TextEditingController();
  final TextEditingController c2 = TextEditingController();
  final TextEditingController c3 = TextEditingController();

  final TextEditingController c4 = TextEditingController();
  final TextEditingController c5 = TextEditingController();

  final TextEditingController c6 = TextEditingController();
  final TextEditingController c7 = TextEditingController();
  final TextEditingController c8 = TextEditingController();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final TextEditingController text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;

        return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text("AttenBuddy"),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.lightbulb),
                    tooltip: 'Change Theme',
                    onPressed: () {
                      store.toggleTheme(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Change Theme',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "Account", (r) => false);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    tooltip: 'Change Theme',
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(text: "Course"),
                    Tab(text: "Teacher"),
                    Tab(text: "Student"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ListView(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Name',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: store.theme == 'dark'
                                              ? Colors.white
                                              : Colors.black),
                                    )
                                  ],
                                )),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                controller: c1,
                                onChanged: (text) => {store.cName = text},
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
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
                                          color: store.theme == 'dark'
                                              ? Colors.white
                                              : Colors.black),
                                    )
                                  ],
                                )),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                controller: c2,
                                onChanged: (text) => {store.cTeacher = text},
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
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
                                          color: store.theme == 'dark'
                                              ? Colors.white
                                              : Colors.black),
                                    )
                                  ],
                                )),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                              child: TextFormField(
                                controller: c3,
                                onChanged: (text) => {store.cYear = text},
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Container(
                              height: 50.0,
                              margin: EdgeInsets.all(20),
                              child: RaisedButton(
                                onPressed: () async {
                                  await store.addCourse();
                                  store.selectedAIndex = 3;
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "Course", (r) => false);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green,
                                          Colors.greenAccent
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: width * 0.7, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Create",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'UserId',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: store.theme == 'dark'
                                                ? Colors.white
                                                : Colors.black),
                                      )
                                    ],
                                  )),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: c4,
                                  onChanged: (text) => {store.tUserId = text},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
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
                                            color: store.theme == 'dark'
                                                ? Colors.white
                                                : Colors.black),
                                      )
                                    ],
                                  )),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: c5,
                                  onChanged: (text) => {store.tPassword = text},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50.0,
                                margin: EdgeInsets.all(20),
                                child: RaisedButton(
                                  onPressed: () async {
                                    await store.addTeacher();
                                    store.selectedAIndex = 2;
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "Teacher", (r) => false);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.green,
                                            Colors.greenAccent
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: width * 0.7,
                                          minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Create",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'UserId',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: store.theme == 'dark'
                                                ? Colors.white
                                                : Colors.black),
                                      )
                                    ],
                                  )),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: c6,
                                  onChanged: (text) => {store.sUserId = text},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
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
                                            color: store.theme == 'dark'
                                                ? Colors.white
                                                : Colors.black),
                                      )
                                    ],
                                  )),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: c7,
                                  onChanged: (text) => {store.sBatch = text},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
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
                                            color: store.theme == 'dark'
                                                ? Colors.white
                                                : Colors.black),
                                      )
                                    ],
                                  )),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                                child: TextFormField(
                                  controller: c8,
                                  onChanged: (text) => {store.sPassword = text},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50.0,
                                margin: EdgeInsets.all(20),
                                child: RaisedButton(
                                  onPressed: () async {
                                    store.addStudent();
                                    store.selectedAIndex = 1;
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "Student", (r) => false);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.green,
                                            Colors.greenAccent
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: width * 0.7,
                                          minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Create",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'AHome',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: 'Student',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    label: 'Teacher',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.create),
                    label: 'Course',
                  ),
                ],
                currentIndex: store.selectedAIndex,
                onTap: (index) => {store.aNavigate(index, context)},
              ),
            ));
      },
    );
  }
}
