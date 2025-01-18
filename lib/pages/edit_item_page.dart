import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditItemPage extends StatefulWidget {
  final String itemId;

  const EditItemPage({super.key, required this.itemId});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController qtdController = TextEditingController();
  String? selectedCategory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItemData();
  }

  void fetchItemData() async {
    final itemData = await FirebaseFirestore.instance.collection('items').doc(widget.itemId).get();
    setState(() {
      nameController.text = itemData['name'];
      descController.text = itemData['description'];
      qtdController.text = itemData['quantity'].toString();
      selectedCategory = itemData['category'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nome do produto'),
                  TextField(
                    controller: nameController,
                  ),
                  const SizedBox(height: 20),
                  const Text('Descrição'),
                  TextField(
                    controller: descController,
                  ),
                  const SizedBox(height: 20),
                  const Text('Quantidade'),
                  TextField(
                    controller: qtdController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  const Text('Categoria'),
                  CustomDropDownButtonComponent(
                    selected: selectedCategory,
                    items: ['Category 1', 'Category 2', 'Category 3'], // Example categories
                    hint: 'Selecione uma opção',
                    onChanged: (item) {
                      setState(() {
                        selectedCategory = item;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      saveItem();
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ),
    );
  }

  void saveItem() async {
    await FirebaseFirestore.instance.collection('items').doc(widget.itemId).update({
      'name': nameController.text,
      'description': descController.text,
      'quantity': int.parse(qtdController.text),
      'category': selectedCategory,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item atualizado!')));
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    qtdController.dispose();
    super.dispose();
  }
}

class CustomDropDownButtonComponent extends StatelessWidget {
  final String? selected;
  final List<String?> items;
  final String hint;
  final void Function(String?)? onChanged;

  const CustomDropDownButtonComponent({
    super.key,
    required this.selected,
    required this.items,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: selected,
      hint: Text(hint),
      items: items.map((String? item) {
        return DropdownMenuItem<String?>(
          value: item,
          child: Text(item ?? ''),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}