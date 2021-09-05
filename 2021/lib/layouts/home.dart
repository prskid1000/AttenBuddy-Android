import 'package:AttenBuddy/components/frame.dart';
import 'package:AttenBuddy/store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final TextEditingController text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        return Frame(<Widget>[
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(30, 10, 20, 10),
                child: Text(
                  "${store.selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 26),
                ),
              ),
              Container(
                height: 50.0,
                margin: EdgeInsets.all(20),
                child: RaisedButton(
                  onPressed: () => {store.selectDate(context)},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.greenAccent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Date",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                      style: TextStyle(fontSize: 25, color: Colors.green),
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
                          fontSize: 24,
                          color: store.theme.compareTo('dark') == 0
                              ? Colors.white
                              : Colors.black),
                      onChanged: (String newValue) {
                        store.dropsState = newValue;
                        store.notifyListeners();
                      },
                      items: store.list
                          .map<DropdownMenuItem<String>>((String value) {
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
          (store.level == "teacher")
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: RaisedButton(
                          onPressed: () async {
                            store.batchId = text.text;
                            store.take(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.green, Colors.greenAccent],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 200.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Take",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        )),
                  ],
                )
              : Opacity(opacity: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 40,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: RaisedButton(
                    onPressed: () async {
                      store.batchId = text.text;
                      store.view(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.greenAccent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          (store.level == "teacher") ? 'Review' : 'View',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ]);
      },
    );
  }
}
