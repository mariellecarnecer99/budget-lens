import 'package:expense_tracker/pages/categories.dart';
import 'package:expense_tracker/pages/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'navbar.dart';

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
    return Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 80, bottom: 60),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(color: Colors.blue.shade800),
              child: Text(
                "Manage Settings",
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
                    "Currency",
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
                    "Categories",
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
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.blue.shade800),
        onTap: onTap,
      ),
    );
  }

  void showTransactionForm(BuildContext context) {
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

    List<String> categories = [
      'Food & Drinks',
      'Utilities',
      'Shopping',
      'Groceries',
      'Transport'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                        'Add Transaction',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: transactionNameController,
                            decoration: InputDecoration(
                                labelText: 'Transaction name',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter details';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: transactionAmountController,
                            decoration: InputDecoration(
                                labelText: 'Transaction Amount',
                                prefixText: '\$',
                                border: OutlineInputBorder()),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter amount';
                              }
                              if (double.tryParse(value.replaceAll(
                                      RegExp(r'[^\d.]'), '')) ==
                                  null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: transactionDateController,
                            decoration: InputDecoration(
                              labelText: 'Transaction Date',
                              hintText: 'YYYY-MM-DD',
                              border: OutlineInputBorder(),
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
                                return 'Please enter a transaction date';
                              }

                              RegExp dateRegExp =
                                  RegExp(r'^\d{4}-\d{2}-\d{2}$');
                              if (!dateRegExp.hasMatch(value)) {
                                return 'Please enter a valid date (YYYY-MM-DD)';
                              }

                              try {
                                DateTime.parse(value);
                              } catch (e) {
                                return 'Please enter a valid date (YYYY-MM-DD)';
                              }

                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: transactionCategory,
                            decoration: InputDecoration(
                                labelText: 'Transaction Category',
                                border: OutlineInputBorder()),
                            items: categories
                                .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              transactionCategory = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: transactionNotesController,
                            decoration: InputDecoration(
                                labelText: 'Transaction Notes',
                                border: OutlineInputBorder()),
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter notes';
                              }
                              return null;
                            },
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            String transactionName =
                                transactionNameController.text;
                            String transactionAmount =
                                transactionAmountController.text;
                            String transactionNotes =
                                transactionNotesController.text;
                            String transactionCat =
                                transactionCategory ?? 'None';
                            String transactionDate =
                                transactionDateController.text;

                            DateTime? date = DateTime.tryParse(transactionDate);
                            String formattedDate = '';
                            if (date != null) {
                              formattedDate =
                                  DateFormat('dd MMM yy').format(date);
                            }

                            print('Transaction Name: $transactionName');
                            print('Transaction Amount: $transactionAmount');
                            print('Transaction Date: $formattedDate');
                            print('Transaction Category: $transactionCat');
                            print('Transaction Notes: $transactionNotes');

                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
