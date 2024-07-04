import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_chat/services/auth_provider.dart';
import 'package:test_chat/services/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;

  const ChatScreen({
    Key? key,
    required this.receiverId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var senderId = Provider.of<AuthProviders>(context, listen: false).user!.uid;
    Provider.of<ChatProvider>(context, listen: false)
        .fetchMessages(senderId, widget.receiverId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                var messages = chatProvider.messages;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return ListTile(
                      title: Text(message['message']),
                      subtitle: Text(message['senderId']),
                      // Xabarlarni ko'rsatish usullarini o'zgartirishingiz mumkin
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Xabaringizni yozing...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    var senderId = Provider.of<AuthProviders>(context, listen: false).user!.uid;
    Provider.of<ChatProvider>(context, listen: false)
        .sendMessage(senderId, widget.receiverId, message);
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
