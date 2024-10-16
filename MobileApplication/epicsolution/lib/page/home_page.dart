import 'package:epicsolution/page/browse_employee.dart';
import 'package:epicsolution/page/orderList.dart';
import 'package:flutter/material.dart';
import './searchOrder.dart';
import './userOrders.dart';
import 'package:jwt_decode/jwt_decode.dart';

class HomePage extends StatelessWidget {
  final String token;
  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> loadFromToken = Jwt.parseJwt(token);
    final String currentUserId = loadFromToken['nameid'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Epic Solutions"),
        backgroundColor: Color(0xFF8576FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
      body: Center(
        child: ((loadFromToken['role'] == 'Regular Supervisor') ||
                (loadFromToken['role'] == 'HR Employee'))
            ? AdminMenuOptions(userId: currentUserId)
            : UserMenuOptions(userId: currentUserId),
      ),
    );
  }
}

class AdminMenuOptions extends StatelessWidget {
  final String userId;

  const AdminMenuOptions({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchOrder()),
                );
              },
              child: Text('Search Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                minimumSize: Size(200, 40),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderList(
                            userId: userId,
                          )),
                );
              },
              child: Text('Order List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                minimumSize: Size(200, 40),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BrowseEmployee()),
                );
              },
              child: const Text('Browse Employee'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                minimumSize: Size(200, 40),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UserMenuOptions extends StatelessWidget {
  final String userId;

  const UserMenuOptions({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserOrder(userId: userId)),
                );
              },
              child: Text('Order List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                minimumSize: Size(200, 40),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BrowseEmployee()),
                );
              },
              child: const Text('Browse Employee'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                minimumSize: Size(200, 40),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
