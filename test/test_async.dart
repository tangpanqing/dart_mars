import 'dart:io';
import 'dart:isolate';

main() async {
  List<TaskItem> taskList = [
    TaskItem('1', 'param1'),
    TaskItem('2', 'param2'),
    TaskItem('3', 'param1'),
    TaskItem('4', 'param2'),
    TaskItem('5', 'param1'),
    TaskItem('6', 'param2'),
    TaskItem('7', 'param1'),
    TaskItem('8', 'param2'),
    TaskItem('9', 'param1'),
    TaskItem('0', 'param2'),
  ];

  print(DateTime.now());

  MultiTask.run(
    taskList: taskList,
    taskFunc: taskFunc,
    onCompletedItem: (TaskRes taskRes) => print(taskRes.res),
    onCompletedAll: (List<TaskRes> taskResList) => print(DateTime.now()),
  );
}

void taskFunc(TaskMessage taskMessage) async {
  sleep(Duration(seconds: 3));

  String res = 'res';

  taskMessage.sendPort.send(TaskRes(taskMessage.taskItem.key, res));
}

class MultiTask {
  static void run(
      {List<TaskItem> taskList,
      Function taskFunc,
      Function onCompletedItem,
      Function onCompletedAll}) async {
    ReceivePort receivePort = new ReceivePort();

    Map<String, Isolate> mapParam = {};
    for (int i = 0; i < taskList.length; i++) {
      TaskItem taskItem = taskList[i];
      mapParam[taskItem.key] = await Isolate.spawn(
          taskFunc, TaskMessage(receivePort.sendPort, taskItem));
    }

    List<TaskRes> taskResList = [];
    receivePort.listen((message) async {
      TaskRes taskRes = message as TaskRes;
      if (null != onCompletedItem) await onCompletedItem(taskRes);
      taskResList.add(taskRes);
      mapParam[taskRes.key].kill();
      if (taskResList.length == taskList.length) {
        receivePort.close();
        if (null != onCompletedAll) await onCompletedAll(taskResList);
      }
    });
  }
}

class TaskMessage {
  SendPort sendPort;
  TaskItem taskItem;
  TaskMessage(this.sendPort, this.taskItem);
}

class TaskItem {
  String key;
  String param;

  TaskItem(this.key, this.param);
}

class TaskRes {
  String key;
  String res;

  TaskRes(this.key, this.res);
}
