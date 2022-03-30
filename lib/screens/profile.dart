import 'package:flutter/material.dart';

// Pub Packages
import 'package:shared_preferences/shared_preferences.dart';

// Components
import 'package:sas/components/HodCourseDrawer.dart';

// Screens
import 'login.dart';

class Profile extends StatefulWidget {
  final Map teacher;
  const Profile({Key? key, required this.teacher}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double boxWidth = 100;

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      drawer: widget.teacher['type'] == 'hod' ? const HodCourseDrawer() : null,
      body: Container(
        padding: const EdgeInsets.only(
          top: 20,
          right: 20,
          bottom: 200,
          left: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // id
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(child: const Text('user Id: '), width: boxWidth),
                SizedBox(
                    child: Text(widget.teacher['teacher_id'].toString()),
                    width: boxWidth),
              ],
            ),
            // Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(child: const Text('Name: '), width: boxWidth),
                SizedBox(
                  child: Text(widget.teacher['f_name'] +
                      " " +
                      widget.teacher['l_name']),
                  width: boxWidth,
                ),
              ],
            ),
            // username
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(child: const Text('username: '), width: boxWidth),
                SizedBox(
                    child: Text(widget.teacher['username']), width: boxWidth),
              ],
            ),
            // User Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(child: const Text('user type: '), width: boxWidth),
                SizedBox(child: Text(widget.teacher['type']), width: boxWidth),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(child: const Text('Course Taught:'), width: boxWidth),
                SizedBox(
                    child: Text(widget.teacher['course_name'].toString()),
                    width: boxWidth),
              ],
            ),
            ElevatedButton(onPressed: logOut, child: Text('Logout'))
          ],
        ),
      ),
    );
  }
}
