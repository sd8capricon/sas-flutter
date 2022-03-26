import 'package:flutter/material.dart';

import 'package:sas/screens/attendance/mark_attendance.dart';
import 'package:sas/screens/attendance/edit_attendance.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Mark',
            ),
            Tab(
              text: 'Edit',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const CreateAttendance(),
          EditAttendance(
            tabController: _tabController,
          ),
        ],
      ),
    );
  }
}
