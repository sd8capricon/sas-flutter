import 'package:flutter/material.dart';

import 'package:sas/screens/hod_home.dart';

class HodCourseDrawer extends StatelessWidget {
  const HodCourseDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Manage',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          ListTile(
            title: const Text('HOD functions'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HodHome(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Course functions'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
