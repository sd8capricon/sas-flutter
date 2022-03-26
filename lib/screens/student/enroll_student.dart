import 'dart:convert';
import 'package:sas/variables.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class EnrollStudent extends StatefulWidget {
  const EnrollStudent({Key? key}) : super(key: key);

  @override
  State<EnrollStudent> createState() => _EnrollStudentState();
}

class _EnrollStudentState extends State<EnrollStudent> {
  final formKey = GlobalKey<FormState>();
  var err = '';
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var rollController = TextEditingController();
  var emailController = TextEditingController();

  void submit() async {
    Map body = {
      'roll_no': rollController.text,
      'f_name': fNameController.text,
      'l_name': lNameController.text,
      'email': emailController.text
    };
    final url = Uri.parse('$host/student/0/');
    final res = await http.post(url, body: body);
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
          content: Text('Student Enrolled'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fNameController.dispose();
    lNameController.dispose();
    rollController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
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
                'Roll Number',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: rollController,
                  keyboardType: TextInputType.number,
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
              child: const Text('Enroll'),
            ),
          ),
          Text(
            err,
            style: const TextStyle(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
