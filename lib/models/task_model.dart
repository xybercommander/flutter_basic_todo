class Task {
  
  int id;
  String title;
  DateTime dateTime;
  String priority;
  int status; // 0 - Incomplete, 1 - Complete

  Task({this.title, this.dateTime, this.priority, this.status});
  Task.withId({this.id, this.title, this.dateTime, this.priority, this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if(id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['dateTime'] = dateTime.toIso8601String();
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      title: map['title'],
      dateTime: DateTime.parse(map['dateTime']),
      priority: map['priority'],
      status: map['status']
    );
  }

}