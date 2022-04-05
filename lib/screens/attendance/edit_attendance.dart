import 'dart:convert';
import 'package:sas/variables.dart';

// Packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Components
import 'package:sas/components/Loader.dart';

// Screens
// import 'home.dart';

class EditAttendance extends StatefulWidget {
  final TabController tabController;
  const EditAttendance({Key? key, required this.tabController})
      : super(key: key);

  @override
  State<EditAttendance> createState() => _EditAttendanceState();
}

class _EditAttendanceState extends State<EditAttendance> {
  bool isLoading = true;
  int courseId = 0;
  int currLec = 1;
  String message = '';
  List lecs = [];
  List menuItems = [];
  List studentList = [];
  List changeStudents = [];

  void dropDownCallback(var value) async {
    setState(() {
      currLec = value!;
    });
    getAttendance();
  }

  void getStats() async {
    final DateFormat formatter = DateFormat('dd-MM-yy');
    final localStorage = await SharedPreferences.getInstance();
    int idTemp = 0;
    if (localStorage.getInt('course_id') != null) {
      idTemp = localStorage.getInt('course_id')!;
    }
    final url = Uri.parse('$host/course-lec-stats/$idTemp');
    final res = await http.get(url);
    switch (res.statusCode) {
      case 400:
        print('something went wrong');
        break;
      default:
    }
    final body = jsonDecode(res.body);
    if (body['num_lecs'] == null) {
      return;
    }
    final lecData = body['lec_stats'];
    if (mounted) {
      setState(() {
        courseId = idTemp;
        for (var lec in lecData) {
          var tempDate = DateTime.tryParse(lec['date']);
          var data = {
            'lec_no': lec['lec_no'],
            'date': formatter.format(tempDate!)
          };
          lecs.add(data);
        }
        currLec = lecs[0]['lec_no'];
      });
    }
    getAttendance();
  }

  void getAttendance() async {
    final url = Uri.parse('$host/attendance/$courseId/$currLec/');
    final res = await http.get(url);
    final students = jsonDecode(res.body);
    if (mounted) {
      setState(() {
        studentList = students['attendance'];
        isLoading = false;
      });
    }
  }

  void mark() async {
    List updateData = [];
    for (var item in changeStudents) {
      var data = {
        'student_status': item['student_status'],
        'student': item['student']['roll_no']
      };
      updateData.add(data);
    }
    try {
      final url = Uri.parse('$host/attendance/$courseId/$currLec/');
      final res = await http.patch(url,
          headers: {'Content-type': 'application/json'},
          body: jsonEncode(updateData));
      switch (res.statusCode) {
        case 400:
          throw Exception("Status code 400");
      }
      message = 'Successfully Marked Attendance';
    } on Exception catch (e) {
      message = 'Error Marking Attendance';
    }
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    getStats();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loader;
    }
    if (lecs.isEmpty) {
      return AlertDialog(
        title: const Text('No Attendance to Edit !'),
        actions: [
          TextButton(
            onPressed: () {
              widget.tabController.index = 0;
            },
            child: const Text('Go back'),
          ),
        ],
      );
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Select: '),
            DropdownButton(
              value: currLec,
              items: lecs
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(
                          'Lecture No: ${e['lec_no'].toString()} Date: ${e['date']}'),
                      // Text('${e['lec_no'].toString()}'),
                      value: e['lec_no'],
                    ),
                  )
                  .toList(),
              onChanged: dropDownCallback,
            ),
          ],
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: studentList.length,
          itemBuilder: (context, item) {
            return CheckboxListTile(
              title: Text(studentList[item]['student']['roll_no'].toString() +
                  " " +
                  studentList[item]['student']['f_name'] +
                  " " +
                  studentList[item]['student']['l_name']),
              value: !studentList[item]['student_status'],
              onChanged: (val) {
                setState(() {
                  studentList[item]['student_status'] = !val!;
                  if (changeStudents.contains(studentList[item])) {
                    changeStudents.remove(studentList[item]);
                  } else {
                    changeStudents.add(studentList[item]);
                  }
                });
              },
            );
          },
        ),
        ElevatedButton(
          onPressed: mark,
          child: const Text('Mark'),
        ),
      ],
    );
  }
}
