import 'dart:convert';
import 'package:sas/variables.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// Components
import 'package:sas/components/Loader.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({Key? key}) : super(key: key);

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  bool isLoading = true;
  final formKey = GlobalKey<FormState>();
  int currRoll = 1;
  List students = [];
  var err = '';
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var emailController = TextEditingController();

  int binarySearch(List arr, int val) {
    int min = 0;
    int max = arr.length;
    while (max > min) {
      int mid = ((max + min) / 2).floor();
      if (arr[mid]['roll_no'] == val) {
        return mid;
      } else if (val > arr[mid]['roll_no']) {
        min = mid++;
      } else if (val < arr[mid]['roll_no']) {
        max = mid--;
      }
    }
    return -1;
  }

  void setControllers(index) {
    fNameController.text = students[index]['f_name'].toString();
    lNameController.text = students[index]['l_name'].toString();
    emailController.text = students[index]['email'].toString();
  }

  void dropDownCallback(var value) async {
    setState(() {
      currRoll = value!;
      int index = binarySearch(students, currRoll);
      setControllers(index);
    });
  }

  void getStudents() async {
    final url = Uri.parse('$host/students');
    final res = await http.get(url);
    if (mounted) {
      setState(() {
        students = jsonDecode(res.body);
        currRoll = students[0]['roll_no'];
        setControllers(0);
        isLoading = false;
      });
    }
  }

  void submit() async {
    Map body = {
      'f_name': fNameController.text,
      'l_name': lNameController.text,
      'email': emailController.text
    };
    final url = Uri.parse('$host/student/$currRoll/');
    final res = await http.patch(url, body: body);
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
          content: Text('Student Updated'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
    }
  }

  void remove() async {
    final url = Uri.parse('$host/student/$currRoll/');
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
          content: Text('Student Removed'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudents();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select Roll Number: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                value: currRoll,
                items: students
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e['roll_no'].toString()),
                        value: e['roll_no'],
                      ),
                    )
                    .toList(),
                onChanged: dropDownCallback,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'First Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: fNameController,
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
                'Last Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: lNameController,
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
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: emailController,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  submit();
                }
              },
              child: const Text('Update'),
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
