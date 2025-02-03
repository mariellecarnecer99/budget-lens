import 'package:expense_tracker/generated/l10n.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transactions.dart';
import 'package:expense_tracker/providers/currency_provider.dart';
import 'package:expense_tracker/providers/theme_provider.dart';
import 'package:expense_tracker/screens/analytics.dart';
import 'package:expense_tracker/theme/custom_toggle_switch.dart';
import 'package:expense_tracker/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'navbar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double availableScreenWidth = 0;
  int selectedIndex = 0;
  List<Transactions> transactionList = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    availableScreenWidth = MediaQuery.of(context).size.width - 50;
    bool isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final localization = S.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            alignment: Alignment.bottomCenter,
            height: 170,
            decoration: BoxDecoration(color: Colors.blue.shade800),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BudgetLens",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      localization.tagLine,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    )
                  ],
                ),
                CustomToggleSwitch(
                  value: isDarkMode,
                  onChanged: (newValue) {
                    context.read<ThemeProvider>().toggleTheme();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(
                        text: "${localization.breakdown} ",
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                      TextSpan(
                          text: localization.breakdownSmallText,
                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                      )
                    ])),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnalyticsPage()),
                    );
                  },
                  child: Text(
                    localization.viewAnalytics,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper().fetchCategorySpending(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(localization.noData));
                }

                List<Map<String, dynamic>> data = snapshot.data!;

                double totalSpending =
                    data.fold(0.0, (sum, item) => sum + item['total_spending']);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: data.map((category) {
                      double percentage =
                          category['total_spending'] / totalSpending;
                      return Row(
                        children: [
                          buildTopSpendsChart(
                              category['category'],
                              getCategoryColor(category['category']),
                              percentage),
                          const SizedBox(width: 2),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<List<Transactions>>(
              future: DatabaseHelper().getTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(localization.noTransactions));
                }

                final transactions = snapshot.data!;

                return ListView(
                  padding: EdgeInsets.all(25),
                  children: [
                    Text(
                      localization.cashFlow,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        buildCashFlowColumn(Icons.account_balance_wallet,
                            localization.income, DatabaseHelper().getTotalIncome()),
                        SizedBox(width: availableScreenWidth * .03),
                        buildCashFlowColumn(Icons.monetization_on, localization.balance,
                            DatabaseHelper().getBalance()),
                        SizedBox(width: availableScreenWidth * .03),
                        buildCashFlowColumn(Icons.payments, localization.expense,
                            DatabaseHelper().getTotalExpenses())
                      ],
                    ),
                    Divider(height: 60),
                    Row(
                      children: [
                        Text(
                          localization.transactionHistory,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ...transactions.map((transaction) {
                      return buildTransactionRow(
                          transaction.id,
                          transaction.transactionName,
                          transaction.date,
                          transaction.categoryName,
                          transaction.amount.toStringAsFixed(2));
                    }),
                  ],
                );
              },
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
      ),
    );
  }

  Column buildTopSpendsChart(
      String title, Color color, double widthPercentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: availableScreenWidth * widthPercentage,
          height: 4,
          color: color,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Column buildCashFlowColumn(
      IconData icon, String category, Future<double> amount) {
    final selectedCurrencyIcon = context.watch<CurrencyProvider>().selectedCurrencyIcon;
    final localization = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: availableScreenWidth * .31,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: Colors.blue.shade800,
              ),
              SizedBox(height: 8),
              Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 4),
              FutureBuilder<double>(
                future: amount,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return Row(
                      children: [
                        selectedCurrencyIcon is IconData
                            ? Icon(
                          selectedCurrencyIcon,
                          color: Colors.blue.shade800,
                          size: 16,
                        )
                            : Text(
                          selectedCurrencyIcon,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        // SizedBox(width: 2),
                        Text(
                          snapshot.data!.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text(
                      localization.noData,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Container buildTransactionRow(int? id, String transactionName, String date,
      String categoryName, String amount) {
    final selectedCurrencyIcon = context.watch<CurrencyProvider>().selectedCurrencyIcon;
    final localization = S.of(context);
    return Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 85,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    getCategoryIcon(categoryName),
                    color: Colors.blue[200],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      transactionName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          categoryName,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                selectedCurrencyIcon is IconData
                    ? Icon(
                  selectedCurrencyIcon,
                  size: 18, color: Colors.black
                )
                    : Text(
                  selectedCurrencyIcon,
                  style: TextStyle(
                    fontSize: 18,
                      color: Colors.black
                  ),
                ),
                // SizedBox(width: 2),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.blue.shade800),
                onSelected: (value) async {
                  if (value == 'edit') {
                    DatabaseHelper dbHelper = DatabaseHelper();
                    Transactions? selectedTransaction =
                        await dbHelper.getTransactionById(id);
                    showTransactionForm(context,
                        transaction: selectedTransaction);
                  } else if (value == 'delete') {
                    showDeleteConfirmationDialog(context, id);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text(localization.edit),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(localization.delete),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void showTransactionForm(BuildContext context,
      {Transactions? transaction}) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Category> categories = await dbHelper.getCategories();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController transactionNameController =
        TextEditingController(text: transaction?.transactionName ?? '');
    final TextEditingController transactionAmountController =
        TextEditingController(
            text: transaction?.amount.toStringAsFixed(2) ?? '');
    final TextEditingController transactionNotesController =
        TextEditingController(text: transaction?.notes ?? '');
    final TextEditingController transactionDateController =
        TextEditingController(text: transaction?.date ?? '');

    String? transactionCategory = transaction?.categoryName;
    String? transactionType = transaction?.transactionType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final selectedCurrencyIcon = context.watch<CurrencyProvider>().selectedCurrencyIcon;
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
                        transaction == null
                            ? localization.addTransaction
                            : localization.editTransaction,
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
                            prefixText: selectedCurrencyIcon is String ? selectedCurrencyIcon : null,
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
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(picked);
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
                          items: ['Expense', 'Income']
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
                            if (transaction == null) {
                              await dbHelper.insertTransaction(newTransaction);
                            } else {
                              Transactions updatedTransaction = Transactions(
                                id: transaction.id,
                                transactionName: newTransaction.transactionName,
                                amount: newTransaction.amount,
                                date: newTransaction.date,
                                categoryName: newTransaction.categoryName,
                                notes: newTransaction.notes,
                                transactionType: newTransaction.transactionType,
                              );
                              await dbHelper
                                  .updateTransaction(updatedTransaction);
                            }
                            loadTransactions();

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

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'shopping':
        return Icons.shopping_cart;
      case 'groceries':
        return Icons.local_grocery_store;
      case 'food':
        return Icons.fastfood;
      case 'transport':
        return Icons.directions_car;
      case 'electronics':
        return Icons.devices;
      case 'salary':
      case 'earnings':
        return Icons.work;
      default:
        return Icons.category;
    }
  }

  void showDeleteConfirmationDialog(BuildContext context, int? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final localization = S.of(context);
        return AlertDialog(
          title: Text(
            localization.confirmDeletion,
            style: TextStyle(fontSize: 24, color: Colors.blue.shade800),
          ),
          content: Text(
            localization.areYouSure,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                localization.no,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                await deleteTransaction(id);
                Navigator.of(context).pop();
              },
              child: Text(localization.yes,
                  style: TextStyle(fontSize: 16, color: Colors.blue.shade800)),
            ),
          ],
        );
      },
    );
  }

  deleteTransaction(id) async {
    var dbHelper = DatabaseHelper();
    Transactions? transactionToDelete;

    try {
      transactionToDelete = transactionList.firstWhere(
        (transaction) => transaction.id == id,
      );
    } catch (e) {
      return;
    }

    await dbHelper.deleteTransaction(transactionToDelete.id!);

    setState(() {
      transactionList.removeWhere((transaction) => transaction.id == id);
    });

    loadTransactions();
  }

  void loadTransactions() async {
    var dbHelper = DatabaseHelper();
    List<Transactions> transactionsFromDb = await dbHelper.getTransactions();

    setState(() {
      transactionList = transactionsFromDb;
    });
  }

  Color getCategoryColor(String categoryName) {
    switch (categoryName) {
      case 'Food':
        return Color(0xFFFF3AF2);
      case 'Transport':
        return Colors.red;
      case 'Groceries':
        return Color(0xFFFFC300);
      case 'Shopping':
        return Color(0xFF6E1BFF);
      case 'Electronics':
        return Color.fromARGB(255, 150, 114, 37);
      default:
        return Colors.grey;
    }
  }
}
