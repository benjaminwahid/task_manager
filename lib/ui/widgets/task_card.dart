import 'package:flutter/material.dart';

enum TaskStatus{
  sNewTask,
  progress,
  completed,
  canceled
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.taskStatus,
  });
final TaskStatus taskStatus;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Title will be here',style: TextStyle(
                fontWeight:FontWeight.w600,
                fontSize: 16
            ),),
            const SizedBox(height: 5,),
            const Text('Description will be here'),
            const SizedBox(height: 5,),
            const Text('Date:20/03/2025'),
            Row(
              children: [
                Chip(label: const Text('New',style: TextStyle(color: Colors.white),),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _getStatusChipColor(),
                  side: BorderSide.none,
                ),
                const Spacer(),
                IconButton(onPressed: (){}, icon: const Icon(Icons.delete)),
                IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),

              ],
            ),
          ],
        ),
      ),
    );
  }
  Color _getStatusChipColor(){
    late Color color;

    switch(taskStatus) {

      case TaskStatus.sNewTask:
        color = Colors.blue;
      case TaskStatus.progress:
        color =  Colors.purple;
      case TaskStatus.completed:
        color =  Colors.green;
      case TaskStatus.canceled:
        color = Colors.red;
    }return color;


  }
}
