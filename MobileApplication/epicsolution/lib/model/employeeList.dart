class EmployeeList {
  final String employeeNumber;
  final String lastName;
  final String firstName;
  final String position;

  EmployeeList({
    required this.employeeNumber,
    required this.lastName,
    required this.firstName,
    required this.position,
    });

  factory EmployeeList.fromJson(Map<String, dynamic> json) {
    return EmployeeList(
      employeeNumber: json['EmployeeNumber'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      position: json['Position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeNumber': employeeNumber,
      'LastName': lastName,
      'FirstName': firstName,
      'Position': position,
    };
  }
}



