import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_list/feature/task/domain/entity/task_entity.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_bloc.dart';

import '../../../../core/utils/app_color.dart';
import '../../data/model/task_model.dart';
import '../bloc/task_bloc/task_event.dart';

class BottomSheetForm extends StatefulWidget {
  BottomSheetForm({super.key, this.newTask, this.task});
  final newTask;
  final Task? task;

  @override
  State<BottomSheetForm> createState() => _BottomSheetFormState();
}

class _BottomSheetFormState extends State<BottomSheetForm> {
  final descriptionController = TextEditingController();

  final titleController = TextEditingController();
  DateTime? _selectedDate; // Store the selected date

  @override
  void initState() {
    // BlocProvider.of<QuoteBloc>(context).add(LoadQuoteEvent());

    super.initState();

    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
    }
  }

  get http => null;

  // Method to call the date picker
  Future<void> _selectDateAndTime(BuildContext context) async {
    // Pick the date first
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date is shown initially
      firstDate: DateTime(2000), // Earliest date the user can pick
      lastDate: DateTime(2100), // Latest date the user can pick
    );

    if (pickedDate != null) {
      // If a date was picked, now pick the time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(), // Current time is shown initially
      );

      if (pickedTime != null) {
        // Combine the selected date and time
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Update the state with the selected date and time
        setState(() {
          _selectedDate = selectedDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : "No date selected";
    return SingleChildScrollView(
        child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: MediaQuery.of(context).size.height * 0.65,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              widget.task == null ? "Add New Todos" : "Update Tasks",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 8,
            ),
            Text("Title"),
            Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 240, 240),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: titleController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add title here",
                    focusedBorder: InputBorder.none,
                  ),
                )),
            Text("Description"),
            Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 241, 240, 240),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add description here",
                    focusedBorder: InputBorder.none,
                  ),
                )),
            Text("Due Date"),
            GestureDetector(
                onTap: () => _selectDateAndTime(context),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Selected Date: $formattedDate",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 20),
                      Icon(Icons.calendar_month),
                    ])),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        padding: MaterialStatePropertyAll(EdgeInsets.all(14)),
                        backgroundColor:
                            MaterialStateProperty.all(AppColor.secondary),
                      ),
                      onPressed: null,
                      child: Text("cancle")),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          padding: MaterialStatePropertyAll(EdgeInsets.all(14)),
                          backgroundColor:
                              MaterialStatePropertyAll(AppColor.primary)),
                      onPressed: () async {
                        if (titleController.text.isEmpty ||
                            descriptionController.text.isEmpty ||
                            _selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("please fill required fields")));
                          Navigator.pop(context);
                          return;
                        }
                        DateTime date = new DateTime.now();
                        int _id = date.millisecondsSinceEpoch;
                        widget.task == null
                            ? (context.read<TaskBloc>().add(AddNewTaskEvent(
                                TaskModel(
                                    id: _id.toString(),
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    dueDate: _selectedDate ?? date))))
                            : (context.read<TaskBloc>().add(
                                UpdateExistingTaskEvent(Task(
                                    id: widget.task!.id,
                                    title: titleController.text.isEmpty
                                        ? widget.task!.title
                                        : titleController.text,
                                    description:
                                        descriptionController.text.isEmpty
                                            ? widget.task!.description
                                            : descriptionController.text,
                                    dueDate: _selectedDate ??
                                        widget.task!.dueDate))));
                        Navigator.pop(context);
                      },
                      child: Text(widget.task == null ? "Add" : "Update")),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
