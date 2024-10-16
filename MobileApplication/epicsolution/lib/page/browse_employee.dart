import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'employee_detailes.dart';

class BrowseEmployee extends StatefulWidget {
  const BrowseEmployee({super.key});

  @override
  State<BrowseEmployee> createState() => _BrowseEmployeeState();
}

class _BrowseEmployeeState extends State<BrowseEmployee> {
  String dropdownValue = "SELECT DEPARTMENT";
  Map<String, String> departmentMap = {};
  String? selectedDepartment;
  bool isDepartmentLoading = true;
  bool isEmployeeLoading = false;

  String employeeId = "";
  String lastName = "";

  List<dynamic> employeeList = [];
  String searchCriteria = "";

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    setState(() {
      isDepartmentLoading = true;
    });
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:5073/api/department'));

      if (response.statusCode == 200) {
        List<dynamic> departments = jsonDecode(response.body);
        setState(() {
          departmentMap = {"SELECT DEPARTMENT": ""};
          for (var dept in departments) {
            departmentMap[dept['name']] = dept['id'].toString();
          }
          dropdownValue = "SELECT DEPARTMENT";
          isDepartmentLoading = false;
        });
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (error) {
      setState(() {
        isDepartmentLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  Future<void> searchEmployees() async {
    setState(() {
      employeeList.clear();
      isEmployeeLoading = true;
    });

    Map<String, String> queryParams = {};

    if (selectedDepartment != null && selectedDepartment!.isNotEmpty) {
      queryParams['departmentId'] = selectedDepartment ?? '';
    }

    if (lastName != null && lastName.isNotEmpty) {
      queryParams['lastName'] = lastName;
    }

    if (employeeId != null && employeeId.isNotEmpty) {
      queryParams['employeeNumber'] = employeeId;
    }

    Uri uri = Uri.http('10.0.2.2:5073', '/api/employee/browse', queryParams);
    print(uri);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        employeeList = jsonDecode(response.body);
        isEmployeeLoading = false;

        dropdownValue = "SELECT DEPARTMENT";
        selectedDepartment = null;
        employeeId = "";
        lastName = "";

      });
    } else {
      setState(() {
        isEmployeeLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to find employees")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Browse Employee"),
        backgroundColor: const Color(0xFF8576FF),
      ),
      body: Center(
        child: isDepartmentLoading || isEmployeeLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Select Department:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(
                            () {
                              dropdownValue = newValue;
                              selectedDepartment = departmentMap[newValue];
                            },
                          );
                        }
                      },
                      items: departmentMap.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Enter Employee ID",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(
                          () {
                            employeeId = value;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Enter Last Name",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(
                          () {
                            lastName = value;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: searchEmployees,
                          child: const Text("Search"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.black,
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {},
                        //   child: const Text("Clear"),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.grey,
                        //     foregroundColor: Colors.white,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      searchCriteria,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: employeeList.length,
                        itemBuilder: (context, index) {
                          var employee = employeeList[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                "Employee: ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              subtitle: Text(
                                "Last Name: ${employee['lastName']}\nFirst Name: ${employee['firstName']}\nPosition: ${employee['position']}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              isThreeLine: true,
                              onTap: () {
                                // Navigate to the employee details page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmployeeDetails(
                                      employeeNumber:
                                          employee['employeeNumber'],
                                    ),
                                  ),
                                );
                              },
                            ),
                            margin: const EdgeInsets.all(10),
                            elevation: 5,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
