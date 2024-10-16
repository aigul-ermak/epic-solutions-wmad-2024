import 'package:flutter/material.dart';
import '../model/employee_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDetails extends StatefulWidget {
  final String employeeNumber;

  const EmployeeDetails({Key? key, required this.employeeNumber})
      : super(key: key);

  @override
  _EmployeeDetailsPageState createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetails> {
  EmployeeDetail? employeeDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployeeDetails();
  }

  Future<void> fetchEmployeeDetails() async {
    final queryParameters = {
      'employeeNumber': widget.employeeNumber,
    };
    Uri uri =
        Uri.http('10.0.2.2:5073', '/api/employee/detail', queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          employeeDetail = EmployeeDetail.fromJson(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        showError("Error fetching employee details.");
      }
    } catch (e) {
      showError("An error occurred: $e");
    }
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      showError('Could not launch phone');
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Sample Subject&body=Sample Body', // Optional
    );

    //final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      showError('Could not launch email');
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      [Function()? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label $value",
              style: const TextStyle(fontSize: 18),
            ),
          ),
          if (onTap != null)
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blueGrey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Details"),
        backgroundColor: const Color(0xFF8576FF),
      ),
      body: Container(
        color: const Color(0xFFEFEFEF),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : employeeDetail == null
                ? const Center(child: Text("No employee details found."))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(Icons.person, "First Name:",
                            employeeDetail!.firstName),
                        const SizedBox(height: 8),
                        _buildDetailRow(Icons.person_outline, "Middle Initial:",
                            employeeDetail!.middleInitial),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                            Icons.person, "Last Name:", employeeDetail!.lastName),
                        const SizedBox(height: 8),
                        _buildDetailRow(Icons.home, "Address:",
                            employeeDetail!.homemailingAddress),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                            Icons.phone,
                            "Work Phone:",
                            employeeDetail!.workPhone,
                            () => _launchPhone(employeeDetail!.workPhone)),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                            Icons.phone_android,
                            "Cell Phone:",
                            employeeDetail!.cellPhone,
                            () => _launchPhone(employeeDetail!.cellPhone)),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                            Icons.email,
                            "Email:",
                            employeeDetail!.email,
                            () => _launchEmail(employeeDetail!.email)),
                      ],
                    ),
                  ),
      ),
    );
  }
}
