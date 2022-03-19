import 'dart:convert';
import 'package:flutter/material.dart';
import 'login.dart';
import 'mark_attendance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoggedIn = false;
  int courseId = 0;
  Map teacher = {};

  void getLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (teacher.isEmpty) {
      setState(() {
        teacher = jsonDecode(prefs.getString('teacher').toString()) as Map;
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
        backgroundColor: Colors.red,
        title: const Text('Home'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Home Page'),
              if (courseId > 0)
                ElevatedButton(
                  onPressed: createAttendance,
                  child: const Text('Mark Attendance'),
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
