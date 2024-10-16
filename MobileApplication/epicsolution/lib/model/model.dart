class User {
  final String employeeNumber;
  final String password;

  User({
    required this.employeeNumber,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      employeeNumber: json['employeeNumber'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeNumber': employeeNumber,
      'password': password,
    };
  }
}


