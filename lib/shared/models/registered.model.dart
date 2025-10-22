class Registered {
  final DateTime date;
  final int age;

  Registered({required this.date, required this.age});

  factory Registered.fromJson(Map<String, dynamic> json) {
    return Registered(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      age: json['age'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String(), 'age': age};
  }

  String get formattedDate => '${date.day}/${date.month}/${date.year}';
}
