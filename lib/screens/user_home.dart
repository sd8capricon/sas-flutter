import 'dart:convert';
import 'package:flutter/material.dart';

// Pub Packages
import 'package:shared_preferences/shared_preferences.dart';

// Components
import 'package:sas/components/HodCourseDrawer.dart';

// Screens
import 'login.dart';
import 'package:sas/screens/attendance.dart';

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
    if (prefs.get('teacher') != null) {
      setState(() {
        teacher = jsonDecode(prefs.get('teacher').toString());
      });
    }
    if (prefs.getInt('course_id') != null) {
      setState(() {
        courseId = prefs.getInt('course_id')!;
      });
    }
  }

  void checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // TODO: verify token here
    if (token == null) {
      logOut();
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

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('teacher');
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
      drawer: teacher['type'] == 'hod' ? const HodCourseDrawer() : null,
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
