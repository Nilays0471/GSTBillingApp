import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> _products = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  double _gstRate = 5.0;

  void _addProduct() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;

    if (name.isNotEmpty && price > 0) {
      setState(() {
        _products.add(Product(name: name, price: price, gstRate: _gstRate));
        _nameController.clear();
        _priceController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = _products.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('GST Billing App')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<double>(
              value: _gstRate,
              items:
                  [5, 12, 18, 28]
                      .map(
                        (rate) => DropdownMenuItem(
                          value: rate.toDouble(),
                          child: Text('$rate%'),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _gstRate = value!),
            ),
            ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Add Product'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                      'Price: ₹${product.price.toStringAsFixed(2)}, GST: ${product.gstRate}%, CGST: ₹${product.cgst.toStringAsFixed(2)}, SGST: ₹${product.sgst.toStringAsFixed(2)}',
                    ),
                    trailing: Text('₹${product.totalPrice.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Text(
              'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
