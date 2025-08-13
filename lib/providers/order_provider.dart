import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  OrderProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersData = prefs.getString('orders');
      if (ordersData != null) {
        final List<dynamic> ordersList = json.decode(ordersData);
        _orders = ordersList.map((order) => Order.fromJson(order)).toList();
      }
    } catch (e) {
      // Error loading orders
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersData = json.encode(_orders.map((order) => order.toJson()).toList());
      await prefs.setString('orders', ordersData);
    } catch (e) {
      // Error saving orders
    }
  }

  Future<void> createOrder(List<CartItem> items, double totalAmount) async {
    final order = Order(
      id: '#${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      items: items,
      totalAmount: totalAmount,
      status: 'Çatdırılır',
      deliveryDate: DateTime.now().add(Duration(days: 3)),
    );

    _orders.insert(0, order); // Add to beginning of list
    await _saveOrders();
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      final order = _orders[index];
      final updatedOrder = Order(
        id: order.id,
        date: order.date,
        items: order.items,
        totalAmount: order.totalAmount,
        status: newStatus,
        deliveryDate: order.deliveryDate,
      );
      _orders[index] = updatedOrder;
      _saveOrders();
      notifyListeners();
    }
  }
}
