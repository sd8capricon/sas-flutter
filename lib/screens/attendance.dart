import 'package:flutter/material.dart';

import 'mark_attendance.dart';
import 'edit_attendance.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Mark',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Text('Hello World'),
          ],
        ),
      ),
    );
  }
}
