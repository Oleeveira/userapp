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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Stream<List<PostWithUser>> _postStream;

  @override
  void initState() {
    super.initState();
    _postStream = _fetchPostsWithUserData();
  }

  
  Stream<List<PostWithUser>> _fetchPostsWithUserData() {
    return _firestore.collection('posts').snapshots().asyncMap((snapshot) async {
      List<PostWithUser> postsWithUsers = [];

      for (var post in snapshot.docs) {
        final postData = post.data() as Map<String, dynamic>;
        final userId = postData['userId'];

        
        final userSnapshot = await _firestore.collection('users').doc(userId).get();
        final userData = userSnapshot.data() as Map<String, dynamic>? ?? {};

        postsWithUsers.add(
          PostWithUser(
            userId: userId,
            imageUrl: postData['image_url'] ?? '',
            caption: postData['caption'] ?? '',
            username: userData['username'] ?? 'Anonymous',
            avatarUrl: userData['avatar_url'] ?? '',
          ),
        );
      }

      return postsWithUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: StreamBuilder<List<PostWithUser>>(
        stream: _postStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCardComponent(
                userId: post.userId,
                imageUrl: post.imageUrl,
                caption: post.caption,
                username: post.username,
                avatarUrl: post.avatarUrl,
              );
            },
          );
        },
      ),
    );
  }
}


class PostWithUser {
  final String userId;
  final String imageUrl;
  final String caption;
  final String username;
  final String avatarUrl;

  PostWithUser({
    required this.userId,
    required this.imageUrl,
    required this.caption,
    required this.username,
    required this.avatarUrl,
  });
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
              onTap: () => _navigateToProfile(context),
              child: CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            title: GestureDetector(
              onTap: () => _navigateToProfile(context),
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

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherEntitiesProfilePage(userId: userId),
      ),
    );
  }
}

