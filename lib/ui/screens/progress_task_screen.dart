import 'package:flutter/material.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
             ListView.separated(
                itemCount: 8,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                  return const TaskCard(taskStatus: TaskStatus.progress,);
                  },
                  separatorBuilder: (context, index)=> const Divider(height: 8,) ),

          ],
        ),
      ),

    );
  }


}



