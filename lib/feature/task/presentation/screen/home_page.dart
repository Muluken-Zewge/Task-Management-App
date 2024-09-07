import 'dart:async';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/feature/task/domain/entity/task_entity.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_event.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_state.dart';
import 'package:task_list/feature/task/presentation/screen/completed_task.dart';
import 'package:task_list/feature/task/presentation/widget/app_drawer.dart';

import '../../../../core/utils/app_color.dart';
import '../../../quotes/presentation/bloc/quotes_bloc/quotes_bloc.dart';
import '../../../quotes/presentation/bloc/quotes_bloc/quotes_event.dart';
import '../../../quotes/presentation/bloc/quotes_bloc/quotes_state.dart';
import '../widget/bottom_sheet.dart';
import '../widget/task_item.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final newTaskBloc=TaskBloc();
  var taskInial = [];
  bool isSent = false;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasksEvent());

    // Initialize the plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(Task task) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_priority_channel', // ID for the channel
      'high_priority_channel', // Name of the channel
      channelDescription:
          'your_channel_description', // Description of the channel
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    String formattedDateTime =
        DateFormat('MMM d, y h:mm a').format(task.dueDate);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Task Remainder: ${task.title}', // Notification Title
      'your ${task.title} is scheduled for $formattedDateTime.', // Notification Body
      platformChannelSpecifics,
      payload: task.title, // Optional payload
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
            // leading: Container(
            //   height: 40,
            //   width: 40,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(6),
            //       color: const Color.fromARGB(255, 184, 184, 184)),
            //),
            title: Text(
              formattedDate,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
            subtitle: Row(
              children: [
                Text(
                  "Hello,",
                  style: TextStyle(),
                ),
                Text(
                  "Muluken",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Task List",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColor.primary),
                  ),
                  onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            // padding: const EdgeInsets.all(8.0),
                            child: BottomSheetForm(),
                          )),
                  child: const Text(
                    "+ Add new Task",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
          Expanded(child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is TaskLoaded) {
                for (var task in state.tasks) {
                  final now = DateTime.now();
                  final difference = task.dueDate.difference(now).inMinutes;

                  if (difference > 0 && difference == 60 && !isSent) {
                    // Task is within the next hour, schedule a notification
                    showNotification(task);
                    isSent = true;
                  } else {
                    isSent = false;
                  }
                }
                return ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
                    return GestureDetector(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: BottomSheetForm(
                                  task: task,
                                ),
                              )),
                      child: TaskItem(
                        id: task.id,
                        name: task.title,
                        description: task.description,
                        dueDate: task.dueDate,
                        isDone: task.isDone,
                      ),
                    );
                  },
                );
              } else if (state is TaskError) {
                return Center(child: Text('Failed to load tasks'));
              } else {
                return Center(child: Text('No tasks available'));
              }
            },
          ))
        ],
      ),

      //     Container(
      //       child: ListView.builder(
      //   itemCount: 7,
      //   padding: const EdgeInsets.symmetric(vertical: 16),
      //   itemBuilder: (BuildContext context, index) {
      //     return Dismissible(
      //                  background: Container(
      //               color: Colors.blue,
      //               child: Padding(
      //                 padding: const EdgeInsets.all(15),
      //                 child: Row(
      //                   children: const [
      //                     Icon(Icons.favorite, color: Colors.red),
      //                     SizedBox(
      //                       width: 8.0,
      //                     ),
      //                     Text('Move to favorites',
      //                         style: TextStyle(color: Colors.white)),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             secondaryBackground: Container(
      //               color: Colors.red,
      //               child: Padding(
      //                 padding: const EdgeInsets.all(15),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.end,
      //                   children: const [
      //                     Icon(Icons.delete, color: Colors.white),
      //                     SizedBox(
      //                       width: 8.0,
      //                     ),
      //                     Text('Move to trash',
      //                         style: TextStyle(color: Colors.white)),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //       key: Key('item {items[index]}'),
      //       onDismissed: (DismissDirection direction) {
      //         if (direction == DismissDirection.startToEnd) {
      //           print("Add to favorite");
      //         } else {
      //           print('Remove item');
      //         }

      //         // setState(() {
      //         //   items.removeAt(index);
      //         // });
      //       },
      //       child: ListTile(
      //               leading: const Icon(
      //                 Icons.card_giftcard_rounded,
      //                 color: Colors.black,
      //               ),
      //               title: Text(
      //                 "items[index]",
      //                 style: TextStyle(
      //                     color: Colors.black.withOpacity(.6), fontSize: 18),
      //               ),
      //               subtitle: Text(
      //                 "This Gift is For you",
      //                 style: TextStyle(color: Colors.green.withOpacity(.6)),
      //               ),
      //             ),
      //     );
      //   }
      // ),
      //     ),
    );
  }
}
