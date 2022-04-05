import 'dart:convert';

import 'package:sas/variables.dart';
import 'package:flutter/material.dart';

// Pub Packages
import 'package:http/http.dart' as http;

// Components
import 'package:sas/components/Loader.dart';

class EditCourse extends StatefulWidget {
  const EditCourse({Key? key}) : super(key: key);

  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  bool isLoading = true;
  final formKey = GlobalKey<FormState>();
  String err = '';
  int currCourse = 0;
  int currTaughtBy = 0;
  List teachers = [
    {'f_name': null, 'teacher_id': 0}
  ];
  List courses = [
    {'course_name': 'Select Course', 'course_id': 0}
  ];
  List students = [];
  List toEnroll = [];
  bool? selectAll = false;
  TextEditingController cNameController = TextEditingController();

  int binarySearch(List arr, int val, String key) {
    int min = 0;
    int max = arr.length;
    while (max > min) {
      int mid = ((max + min) / 2).floor();
      if (arr[mid][key] == val) {
        return mid;
      } else if (val > arr[mid][key]) {
        min = mid++;
      } else if (val < arr[mid][key]) {
        max = mid--;
      }
    }
    return -1;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudents();
  }

  void dropDownCallBackCourse(var value) async {
    setState(() {
      isLoading = true;
      currCourse = value!;
      for (var student in students) {
        student['isEnrolled'] = false;
      }
      teachers = [
        {'f_name': null, 'teacher_id': 0}
      ];
      currTaughtBy = 0;
      update();
    });
  }

  void dropDownCallbackTeacher(var value) async {
    setState(() {
      currTaughtBy = value!;
    });
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
      getCourses();
    }
  }

  void getCourses() async {
    final url = Uri.parse('$host/courses');
    final res = await http.get(url);
    var data = jsonDecode(res.body);
    switch (res.statusCode) {
      case 400:
        setState(() {
          err = data['error'];
        });
        break;
      case 200:
        setState(() {
          courses = data;
          currCourse = data[0]['course_id'];
        });
        update();
        break;
      default:
    }
  }

  void update() async {
    int index = binarySearch(courses, currCourse, 'course_id');
    var temp = courses[index];
    await getTeachers(temp['course_name']);
    final url = Uri.parse('$host/course/$currCourse');
    final res = await http.get(url);
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
          cNameController.text = temp['course_name'];
          currTaughtBy = temp['taught_by']['teacher_id'];
          for (var student in data['enrolled_students']) {
            int index = binarySearch(students, student['roll_no'], 'roll_no');
            students[index]['isEnrolled'] = true;
          }
        });
        break;
      default:
    }
    setState(() {
      isLoading = false;
    });
  }

  Future getTeachers(String name) async {
    final url = Uri.parse('$host/teachers');
    final res = await http.get(url);
    var data = jsonDecode(res.body);
    if (mounted) {
      setState(() {
        for (var teacher in data) {
          if (teacher['course_taught'] == null ||
              teacher['course_taught'] == name) {
            teachers.add(teacher);
          }
        }
      });
    }
  }

  void submit() async {
    for (var student in students) {
      if (student['isEnrolled'] == true) toEnroll.add(student['roll_no']);
    }
    Map course = {
      'course_name': cNameController.text,
      'enrolled_students': toEnroll,
    };
    if (currTaughtBy != 0) {
      course['taught_by'] = currTaughtBy;
    }
    final url = Uri.parse('$host/course/$currCourse/');
    final res = await http.patch(url,
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
          content: Text('Course Updated'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
    }
  }

  void remove() async {
    final url = Uri.parse('$host/course/$currCourse/');
    final res = await http.delete(url);
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
          content: Text('Course Removed'),
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
                'Select Course: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                value: currCourse,
                items: courses
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e['course_name'].toString()),
                        value: e['course_id'],
                      ),
                    )
                    .toList(),
                onChanged: dropDownCallBackCourse,
              ),
            ],
          ),
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
                onChanged: dropDownCallbackTeacher,
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: remove,
                child: const Text('Remove'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
