class BackupModel {
  final String name;
  final String path;
  final int? size;
  final String? createdAt;

  const BackupModel({
    required this.name,
    required this.path,
    this.size,
    this.createdAt,
  });

  factory BackupModel.fromDB(Map<String, dynamic> json) {
    return BackupModel(
      name: json['name'],
      path: json['path'],
      size: json['size'],
      createdAt: json['created_at'],
    );
  }
}
