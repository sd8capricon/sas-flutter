import 'dart:convert';
import 'package:flutter/material.dart';

// Pub Packages
import 'package:shared_preferences/shared_preferences.dart';

// Components
import 'package:sas/components/HodCourseDrawer.dart';

// Screens
import 'login.dart';
import 'package:sas/screens/attendance.dart';
import 'package:sas/screens/profile.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  bool isLoggedIn = false;
  int _selectedIndex = 0;
  static int courseId = 0;
  static Map teacher = {};
  var pages = [
    const HomePage(teacher: {}, courseId: 0),
    Profile(teacher: teacher),
  ];

  void getLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('teacher') != null) {
      setState(() {
        teacher = jsonDecode(prefs.get('teacher').toString());
        pages[1] = Profile(teacher: teacher);
        courseId = prefs.getInt('course_id') ?? 0;
        if (courseId != 0) {
          pages[0] = HomePage(teacher: teacher, courseId: courseId);
          bool type = teacher['type'] == 'hod';
          pages.insert(1, Attendance(type: type));
        }
      });
    }
  }

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
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

  @override
  void initState() {
    super.initState();
    checkUser();
    getLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          if (courseId > 0)
            const BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Attendance',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: pages[_selectedIndex],
    );
  }
}

class HomePage extends StatefulWidget {
  final Map teacher;
  final int courseId;
  const HomePage({Key? key, required this.teacher, required this.courseId})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Home'),
      ),
      drawer: widget.teacher['type'] == 'hod' ? const HodCourseDrawer() : null,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('User Home Page'),
              if (widget.courseId == 0)
                const Text('No Course Assigned')
              else
                Text(widget.courseId.toString()),
              // ElevatedButton(
              //   onPressed: logOut,
              //   child: const Text('Logout'),
              // )
            ],
          ),
        ],
      ),
    );
  }
}
