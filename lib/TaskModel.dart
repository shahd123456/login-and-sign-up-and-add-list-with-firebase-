class TaskModel {

  final String id;
  final String title;
  final String description;
  bool isfinsh;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isfinsh
  });

  factory TaskModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TaskModel(
      id: id,
      title: data["title"] ?? "",
      description: data["description"] ?? "",
      isfinsh: data["isfinsh"] ?? false,
    );
  }
}
