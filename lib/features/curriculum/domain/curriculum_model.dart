class CurriculumModel {
  final int id;
  final String subject;
  final String grade;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;

  CurriculumModel({
    required this.id,
    required this.subject,
    required this.grade,
    this.description,
    this.imageUrl,
    required this.createdAt,
  });

  factory CurriculumModel.fromJson(Map<String, dynamic> json) {
    return CurriculumModel(
      id: json['id'],
      subject: json['subject'],
      grade: json['grade'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
