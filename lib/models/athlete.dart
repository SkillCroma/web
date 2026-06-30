class Athlete {
  final int rank;
  final String name;
  final String uid;
  final String sport;
  final int credit;
  final String state;
  final int? age;
  final String? gender;

  const Athlete({
    required this.rank,
    required this.name,
    required this.uid,
    required this.sport,
    required this.credit,
    required this.state,
    this.age,
    this.gender,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      rank: json['rank'] as int,
      name: json['name'] as String,
      uid: json['uid'] as String,
      sport: json['sport'] as String,
      credit: json['credit'] as int,
      state: json['state'] as String,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
    );
  }

  String get rankString {
    if (rank == 1) return '1st';
    if (rank == 2) return '2nd';
    if (rank == 3) return '3rd';
    return '${rank}th';
  }
}
