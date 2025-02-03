import 'package:expense_tracker/providers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/generated/l10n.dart';

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
    {"name": "CNY", "icon": Icons.currency_yen},
    {"name": "PHP", "icon": '₱'},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCurrencyIcon  = context.watch<CurrencyProvider>().selectedCurrencyIcon;
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.selectCurrency),
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
                SizedBox(width: 8),  // Add some space between the icon and the name
                Text(
                  currency['name'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            trailing: selectedCurrencyIcon == currency['icon']
                ? Icon(Icons.check_circle, color: Colors.blue.shade800)
                : null,
            onTap: () {
              context.read<CurrencyProvider>().selectCurrency(currency['icon']);
              Navigator.pop(context, currency['icon']);
            },
          );
        }).toList(),
      ),
    );
  }
}
