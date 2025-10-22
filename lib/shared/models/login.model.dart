class Login {
  final String uuid;
  final String username;
  final String password;
  final String salt;
  final String md5;
  final String sha1;
  final String sha256;

  Login({
    required this.uuid,
    required this.username,
    required this.password,
    required this.salt,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      uuid: json['uuid'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      salt: json['salt'] ?? '',
      md5: json['md5'] ?? '',
      sha1: json['sha1'] ?? '',
      sha256: json['sha256'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'password': password,
      'salt': salt,
      'md5': md5,
      'sha1': sha1,
      'sha256': sha256,
    };
  }
}
