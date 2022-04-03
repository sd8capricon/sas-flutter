import 'dart:convert';
import 'package:sas/screens/hod_home.dart';
import 'package:sas/variables.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sas/screens/user_home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var loginErr = '';
  Map teacher = {};

  void getLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    if (localStorage.get('teacher') != null) {
      teacher = jsonDecode(localStorage.get('teacher').toString()) as Map;
    }
    if (localStorage.get('token') != null) {
      // TODO: verify token here
    }
    if (teacher['type'] == 'hod') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HodHome(),
        ),
      );
    }
    if (teacher['type'] == 'teacher') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const UserHome(),
        ),
      );
    }
  }

  void login() async {
    final prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('$host/login/');
    var res = await http.post(url, body: {
      "username": usernameController.text,
      "password": passwordController.text
    });
    var body = jsonDecode(res.body) as Map;
    if (body.containsKey('error')) {
      setState(() {
        loginErr = 'Incorrect Username or Password';
      });
    } else {
      var data = body['teacher'];
      var token = body['token'];
      var courseId = body['teacher']['course_id'];
      prefs.setString('token', token);
      prefs.setString('teacher', jsonEncode(data));
      prefs.remove('course_id');
      if (courseId != null) await prefs.setInt('course_id', courseId);
      if (data['type'] == 'teacher') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const UserHome(),
          ),
        );
      }
      if (data['type'] == 'hod') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HodHome(),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalStorage();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 39, top: 133),
              child: const Text(
                'Welcome\nLOG IN',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Your Username',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: ' Your Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xff4c505b),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: login,
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      loginErr,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Old Login
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Login'),
  //     ),
  //     body: Container(
  //       child: Form(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               child: const Text('Login'),
  //               margin: const EdgeInsets.only(bottom: 30),
  //             ),
  //             TextFormField(
  //               controller: usernameController,
  //               decoration: const InputDecoration(
  //                 hintText: 'Enter username',
  //               ),
  //             ),
  //             TextFormField(
  //               controller: passwordController,
  //               decoration: const InputDecoration(
  //                 hintText: 'Password',
  //               ),
  //               obscureText: true,
  //               autocorrect: false,
  //               enableSuggestions: false,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(20),
  //               child: ElevatedButton(
  //                 onPressed: login,
  //                 child: const Text('Login'),
  //               ),
  //             ),
  //             Text(
  //               loginErr,
  //               style: const TextStyle(
  //                 color: Colors.red,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       padding: const EdgeInsets.symmetric(horizontal: 50),
  //     ),
  //   );
  // }
}
