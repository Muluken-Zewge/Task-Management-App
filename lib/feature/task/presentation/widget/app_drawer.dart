import 'package:flutter/material.dart';
import 'package:task_list/feature/task/presentation/screen/completed_task.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/taskdone.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'WELCOME',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              //Navigator.pop(context);
              //Get.to(() => BusListPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_box),
            title: const Text('Completed Tasks'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CompletedTaskPage()));
              //Get.to(() => const AboutUsPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              //Navigator.pop(context);
              //Get.to(() => const AboutUsPage());
            },
          ),
        ],
      ),
    );
  }
}
