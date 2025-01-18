import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:userapp/pages/other_entities.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final postData = post.data() as Map<String, dynamic>;
              final userId = postData['userId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;

                  return PostCardComponent(
                    userId: userId,
                    imageUrl: postData['image_url'] ?? '',
                    caption: postData['caption'] ?? '',
                    username: userData['username'] ?? 'Anonymous',
                    avatarUrl: userData['avatar_url'] ?? '',
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PostCardComponent extends StatelessWidget {
  final String userId;
  final String imageUrl;
  final String caption;
  final String username;
  final String avatarUrl;

  const PostCardComponent({
    super.key,
    required this.userId,
    required this.imageUrl,
    required this.caption,
    required this.username,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtherEntitiesProfilePage(userId: userId),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtherEntitiesProfilePage(userId: userId),
                  ),
                );
              },
              child: Text(username),
            ),
          ),
          Image.network(imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(caption),
          ),
        ],
      ),
    );
  }
}