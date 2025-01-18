import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemCardComponent extends StatelessWidget {
  final String itemName;
  final String itemDescription;
  final int itemQuantity;
  final String itemCategory;

  const ItemCardComponent({
    super.key,
    required this.itemName,
    required this.itemDescription,
    required this.itemQuantity,
    required this.itemCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 9.0, right: 9.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              child: Container(
                width: 45.0,
                height: 70.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: Color.fromARGB(255, 24, 32, 101),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.5),
                  child: IconButton(
                    onPressed: () {
                      GoRouter.of(context).go('/item_edit/$itemName');
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 33,
            child: Material(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SizedBox(
                width: 300.0,
                height: 70.0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        itemDescription,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Quantity: $itemQuantity',
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Category: $itemCategory',
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}