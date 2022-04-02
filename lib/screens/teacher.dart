import 'package:flutter/material.dart';

// components
import 'package:sas/components/HodHomeDrawer.dart';

// Screens
import 'package:sas/screens/teacher/all_teachers.dart';
import 'package:sas/screens/teacher/enroll_teacher.dart';
import 'package:sas/screens/teacher/edit_teacher.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Teacher'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'All Teachers',
              ),
              Tab(
                text: 'Enroll',
              ),
              Tab(
                text: 'Update',
              ),
            ],
          ),
        ),
        drawer: const HodDrawer(),
        body: const TabBarView(
          children: [
            AllTeachers(),
            EnrollTeacher(),
            EditTeacher(),
          ],
        ),
      ),
    );
    ;
  }
}
