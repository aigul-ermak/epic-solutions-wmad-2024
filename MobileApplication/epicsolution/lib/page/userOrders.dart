import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './orderdetail.dart';

class UserOrder extends StatefulWidget {
  final String userId;
  UserOrder({required this.userId});

  @override
  _UserOrderState createState() => _UserOrderState();
}

class _UserOrderState extends State<UserOrder> {
  String dropdownValue = "No Connection";
  Map<String, String> userMap = {};
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders(widget.userId);
  }

  Future<void> fetchOrders(String userId) async {
    var url =
        Uri.http('10.0.2.2:5073', '/api/order/byUser', {'userId': userId});
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
        title: Text('Order List'),
        backgroundColor: Color(0xFF8576FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: userMap.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  var order = orders[index];
                  return Card(
                    child: ListTile(
                      title: Center(
                        child: Text("Order Number: ${order['poNumber']}"),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetails(
                              orderId: order['orderId'].toString(),
                            ),
                          ),
                        );
                      },
                    ),
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
