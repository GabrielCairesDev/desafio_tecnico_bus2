class Location {
  final Street street;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final Coordinates coordinates;
  final Timezone timezone;

  Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.coordinates,
    required this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      street: Street.fromJson(json['street'] ?? {}),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postcode: json['postcode']?.toString() ?? '',
      coordinates: Coordinates.fromJson(json['coordinates'] ?? {}),
      timezone: Timezone.fromJson(json['timezone'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street.toJson(),
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
      'coordinates': coordinates.toJson(),
      'timezone': timezone.toJson(),
    };
  }
}

class Street {
  final int number;
  final String name;

  Street({required this.number, required this.name});

  factory Street.fromJson(Map<String, dynamic> json) {
    return Street(number: json['number'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'number': number, 'name': name};
  }

  String get fullAddress => '$number $name';
}

class Coordinates {
  final String latitude;
  final String longitude;

  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'] ?? '0',
      longitude: json['longitude'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}

class Timezone {
  final String offset;
  final String description;

  Timezone({required this.offset, required this.description});

  factory Timezone.fromJson(Map<String, dynamic> json) {
    return Timezone(
      offset: json['offset'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'offset': offset, 'description': description};
  }
}
