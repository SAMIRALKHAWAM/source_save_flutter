import 'package:flutter/material.dart';

class UserListScreen extends StatelessWidget {
  // قائمة ثابتة من المستخدمين لتوضيح الفكرة
  final List<Map<String, String>> users = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'profileImageUrl': 'https://www.example.com/images/user1.jpg',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'profileImageUrl': 'https://www.example.com/images/user2.jpg',
    },
    {
      'name': 'Alice Johnson',
      'email': 'alice.johnson@example.com',
      'profileImageUrl': 'https://www.example.com/images/user3.jpg',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
        backgroundColor: Colors.purple[800],
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index]; // جلب المستخدم من القائمة
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {

                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['profileImageUrl']!),
                  ),
                  title: Text(
                    user['name']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple[800],
                    ),
                  ),
                  subtitle: Text(
                    user['email']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.purple[600],
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.purple[800],
                    size: 20,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
