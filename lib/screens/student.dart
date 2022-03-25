import 'package:flutter/material.dart';

// Screens
import 'package:sas/screens/student/all_students.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'All Students',
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
        body: const TabBarView(
          children: [
            AllStudents(),
            Text('data'),
            Text('data'),
          ],
        ),
      ),
    );
  }
}
