import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _messages = [];

  List<DocumentSnapshot> get messages => _messages;

  Future<void> fetchMessages(String senderId, String receiverId) async {
    try {
      var snapshot = await _firestore
          .collection('messages')
          .where('senderId', isEqualTo: senderId)
          .where('receiverId', isEqualTo: receiverId)
          .get();
      _messages = snapshot.docs;
      notifyListeners(); // Yangi xabarlar ro'yxatini bildirish
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> sendMessage(
      String senderId, String receiverId, String message) async {
    try {
      await _firestore.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      });
      fetchMessages(senderId,
          receiverId); // Xabar jo'natildan so'ng xabarlar ro'yxatini yangilash
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
