class EmployeeDetail {
  final String firstName;
  final String middleInitial;
  final String lastName;
  final String homemailingAddress;
  final String workPhone;
  final String cellPhone;
  final String email;

  EmployeeDetail({
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.homemailingAddress,
    required this.workPhone,
    required this.cellPhone,
    required this.email,
  });

  factory EmployeeDetail.fromJson(Map<String, dynamic> json) {
    return EmployeeDetail(
      firstName: json['firstName'],
      middleInitial: json['middleInitial'],
      lastName: json['lastName'],
      homemailingAddress: json['homeMailingAddress'],
      workPhone: json['workPhone'],
      cellPhone: json['cellPhone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleInitial': middleInitial,
      'lastName': lastName,
      'homeMailingAddress': homemailingAddress,
      'workPhone': workPhone,
      'cellPhone': cellPhone,
      'email': email,
    };
  }
}
