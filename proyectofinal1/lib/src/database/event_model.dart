class EventModel {
  final int? id;
  final String name;
  final String topic;
  final String date;
  final String description;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String userEmail; // ✅ NUEVO

  EventModel({
    this.id,
    required this.name,
    required this.topic,
    required this.date,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.userEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'topic': topic,
      'date': date,
      'description': description,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'userEmail': userEmail, // ✅ NUEVO
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      name: map['name'],
      topic: map['topic'],
      date: map['date'],
      description: map['description'],
      imagePath: map['imagePath'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      userEmail: map['userEmail'], // ✅ NUEVO
    );
  }
}
