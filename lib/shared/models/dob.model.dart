class Dob {
  final DateTime date;
  final int age;

  Dob({required this.date, required this.age});

  factory Dob.fromJson(Map<String, dynamic> json) {
    return Dob(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      age: json['age'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String(), 'age': age};
  }

  String get formattedDate => '${date.day}/${date.month}/${date.year}';
}
