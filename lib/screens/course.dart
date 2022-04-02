import 'package:flutter/material.dart';

// Components
import 'package:sas/components/HodHomeDrawer.dart';
import 'package:sas/screens/course/edit_course.dart';
import 'package:sas/screens/course/enroll_course.dart';

class Course extends StatefulWidget {
  const Course({Key? key}) : super(key: key);

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Course'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Enroll',
              ),
              Tab(
                text: 'Update',
              )
            ],
          ),
        ),
        drawer: const HodDrawer(),
        body: const TabBarView(
          children: [
            EnrollCourse(),
            EditCourse(),
          ],
        ),
      ),
    );
  }
}
