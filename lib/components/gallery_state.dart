import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key, required this.userId});
  final String userId;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool isLoading = true;
  List<DocumentSnapshot> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: widget.userId)
        .get();
    setState(() {
      posts = postSnapshot.docs;
      isLoading = false;
    });
  }

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  Widget _createPopupContent(String url) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _createPhotoTitle(),
            Image.network(url),
          ],
        ),
      ),
    );
  }

  Widget _createPhotoTitle() => Container(
        width: double.infinity,
        color: Colors.white,
        child: const ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://placeimg.com/640/480/people'),
          ),
          title: Text(
            'john.doe',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      );

  void _showPopup(String url) {
    final overlay = Overlay.of(context);
    final overlayEntry = _createPopupDialog(url);
    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final postData = post.data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                    _showPopup(postData['image_url']);
                  },
                  child: Image.network(
                    postData['image_url'],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}

class AnimatedDialog extends StatelessWidget {
  final Widget child;

  const AnimatedDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: child,
        ),
      ),
    );
  }
}