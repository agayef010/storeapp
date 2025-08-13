import 'package:flutter/foundation.dart';
import 'cart_item.dart';

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final DateTime deliveryDate;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'deliveryDate': deliveryDate.toIso8601String(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      date: DateTime.parse(json['date']),
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
    );
  }
}
