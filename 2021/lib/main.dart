import 'package:AttenBuddy/layouts/account.dart';
import 'package:AttenBuddy/layouts/ahome.dart';
import 'package:AttenBuddy/layouts/attendance.dart';
import 'package:AttenBuddy/layouts/attendanceView.dart';
import 'package:AttenBuddy/layouts/course.dart';
import 'package:AttenBuddy/layouts/home.dart';
import 'package:AttenBuddy/layouts/student.dart';
import 'package:AttenBuddy/layouts/teacher.dart';
import 'package:AttenBuddy/store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => Store(),
      child: Consumer<Store>(builder: (context, store, child) {
        return MaterialApp(
          theme: store.theme.compareTo('dark') == 0
              ? ThemeData.dark().copyWith(
                  primaryColor: Colors.black,
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    selectedItemColor: Colors.green,
                    unselectedItemColor: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  primaryColor: Colors.white,
                  appBarTheme: AppBarTheme(backgroundColor: Colors.green),
                  snackBarTheme:
                      SnackBarThemeData(backgroundColor: Colors.green),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    selectedItemColor: Colors.green,
                    unselectedItemColor: Colors.black,
                  ),
                ),
          initialRoute: 'Account',
          routes: {
            'Account': (context) => Account(),
            'Student': (context) => Student(),
            'Teacher': (context) => Teacher(),
            'Course': (context) => Course(),
            'Home': (context) => Home(),
            'AHome': (context) => AHome(),
            'Attendance': (context) => Attendance(),
            'AttendanceView': (context) => AttendanceView()
          },
          debugShowCheckedModeBanner: false,
        );
      }),
    ),
  );
}
