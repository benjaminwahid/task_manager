import 'package:flutter/material.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
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
                  //return const TaskCard(taskStatus: TaskStatus.completed,);
                  },
                  separatorBuilder: (context, index)=> const Divider(height: 8,) ),

          ],
        ),
      ),

    );
  }


}



