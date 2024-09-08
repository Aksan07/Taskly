class Task {
  String content;
  bool done;
  DateTime timeStamp;

  Task({
    required this.content,
    required this.done,
    required this.timeStamp,
  });

  factory Task.fromMaP(Map task) {
    return Task(
        content: task["content"],
        done: task["done"],
        timeStamp: task["timeStamp"]);
  }

  Map toMap() {
    return {
      "content": content,
      "done": done,
      "timeStamp": timeStamp,
    };
  }
}
