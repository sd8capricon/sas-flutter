import 'package:flutter/material.dart';

import 'package:sas/screens/attendance/mark_attendance.dart';
import 'package:sas/screens/attendance/edit_attendance.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Mark',
              ),
              Tab(
                text: 'Edit',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [CreateAttendance(), EditAttendance()],
        ),
      ),
    );
  }
}
