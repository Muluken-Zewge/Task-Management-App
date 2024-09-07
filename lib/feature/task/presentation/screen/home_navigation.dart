import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_list/feature/quotes/presentation/screen/quotes_screen.dart';
import 'package:task_list/feature/task/presentation/screen/home_page.dart';

import '../../../../core/utils/app_color.dart';

class HomePageNavigator extends StatefulWidget {
  final int? idx;
  const HomePageNavigator({super.key, this.idx = 0});
  @override
  State<HomePageNavigator> createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> {
  int index = 0;
  bool isLoggedIn = false;
  final screens = [
    QuotesScreen(),
    HomePage(),
  ];
  
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    index = widget.idx!;

    // Initialize the plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } 

  @override
  void dispose() {
    // Reset system overlay style when leaving the screen
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ThemeNotifier themeNotifier = Theme.of(context);
    return SafeArea(
        child: PopScope(
      onPopInvoked: (v) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Press back again to exit'),
        ));
      },
      child: SafeArea(
        child: Scaffold(
          // backgroundColor: Theme.of(context).cardColor,
          bottomNavigationBar: Container(
            color: Theme.of(context).cardColor,
            child: ClipRRect(
              child: BottomNavigationBar(
                elevation: 3,
                backgroundColor: Theme.of(context).colorScheme.surface,
                selectedItemColor: AppColor.primary,
                // selectedFontSize: AppFontSize.fs12,
                // unselectedFontSize: AppFontSize.fs12,
                // unselectedLabelStyle:
                //     const TextStyle(fontWeight: AppFontWeight.fw700),
                // selectedLabelStyle:
                //     const TextStyle(fontWeight: AppFontWeight.fw700),
                // unselectedItemColor: AppColor.unSelectedItemColor,
                type: BottomNavigationBarType.fixed,
                currentIndex: index,
                onTap: (index) async {
                  setState(() => this.index = index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.format_quote),
                    label: "Quotes",
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task), label: "Task"),
                ],
              ),
            ),
          ),
          body: screens[index],
        ),
      ),
    ));
  }
}
