import 'package:flutter/material.dart';
import 'Model/Gift.dart';

class GiftDetailsPage extends StatefulWidget {
  final Gift gift;

  GiftDetailsPage({required this.gift});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  late Gift gift;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    gift = widget.gift;
    _nameController = TextEditingController(text: gift.name);
    _descriptionController = TextEditingController(text: gift.description);
    _categoryController = TextEditingController(text: gift.category ?? '');
    _priceController = TextEditingController(text: gift.price?.toString() ?? '0.0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${gift.name} - Gift Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Gift Name"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            ElevatedButton(
              onPressed: _saveGift,
              child: const Text("Save Gift"),
            ),
          ],
        ),
      ),
    );
  }

  void _saveGift() {
    setState(() {
      gift = gift.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        price: double.tryParse(_priceController.text),
      );
    });
    Navigator.pop(context, gift); // Pass updated gift back to previous page
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
