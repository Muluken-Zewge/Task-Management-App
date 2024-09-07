import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_event.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_state.dart';

import '../../../../core/utils/app_color.dart';
import '../../../quotes/presentation/bloc/quotes_bloc/quotes_bloc.dart';
import '../../../quotes/presentation/bloc/quotes_bloc/quotes_event.dart';
import '../../../quotes/presentation/bloc/quotes_bloc/quotes_state.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  // final newTaskBloc=TaskBloc();
  var taskInial = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(LoadTasksEvent());
    String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color.fromARGB(255, 184, 184, 184)),
            ),
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
      body: BlocBuilder<QuoteBloc, QuoteState>(
        builder: (context, state) {
          if (state is QuoteLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is QuoteLoaded) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '"${state.quote.text}"',
                      style:
                          TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '- ${state.quote.author}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is QuoteError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Press the button to get a quote.'));
          }
        },
      ),
    );
  }
}
