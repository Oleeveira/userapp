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
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20.0,
            ),
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
            const SizedBox(
              height: 20.0,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                height: 150.0,
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://imgs.search.brave.com/IzCeCU8PrEZ9T52ad2djo7oiwnH7Oue-3x_MKTRFZek/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTM1/MzMzMjI1OC9waG90/by9kb25hdGlvbi1j/b25jZXB0LXRoZS12/b2x1bnRlZXItZ2l2/aW5nLWEtZG9uYXRl/LWJveC10by10aGUt/cmVjaXBpZW50LXN0/YW5kaW5nLWFnYWlu/c3QtdGhlLXdhbGwu/d2VicD9iPTEmcz0x/NzA2NjdhJnc9MCZr/PTIwJmM9RDUzZHk0/SFBsZkxpOXlDTzhv/dW93SW45SHFJV2Zr/akV4NC1DMDVCOFRZ/VT0"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing",
            ),
            const SizedBox(
              height: 40.0,
            ),
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
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}