import 'dart:convert';
import 'package:sas/variables.dart';
import 'package:flutter/material.dart';

// Pub packages
import 'package:http/http.dart' as http;

// Components
import 'package:sas/components/Loader.dart';

class EnrollCourse extends StatefulWidget {
  const EnrollCourse({Key? key}) : super(key: key);

  @override
  State<EnrollCourse> createState() => _EnrollCourseState();
}

class _EnrollCourseState extends State<EnrollCourse> {
  bool isLoading = true;
  final formKey = GlobalKey<FormState>();
  String err = '';
  int currTaughtBy = 0;
  List teachers = [
    {'f_name': null, 'teacher_id': 0}
  ];
  List students = [];
  List toEnroll = [];
  bool? selectAll = false;
  TextEditingController cNameController = TextEditingController();

  void dropDownCallback(var value) async {
    setState(() {
      currTaughtBy = value!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudents();
  }

  void getStudents() async {
    final url = Uri.parse('$host/students');
    final res = await http.get(url);
    if (mounted) {
      setState(() {
        students = jsonDecode(res.body);
        for (var student in students) {
          student['isEnrolled'] = false;
        }
      });
      getTeachers();
    }
  }

  void getTeachers() async {
    final url = Uri.parse('$host/teachers');
    final res = await http.get(url);
    var data = jsonDecode(res.body);
    if (mounted) {
      setState(() {
        for (var teacher in data) {
          if (teacher['course_taught'] == null) {
            teachers.add(teacher);
          }
        }
        currTaughtBy = teachers[0]['teacher_id'];
        isLoading = false;
      });
    }
  }

  void submit() async {
    for (var student in students) {
      if (student['isEnrolled'] == true) toEnroll.add(student['roll_no']);
    }
    Map course = {
      'course_name': cNameController.text,
      'enrolled_students': toEnroll
    };
    if (currTaughtBy != 0) {
      course['taught_by'] = currTaughtBy;
    }
    final url = Uri.parse('$host/course/0/');
    final res = await http.post(url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(course));
    var data = jsonDecode(res.body);
    switch (res.statusCode) {
      case 400:
        setState(() {
          err = data['error'];
        });
        break;
      case 200:
        setState(() {
          err = '';
        });
        const snackBar = SnackBar(
          content: Text('Course Enrolled'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loader;
    }
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Course Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: cNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                width: 150,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Assign Teacher: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                value: currTaughtBy,
                items: teachers
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e['f_name'].toString() +
                            ' ' +
                            e['l_name'].toString()),
                        value: e['teacher_id'],
                      ),
                    )
                    .toList(),
                onChanged: dropDownCallback,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Select All:'),
              Checkbox(
                  value: selectAll,
                  onChanged: (bool? value) {
                    setState(() {
                      selectAll = value;
                      for (var student in students) {
                        student['isEnrolled'] = value;
                      }
                    });
                  }),
            ],
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: students.length,
            itemBuilder: (context, item) {
              return CheckboxListTile(
                title: Text(students[item]['roll_no'].toString() +
                    " " +
                    students[item]['f_name'] +
                    " " +
                    students[item]['l_name']),
                value: students[item]['isEnrolled'],
                onChanged: (val) {
                  setState(() {
                    students[item]['isEnrolled'] = val!;
                  });
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  submit();
                }
              },
              child: const Text('Enroll'),
            ),
          ),
          Text(
            err,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
