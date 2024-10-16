class OrderDetail {
  final int orderId;
  final String orderNumber;
  final String supervisor;
  final double grandTotal;
  final int itemsNumber;
  final String statusName;

  OrderDetail(
      {required this.orderId,
      required this.orderNumber,
      required this.supervisor,
      required this.statusName,
      required this.itemsNumber,
      required this.grandTotal});

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
        orderId: json['orderId'],
        orderNumber: json['orderNumber'],
        supervisor: json['supervisorName'],
        statusName: json['statusName'],
        itemsNumber: json['itemsNumber'],
        grandTotal: json['total']);
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderNumber': orderNumber,
      'supervisorName': supervisor,
      'statusName': statusName,
      'itemNumber': itemsNumber,
      'total': grandTotal,
    };
  }
}
