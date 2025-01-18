import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:userapp/components/custom_text_field.dart';
import 'package:userapp/resources/text_style.dart';
import 'package:userapp/services/firestore_methods.dart';

import '../components/rounded_background_component.dart';

class ItemRegisterPage extends StatefulWidget {
  const ItemRegisterPage({super.key});

  @override
  State<ItemRegisterPage> createState() => _ItemRegisterPageState();
}

class _ItemRegisterPageState extends State<ItemRegisterPage> {

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/bar_state');
          },
        ),
        title: const Text(
          'Criar nova necessidade',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: const Color.fromARGB(255, 3, 32, 106),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: RoundedBackgroundComponent(
        height: MediaQuery.of(context).size.height * 0.02,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DonationItemComponent(),
                Row(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropDownButtonComponent extends StatelessWidget {
  final String? selected;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  const CustomDropDownButtonComponent({
    super.key,
    required this.selected,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selected,
      hint: Text(hint),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}


class DonationItemComponent extends StatefulWidget {
  const DonationItemComponent({super.key});

  @override
  State<DonationItemComponent> createState() => _DonationItemComponentState();
}

class _DonationItemComponentState extends State<DonationItemComponent> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtdController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String? selectedCategory;
  final List<String> categories = ['Alimento', 'Eletrônico', 'Vestimenta', 'Higiene', 'Outros'];
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  @override
  void dispose() {
    nameController.dispose();
    qtdController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> registerItem() async {
    if (selectedCategory == null || nameController.text.isEmpty || qtdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos obrigatórios")),
      );
      return;
    }

    try {
      await _firestoreMethods.registerNewItem(
        name: nameController.text,
        quantity: qtdController.text,
        category: selectedCategory!,
        description: descController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item registrado com sucesso")),
      );

      GoRouter.of(context).go('/bar_state');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao registrar item: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nome do produto'),
        CustomTextField(type: TextInputType.name, controller: nameController),
        const SizedBox(height: 20),
        const Text('Descrição'),
        CustomTextField(type: TextInputType.multiline, controller: descController),
        const SizedBox(height: 20),
        const Text('Categoria e Quantidade'),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomDropDownButtonComponent(
                selected: selectedCategory,
                items: categories,
                hint: 'Selecione uma opção',
                onChanged: (item) {
                  setState(() {
                    selectedCategory = item;
                  });
                },
              ),
            ),
            Flexible(
              child: CustomTextField(
                controller: qtdController,
                type: TextInputType.number,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 180.0),
            child: SizedBox(
              height: 70,
              width: 400,
              child: ElevatedButton(
                onPressed: registerItem, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
