import 'package:flutter/material.dart';
import 'package:testproject/data/models/task_list_model.dart';
import 'package:testproject/data/models/task_model.dart';
import 'package:testproject/data/models/task_status_count_list_model.dart';
import 'package:testproject/data/models/task_status_count_model.dart';
import 'package:testproject/data/service/network_client.dart';
import 'package:testproject/data/utils/urls.dart';
import 'package:testproject/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:testproject/ui/widgets/snack_bar_message.dart';

import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  bool _getNewTasksInProgress = false;
  List<TaskModel> _newTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: _getStatusCountInProgress == false,
                replacement: const Padding(
                  padding: EdgeInsets.all(16),
                  child: CenteredCircularProgressIndicator(),
                ),
                child: _buildSummarySection()),
            Visibility(
              visible: _getNewTasksInProgress == false,
              replacement: const SizedBox(
                  height: 300,
                  child: CenteredCircularProgressIndicator()),
              child: ListView.separated(
                  itemCount: _newTaskList.length,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return  TaskCard(taskStatus: TaskStatus.sNewTask,
                    taskModel: _newTaskList[index],
                      refreshList: _getAllNewTaskList,
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                        height: 8,
                      )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _taskStatusCountList.length,
          itemBuilder: (context, index) {
            return SummaryCard(
                title: _taskStatusCountList[index].status,
                count: _taskStatusCountList[index].count);
          },
        ),
      ),
    );
  }

  Future<void> _getAllTaskStatusCount() async {
    _getStatusCountInProgress = true;
    setState(() {});
    final NetworkResponse response =
        await NetworkClient.getRequest(url: Urls.taskStatusCountUrl);
    if (response.isSuccess) {
      TaskStatusCountListModel taskStatusCountListModel =
          TaskStatusCountListModel.fromJson(response.data ?? {});
      _taskStatusCountList = taskStatusCountListModel.statusCountList;
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getStatusCountInProgress = false;
    setState(() {});
  }
  Future<void> _getAllNewTaskList() async {
    _getNewTasksInProgress = true;
    setState(() {});
    final NetworkResponse response =
        await NetworkClient.getRequest(url: Urls.newTaskListUrl);
    if (response.isSuccess) {
      TaskListModel taskListModel =
          TaskListModel.fromJson(response.data ?? {});
      _newTaskList = taskListModel.taskList;
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getNewTasksInProgress = false;
    setState(() {});
  }
}
