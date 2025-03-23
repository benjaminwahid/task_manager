import 'package:flutter/material.dart';
import 'package:testproject/ui/widgets/centered_circular_progress_indicator.dart';

import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  bool _getCancelledTaskInProgress = false;
  List<TaskModel> _cancelledTaskList = [];
  @override
  void initState() {
    super.initState();
    _getAllCancelledTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getCancelledTaskInProgress == false,
        replacement: const CenteredCircularProgressIndicator(),
        child: ListView.separated(
           itemCount: _cancelledTaskList.length,
             itemBuilder: (context, index){
             return  TaskCard(
               taskStatus: TaskStatus.cancelled,
               taskModel: _cancelledTaskList[index],
               refreshList: _getAllCancelledTaskList,
             );
             },
             separatorBuilder: (context, index)=> const SizedBox(height: 8,) ),
      ),

    );
  }
  Future<void> _getAllCancelledTaskList() async {
    _getCancelledTaskInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkClient.getRequest(url: Urls.cancelledTaskListUrl);
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _cancelledTaskList = taskListModel.taskList;
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getCancelledTaskInProgress = false;
    setState(() {});
  }

}



