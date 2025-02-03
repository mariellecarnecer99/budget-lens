import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => LanguagePageState();
}

class LanguagePageState extends State<LanguagePage> {
  final List<Map<String, String>> languages = [
    {"flag": "US", "language": "English"},
    {"flag": "ES", "language": "Spanish"},
    {"flag": "IN", "language": "Hindi"},
    {"flag": "CN", "language": "Chinese"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Language"),
      ),
      body: ListView(
        children: languages.map((language) {
          return ListTile(
            title: Text(language['language']!, style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
            )),
            leading: Flag.fromString(
              language['flag']!,
              height: 30.0,
              width: 50.0,
            ),
            // onTap: () {
            //   context.read<CurrencyProvider>().selectCurrency(currency['icon']);
            //   Navigator.pop(context, currency['icon']);
            // },
          );
        }).toList(),
      ),
    );
  }
}