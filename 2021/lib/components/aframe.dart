import 'package:AttenBuddy/store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AFrame extends StatelessWidget {
  final List<Widget> childComponent;
  AFrame(this.childComponent);

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        //double width = MediaQuery.of(context).size.width;
        //double height = MediaQuery.of(context).size.height;

        return Scaffold(
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
          ),
          body: ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: Column(children: childComponent))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
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
        );
      },
    );
  }
}
