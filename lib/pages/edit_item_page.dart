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
    try {
      final itemData = await FirebaseFirestore.instance.collection('items').doc(widget.itemId).get();
      if (itemData.exists) {
        setState(() {
          nameController.text = itemData['name'];
          descController.text = itemData['description'];
          qtdController.text = itemData['quantity'].toString();
          selectedCategory = itemData['category'];
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item não encontrado!')));
      }
    } catch (e) { 
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao carregar item')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Item'),
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
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  const Text('Descrição'),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  const Text('Quantidade'),
                  TextField(
                    controller: qtdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  const Text('Categoria'),
                  CustomDropDownButtonComponent(
                    selected: selectedCategory,
                    items: ['Category 1', 'Category 2', 'Category 3'], 
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
    if (nameController.text.isEmpty || descController.text.isEmpty || qtdController.text.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, preencha todos os campos')));
      return;
    }
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