import 'package:flutter/material.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => CurrencyPageState();
}

class CurrencyPageState extends State<CurrencyPage> {
  final List<Map<String, String>> currencies = [
    {"name": "USD", "icon": "💵"},
    {"name": "EUR", "icon": "💶"},
    {"name": "GBP", "icon": "💷"},
    {"name": "INR", "icon": "₹"},
    {"name": "JPY", "icon": "¥"},
  ];

  String? selectedCurrency;

  void selectCurrency(String currency) {
    setState(() {
      selectedCurrency = currency;
    });
  }

  void onDone() {
    if (selectedCurrency != null) {
      Navigator.pop(context, selectedCurrency);
    }
  }

  void onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Currency"),
      ),
      body: ListView(
        children: currencies.map((currency) {
          return ListTile(
            title: Text('${currency['icon']} ${currency['name']}'),
            trailing: selectedCurrency == currency['name']
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
            onTap: () => selectCurrency(currency['name']!),
          );
        }).toList(),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
