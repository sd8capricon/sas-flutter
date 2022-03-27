import 'package:flutter/material.dart';

// Screens
import 'package:sas/screens/user_home.dart';

class HodDrawer extends StatelessWidget {
  const HodDrawer({
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
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Course functions'),
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
    );
  }
}
