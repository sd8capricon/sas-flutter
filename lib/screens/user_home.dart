import 'dart:convert';
import 'package:flutter/material.dart';

// Pub Packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

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
  var lineData = [
    LineAttendance(1, 90),
    LineAttendance(2, 80),
    LineAttendance(3, 20),
    LineAttendance(4, 100),
  ];
  var donutData = [
    DonutAttendance('present', 60, Colors.green),
    DonutAttendance('absent', 40, Colors.red)
  ];

  @override
  Widget build(BuildContext context) {
    var lineSeries = [
      charts.Series(
        domainFn: (LineAttendance la, _) => la.lec, // x-axis
        measureFn: (LineAttendance la, _) => la.att,
        // colorFn: (LineAttendance la, _) => la.color,
        data: lineData,
        id: 'Attendance',
      ),
    ];

    var donutSeries = [
      charts.Series(
        domainFn: (DonutAttendance pa, _) => pa.type,
        measureFn: (DonutAttendance pa, _) => pa.att,
        colorFn: (DonutAttendance pa, _) => pa.color,
        labelAccessorFn: (DonutAttendance pa, _) => '${pa.type}\n${pa.att}',
        data: donutData,
        id: 'Attendance2',
      ),
    ];

    var lineChart = charts.LineChart(
      lineSeries,
      animate: true,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
    );

    var donutChart = charts.PieChart<String>(
      donutSeries,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(),
        ],
      ),
    );

    var lineChartWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300,
        height: 250,
        child: lineChart,
      ),
    );

    var donutChartWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300,
        height: 250,
        child: donutChart,
      ),
    );

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
              lineChartWidget,
              donutChartWidget
            ],
          ),
        ],
      ),
    );
  }
}

class LineAttendance {
  final int lec;
  final double att;

  LineAttendance(this.lec, this.att);
}

class DonutAttendance {
  final String type;
  final double att;
  final charts.Color color;
  DonutAttendance(this.type, this.att, Color color)
      : color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
