import 'package:flutter/material.dart';

// Components
import 'package:sas/components/HodCourseDrawer.dart';

import 'package:sas/screens/attendance/mark_attendance.dart';
import 'package:sas/screens/attendance/edit_attendance.dart';

class Attendance extends StatefulWidget {
  final bool type;
  const Attendance({Key? key, required this.type}) : super(key: key);

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
      drawer: widget.type ? const HodCourseDrawer() : null,
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
