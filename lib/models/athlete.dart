class Athlete {
  final int rank;
  final String name;
  final String uid;
  final String type;
  final int credit;
  final String state;

  const Athlete({
    required this.rank,
    required this.name,
    required this.uid,
    required this.type,
    required this.credit,
    required this.state,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      rank: json['rank'] as int,
      name: json['name'] as String,
      uid: json['uid'] as String,
      type: json['type'] as String,
      credit: json['credit'] as int,
      state: json['state'] as String,
    );
  }

  String get rankString {
    if (rank == 1) return '1st';
    if (rank == 2) return '2nd';
    if (rank == 3) return '3rd';
    return '${rank}th';
  }
}
