class Name {
  final String title;
  final String first;
  final String last;

  Name({required this.title, required this.first, required this.last});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      title: json['title'] ?? '',
      first: json['first'] ?? '',
      last: json['last'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'first': first, 'last': last};
  }

  String get fullName => '$title $first $last';
}
