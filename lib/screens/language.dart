import 'package:expense_tracker/providers/language_provider.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/generated/l10n.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => LanguagePageState();
}

class LanguagePageState extends State<LanguagePage> {
  final List<Map<String, String>> languages = [
    {"flag": "US", "language": "English", "code": "en"},
    {"flag": "ES", "language": "Spanish", "code": "es"},
    {"flag": "IN", "language": "Hindi", "code": "hi"},
    {"flag": "CN", "language": "Chinese", "code": "zh"},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedLanguage  = context.watch<LanguageProvider>().selectedLanguage;
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.selectLanguage),
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
            trailing: selectedLanguage == language['code']
                ? Icon(Icons.check_circle, color: Colors.blue.shade800)
                : null,
            onTap: () {
              context.read<LanguageProvider>().selectLanguage(language['code']!);
              Navigator.pop(context, language['code']);
            },
          );
        }).toList(),
      ),
    );
  }
}