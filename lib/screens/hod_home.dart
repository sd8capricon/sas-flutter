import 'package:flutter/material.dart';
import 'package:sas/screens/user_home.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'package:sas/screens/student.dart';

class HodHome extends StatefulWidget {
  const HodHome({Key? key}) : super(key: key);

  @override
  State<HodHome> createState() => _HodHomeState();
}

class _HodHomeState extends State<HodHome> {
  bool isLoggedIn = false;

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('teacher');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  void checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } else {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOD Home"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('HOD Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Course'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const UserHome(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Student()),
                  )
                },
                child: const Text('Student'),
              ),
              ElevatedButton(
                onPressed: logOut,
                child: const Text('Logout'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
