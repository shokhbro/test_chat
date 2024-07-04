import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _users = [];

  List<DocumentSnapshot> get users => _users;

  Future<void> fetchUsers() async {
    try {
      var snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs;
      notifyListeners(); // Yangi ma'lumotlarni bildirish
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> searchUsers(String query) async {
    try {
      var snapshot = await _firestore
          .collection('users')
          .where('email', isGreaterThanOrEqualTo: query)
          .get();
      _users = snapshot.docs;
      notifyListeners(); // Yangi ma'lumotlarni bildirish
    } catch (e) {
      print('Error searching users: $e');
    }
  }
}
