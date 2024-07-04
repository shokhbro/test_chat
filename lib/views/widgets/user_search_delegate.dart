import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_chat/services/user_provider.dart';
import 'package:test_chat/views/screens/chat_screen.dart';

class UserSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel =>
      'Foydalanuvchilarni pochtasi bo\'yicha qidirish';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      textTheme: theme.textTheme.copyWith(
        headlineMedium: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Provider.of<UsersProvider>(context, listen: false).searchUsers(query);
    return Consumer<UsersProvider>(
      builder: (context, usersProvider, child) {
        var users = usersProvider.users;
        if (users.isEmpty) {
          return const Center(
            child: Text('Foydalanuvchilar topilmadi'),
          );
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];
            return ListTile(
              title: Text(user['email']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      receiverId: user['id'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // Avval ishlatilmagan, hozir ishlatilishi mumkin.
  }
}
