import 'dart:convert';

// Packages
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'package:sas/screens/attendance.dart';
import 'login.dart';
import 'mark_attendance.dart';
import 'edit_attendance.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  bool isLoggedIn = false;
  int courseId = 0;
  Map teacher = {};

  void getLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (teacher.isEmpty) {
      setState(() {
        if (prefs.getString('teacher') != null) {
          teacher = jsonDecode(prefs.getString('teacher').toString()) as Map;
        }
        if (prefs.getInt('course_id') != null) {
          courseId = prefs.getInt('course_id')!;
        }
      });
    }
  }

  void checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } else {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  void createAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAttendance(),
      ),
    );
  }

  void editAttendance() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditAttendance(),
      ),
    );
    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
    }
  }

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkUser();
    getLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Home'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('User Home Page'),
              if (courseId > 0)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Attendance(),
                          ),
                        );
                      },
                      child: const Text('Attendance'),
                    ),
                    ElevatedButton(
                      onPressed: createAttendance,
                      child: const Text('Mark Attendance'),
                    ),
                    ElevatedButton(
                      onPressed: editAttendance,
                      child: const Text('Edit Attendance'),
                    )
                  ],
                )
              else
                const Text('No Course Assigned'),
              ElevatedButton(
                onPressed: logOut,
                child: const Text('Logout'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
