class Id {
  final String name;
  final String value;

  Id({required this.name, required this.value});

  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(name: json['name'] ?? '', value: json['value']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}
