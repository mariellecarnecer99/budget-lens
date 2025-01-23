import 'package:flutter/material.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => CurrencyPageState();
}

class CurrencyPageState extends State<CurrencyPage> {
  final List<Map<String, dynamic>> currencies = [
    {"name": "USD", "icon": Icons.attach_money},
    {"name": "EUR", "icon": Icons.euro_symbol},
    {"name": "GBP", "icon": Icons.currency_pound},
    {"name": "INR", "icon": Icons.currency_rupee},
    {"name": "JPY", "icon": Icons.currency_yuan},
    {"name": "PHP", "icon": '₱'},
  ];

  String? selectedCurrency;

  @override
  void initState() {
    super.initState();
    selectedCurrency = 'PHP';
  }

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
            title: Row(
              children: [
                currency['icon'] is IconData
                    ? Icon(
                        currency['icon'],
                        color: Colors.blue,
                        size: 25,
                      )
                    : Text(
                        currency['icon'],
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                        ),
                      ),
                SizedBox(width: 8),
                Text(currency['name']),
              ],
            ),
            trailing: selectedCurrency == currency['name']
                ? Icon(Icons.check_circle, color: Colors.blue.shade800)
                : null,
            onTap: () => selectCurrency(currency['name']!),
          );
        }).toList(),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: CircleBorder(),
                padding: EdgeInsets.all(16),
              ),
              child: Icon(
                Icons.close,
                color: Colors.red,
                size: 28,
              ),
            ),
            ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: CircleBorder(),
                padding: EdgeInsets.all(16),
              ),
              child: Icon(
                Icons.check,
                color: Colors.green,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
