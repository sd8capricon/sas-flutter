import 'dart:convert';
import 'dart:math' as math;
import 'package:sas/variables.dart';
import 'package:flutter/material.dart';

// pub packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

// Components
import 'package:sas/components/HodHomeDrawer.dart';

// Screens
import 'login.dart';
import 'package:sas/screens/student.dart';
import 'package:sas/screens/course.dart';
import 'package:sas/screens/teacher.dart';
import 'package:sas/screens/defaulterList.dart';

class HodHome extends StatefulWidget {
  const HodHome({Key? key}) : super(key: key);

  @override
  State<HodHome> createState() => _HodHomeState();
}

class _HodHomeState extends State<HodHome> {
  bool isLoggedIn = false;
  int _selectedIndex = 0;

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
    if (token == null) {
      logOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } else {
      // ??
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.boy),
            label: 'Student',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Teacher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dangerous),
            label: 'Defaulters',
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

  final pages = [
    const HomePage(),
    const Student(),
    const Teacher(),
    const Course(),
    const DefaulterList()
  ];
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var data = [LinearAttendance('course', 0, Colors.red)];

  void getData() async {
    final url = Uri.parse('$host/all-course-stats');
    final res = await http.get(url);
    var body = jsonDecode(res.body);
    setState(() {
      data = [];
      for (var course in body) {
        data.add(LinearAttendance(
            course['course_name'],
            double.parse(course['avg_course_attendance']),
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0)));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series(
        domainFn: (LinearAttendance la, _) => la.lecs,
        measureFn: (LinearAttendance la, _) => la.attendance,
        colorFn: (LinearAttendance la, _) => la.color,
        data: data,
        id: 'Attendance', // x-axis
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
    );

    var chartWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 350,
        height: 200,
        child: chart,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("HOD Home"),
      ),
      drawer: const HodDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  'Average Course Attendance',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                chartWidget,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LinearAttendance {
  final String lecs;
  final double attendance;
  final charts.Color color;

  LinearAttendance(this.lecs, this.attendance, Color color)
      : color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
