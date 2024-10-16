import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './orderdetail.dart';

class SearchOrder extends StatefulWidget {
  @override
  _SearchOrderState createState() => _SearchOrderState();
}

class _SearchOrderState extends State<SearchOrder> {
  String dropdownValue = "No Connection";
  Map<String, String> departmentMap = {};
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5073/api/department'));
    if (response.statusCode == 200) {
      List<dynamic> departments = jsonDecode(response.body);
      Map<String, String> tempMap = {"SELECT DEPARTMENT": ""};
      for (var dept in departments) {
        tempMap[dept['name']] = dept['id'].toString();
      }
      setState(() {
        departmentMap = tempMap;
        dropdownValue = "SELECT DEPARTMENT";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load department"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> fetchOrders(String departmentId) async {
    var url =
        Uri.http('10.0.2.2:5073', '/api/order', {'departmentId': departmentId});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> fetchedOrders = jsonDecode(response.body);
      setState(() {
        orders = fetchedOrders;
      });
      if (orders.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No order found"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bad request"),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("NO Orders Found"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load orders"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search by department'),
        backgroundColor: Color(0xFF8576FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: departmentMap.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (dropdownValue == "SELECT DEPARTMENT") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("No department selected"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  String? departmentId = departmentMap[dropdownValue];
                  if (departmentId != null) {
                    fetchOrders(departmentId);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Department not found"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  var order = orders[index];
                  return Card(
                    child: ListTile(
                      title: Text("Order Number: ${order['orderNumber']}"),
                      subtitle: Text(
                          "Date: ${order['creationDate']}\nSupervisor: ${order['supervisorName']}\nStatus: ${order['statusName']}"),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetails(
                                orderId: order['orderId'].toString(),
                              ),
                            ));
                      },
                    ),
                    margin: EdgeInsets.all(10),
                    elevation: 5,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
