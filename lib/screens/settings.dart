import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transactions.dart';
import 'package:expense_tracker/providers/currency_provider.dart';
import 'package:expense_tracker/screens/account_management/list.dart';
import 'package:expense_tracker/screens/categories.dart';
import 'package:expense_tracker/screens/currency.dart';
import 'package:expense_tracker/screens/language.dart';
import 'package:expense_tracker/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'navbar.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/generated/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  int selectedIndex = 0;
  List<String> currencies = [
    'USD - United States Dollar',
    'EUR - Euro',
    'GBP - British Pound',
    'INR - Indian Rupee',
    'JPY - Japanese Yen',
    'PHP - Philippine Peso',
  ];

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 80, bottom: 60),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(color: Colors.blue.shade800),
              child: Text(
                localization.manageSettings,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  buildListTile(
                    localization.currency,
                    Icons.currency_exchange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CurrencyPage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.blue.shade800,
                  ),
                  buildListTile(
                    localization.categories,
                    Icons.category,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesPage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.blue.shade800,
                  ),
                  buildListTile(
                    localization.language,
                    Icons.language,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LanguagePage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.blue.shade800,
                  ),
                  buildListTile(
                    localization.accountManagement,
                    Icons.account_box,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountManagementList()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.blue.shade800,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: CustomFloatingActionButton(
          onPressed: () => showTransactionForm(context),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ));
  }

  Widget buildListTile(String title, IconData icon, Function() onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade800),
        title: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.blue.shade800),
        onTap: onTap,
      ),
    );
  }

  void showTransactionForm(BuildContext context) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Category> categories = await dbHelper.getCategories();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController transactionNameController =
        TextEditingController();
    final TextEditingController transactionAmountController =
        TextEditingController();
    final TextEditingController transactionNotesController =
        TextEditingController();
    final TextEditingController transactionDateController =
        TextEditingController();
    DateTime? transactionDate;
    String? transactionCategory;
    String? transactionType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final selectedCurrencyIcon =
            context.watch<CurrencyProvider>().selectedCurrencyIcon;
        final localization = S.of(context);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localization.addTransaction,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: transactionNameController,
                          decoration: InputDecoration(
                            hintText: localization.transactionName,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.pleaseEnterDetails;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: transactionAmountController,
                          decoration: InputDecoration(
                            hintText: localization.transactionAmount,
                            prefixText: selectedCurrencyIcon is String
                                ? selectedCurrencyIcon
                                : null,
                            prefixIcon: selectedCurrencyIcon is IconData
                                ? Icon(selectedCurrencyIcon)
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.pleaseEnterAmount;
                            }
                            if (double.tryParse(
                                    value.replaceAll(RegExp(r'[^\d.]'), '')) ==
                                null) {
                              return localization.pleaseEnterAValidNumber;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: transactionDateController,
                          decoration: InputDecoration(
                            hintText: localization.transactionDate,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      transactionDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                  transactionDate = picked;
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(transactionDate!);
                                  transactionDateController.text =
                                      formattedDate;
                                }
                              },
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.pleaseEnterTransactionDate;
                            }
                            RegExp dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                            if (!dateRegExp.hasMatch(value)) {
                              return localization.pleaseEnterValidDate;
                            }
                            try {
                              DateTime.parse(value);
                            } catch (e) {
                              return localization.pleaseEnterValidDate;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: transactionCategory,
                          decoration: InputDecoration(
                            hintText: localization.transactionCategory,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          items: categories
                              .map((category) => DropdownMenuItem<String>(
                                    value: category.name,
                                    child: Text(category.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            transactionCategory = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.pleaseSelectCategory;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: transactionType,
                          decoration: InputDecoration(
                            hintText: localization.transactionType,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          items: [localization.expense, localization.income]
                              .map((type) => DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              transactionType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.pleaseEnterTransactionType;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: transactionNotesController,
                          decoration: InputDecoration(
                            hintText: localization.transactionNotes,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.pleaseEnterNotes;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          localization.cancel,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            String transactionName =
                                transactionNameController.text;
                            String transactionAmountStr =
                                transactionAmountController.text;
                            String transactionNotes =
                                transactionNotesController.text;
                            String transactionCat =
                                transactionCategory ?? 'None';
                            String transactionDate =
                                transactionDateController.text;
                            String transactionTypeCat =
                                transactionType ?? 'None';

                            double transactionAmount = double.tryParse(
                                    transactionAmountStr.replaceAll(
                                        RegExp(r'[^\d.]'), '')) ??
                                0.0;

                            DateTime? date = DateTime.tryParse(transactionDate);
                            String formattedDate = '';
                            if (date != null) {
                              formattedDate =
                                  DateFormat('yyyy-MM-dd').format(date);
                            }

                            Transactions newTransaction = Transactions(
                                transactionName: transactionName,
                                amount: transactionAmount,
                                date: formattedDate,
                                categoryName: transactionCat,
                                notes: transactionNotes,
                                transactionType: transactionTypeCat);

                            DatabaseHelper dbHelper = DatabaseHelper();
                            await dbHelper.insertTransaction(newTransaction);

                            Navigator.of(context).pop();
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: Colors.blue.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          localization.submit,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
