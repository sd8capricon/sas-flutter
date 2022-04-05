import 'dart:convert';
import 'dart:math' as math;
import 'package:sas/variables.dart';
import 'package:flutter/material.dart';

// pub packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  bool isLoading = true;
  var avgAtt = 0.0;
  var barData = [BarAttendance('course', 0, Colors.red)];
  var donutData = [
    DonutAttendance('present', 0, Colors.green),
    DonutAttendance('absent', 0, Colors.red),
  ];

  void getData() async {
    final url = Uri.parse('$host/all-course-stats');
    final res = await http.get(url);
    var body = jsonDecode(res.body);
    if (mounted) {
      setState(() {
        barData = [];
        donutData = [];
        for (var course in body) {
          barData.add(BarAttendance(
              course['course_name'],
              double.parse(course['avg_course_attendance']),
              Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0)));
          avgAtt += double.parse(course['avg_course_attendance']);
        }
        avgAtt = double.parse((avgAtt / barData.length).toStringAsFixed(2));
        donutData.add(DonutAttendance('present', avgAtt, Colors.lightGreen));
        donutData
            .add(DonutAttendance('absent', 100 - avgAtt, Colors.redAccent));
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var barSeries = [
      charts.Series(
        domainFn: (BarAttendance la, _) => la.course, // x-axis
        measureFn: (BarAttendance la, _) => la.attendance,
        colorFn: (BarAttendance la, _) => la.color,
        data: barData,
        id: 'Attendance',
      ),
    ];

    var donutSerires = [
      charts.Series(
        domainFn: (DonutAttendance pa, _) => pa.type,
        measureFn: (DonutAttendance pa, _) => pa.att,
        colorFn: (DonutAttendance pa, _) => pa.color,
        labelAccessorFn: (DonutAttendance pa, _) => '${pa.type}\n${pa.att}',
        data: donutData,
        id: 'Attendance2',
      ),
    ];

    var barChart = charts.BarChart(
      barSeries,
      animate: true,
    );

    var donutChart = charts.PieChart<String>(
      donutSerires,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(),
        ],
      ),
    );

    var barChartWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 350,
        height: 200,
        child: barChart,
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
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Home'),
        ),
        drawer: const HodDrawer(),
        body: SpinKitDualRing(
          color: Colors.blue,
          size: spinnerSize,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOD Home"),
      ),
      drawer: const HodDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8.0),
        child: Column(
          children: [
            const Text(
              'Average Course Attendance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            barChartWidget,
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '% Students attending lecs',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            donutChartWidget,
          ],
        ),
      ),
    );
  }
}

class BarAttendance {
  final String course;
  final double attendance;
  final charts.Color color;

  BarAttendance(this.course, this.attendance, Color color)
      : color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class DonutAttendance {
  final String type;
  final double att;
  final charts.Color color;

  DonutAttendance(this.type, this.att, Color color)
      : color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
