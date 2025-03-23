import 'package:flutter/material.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
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
                  //return const TaskCard(taskStatus: TaskStatus.canceled,);
                  },
                  separatorBuilder: (context, index)=> const Divider(height: 8,) ),

          ],
        ),
      ),

    );
  }


}



