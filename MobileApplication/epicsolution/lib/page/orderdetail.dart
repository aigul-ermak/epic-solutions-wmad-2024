import 'package:flutter/material.dart';
import '../model/orderdetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  final String orderId;

  const OrderDetails({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetails> {
  OrderDetail? orderDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    final queryParameters = {
      'orderId': widget.orderId,
    };
    Uri uri = Uri.http('10.0.2.2:5073', '/api/order/detail', queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          orderDetail = OrderDetail.fromJson(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        showError("Error fetching order details.");
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
        title: const Text("Order Details"),
        backgroundColor: const Color(0xFF8576FF),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderDetail == null
              ? const Center(child: Text("No orders found."))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                            Icons.book, "PO Number:", orderDetail!.orderNumber),
                        const SizedBox(height: 8),
                        _buildDetailRow(Icons.person, "Supervisor Name:",
                            orderDetail!.supervisor),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                            Icons.star, "Status:", orderDetail!.statusName),
                        const SizedBox(height: 8),
                        _buildDetailRow(Icons.rocket, "Items Number:",
                            orderDetail!.itemsNumber.toString()),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                            Icons.money,
                            "Grand Total:",
                            NumberFormat.currency(symbol: "\$")
                                .format(orderDetail!.grandTotal)),
                        const SizedBox(height: 8),
                      ]),
                ),
    );
  }
}
