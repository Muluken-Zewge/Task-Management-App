import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_event.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_state.dart';

import '../../../../core/utils/app_color.dart';
import '../../../quotes/presentation/bloc/quotes_bloc/quotes_bloc.dart';
import '../../../quotes/presentation/bloc/quotes_bloc/quotes_event.dart';
import '../../../quotes/presentation/bloc/quotes_bloc/quotes_state.dart';
import '../widget/bottom_sheet.dart';
import '../widget/task_item.dart';

class CompletedTaskPage extends StatefulWidget {
  const CompletedTaskPage({super.key});

  @override
  State<CompletedTaskPage> createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {
  // final newTaskBloc=TaskBloc();
  var taskInial = [];
  @override
  void initState() {
    // BlocProvider.of<QuoteBloc>(context).add(LoadQuoteEvent());

    super.initState();
    context.read<TaskBloc>().add(LoadTasksEvent());
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
            subtitle: const Row(
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
      drawer: Drawer(
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
                //Navigator.pop(context);
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
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Completed Tasks List",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Expanded(child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is TaskLoaded) {
                final completedTasks =
                    state.tasks.where((task) => task.isDone == true).toList();

                return ListView.builder(
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    return TaskItem(
                      id: task.id,
                      name: task.title,
                      description: task.description,
                      dueDate: task.dueDate,
                      isDone: task.isDone,
                    );

                    // ListTile(
                    //   title: Text(task.title),
                    //   subtitle: Text(task.description),
                    //   trailing: Checkbox(
                    //     value: task.isDone,
                    //     onChanged: (value) {
                    //       BlocProvider.of<TaskBloc>(context)
                    //           .add(UpdateExistingTaskEvent(
                    //         task.copyWith(isDone: value!),
                    //       ));
                    //     },
                    //   ),
                    //   onLongPress: () {
                    //     BlocProvider.of<TaskBloc>(context)
                    //         .add(DeleteTaskByIdEvent(task.id));
                    //   },
                    // );
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
