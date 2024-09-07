import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_list/feature/task/domain/entity/task_entity.dart';

import '../../../../core/utils/app_color.dart';
import '../bloc/task_bloc/task_bloc.dart';
import '../bloc/task_bloc/task_event.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.id,
    required this.dueDate,
    required this.description,
    required this.isDone,
    required this.name,
  });
  final String id;
  final String name;
  final String description;
  final DateTime dueDate;
  final bool isDone;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isCompleted = false;
  @override
  void initState() {
    isCompleted = widget.isDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime =
        DateFormat('MMM d, y h:mm a').format(widget.dueDate);

    return Dismissible(
      background: Container(
        color: Colors.red,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete_forever,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
      ),
      key: Key(widget.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Handle the delete action
        context.read<TaskBloc>().add(DeleteTaskByIdEvent(widget.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.name} deleted')),
        );
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        // color:AppColor.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 16,
              decoration: const BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(widget.name),
                    subtitle: Text(
                      widget.description,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        fillColor: MaterialStatePropertyAll(AppColor.primary),
                        shape: CircleBorder(),
                        value: isCompleted,
                        onChanged: (val) {
                          print("object $val");
                          Task task = Task(
                              id: widget.id,
                              title: widget.name,
                              description: widget.description,
                              dueDate: widget.dueDate);
                          DateTime date = new DateTime.now();
                          isCompleted = val ?? false;
                          context.read<TaskBloc>().add(UpdateExistingTaskEvent(
                                task.copyWith(isDone: val!),
                              ));
                          // var newDt = DateFormat.yMMM().format(date);
                          // final new_task=Task(
                          //   id: id,
                          //   taskAction: TaskAction.UPDATE_TASK,
                          //   title: name,
                          //   description: description,
                          //   dueDate: newDt,
                          //   status: !isDone);
                          // newTask.taskEventSink.add(new_task);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(formattedDateTime),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
