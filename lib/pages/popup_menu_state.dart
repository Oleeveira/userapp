import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopupMenuState extends StatefulWidget {
  const PopupMenuState({super.key});

  @override
  State<PopupMenuState> createState() => _PopupMenuStateState();
}

class _PopupMenuStateState extends State<PopupMenuState> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Menu', style: TextStyle(color: Colors.black)),
        elevation: 0,
        actions: [], 
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go('/post_page');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade900,
                  fixedSize: Size(width * 0.75, width * 0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Nova publicação',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/item_register_page');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade900,
                fixedSize: Size(width * 0.75, width * 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: const Text(
                'Nova necessidade',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
