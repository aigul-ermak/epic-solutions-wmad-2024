

class UserOutput {
  final String employeeNumber;
  final String token;
  final int expiresIn;

  UserOutput({
    required this.employeeNumber,
    required this.token,
    required this.expiresIn,
  });

  factory UserOutput.fromJson(Map<String, dynamic> json) {
    return UserOutput(
      employeeNumber: json['empNumber'] ?? '',
      token: json['accessToken'] ?? '',
      expiresIn: json['expiry'] ?? 0,
    );
  }
}