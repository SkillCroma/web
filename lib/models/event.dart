class Event {
  final String id;
  final String bannerImage;
  final String title;
  final String description;
  final String date;
  final DateTime timestamp;
  final String startTime;
  final String endTime;
  final String location;
  final String state;
  final String sport;

  Event({
    required this.id,
    required this.bannerImage,
    required this.title,
    required this.description,
    required this.date,
    required this.timestamp,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.state,
    required this.sport,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      bannerImage: json['bannerImage'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      timestamp: DateTime.parse(json['timestamp']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      location: json['location'],
      state: json['state'],
      sport: json['sport'],
    );
  }
}
