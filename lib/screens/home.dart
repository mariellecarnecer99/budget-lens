import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transactions.dart';
import 'package:expense_tracker/screens/analytics.dart';
import 'package:expense_tracker/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'navbar.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                  children: const [
                    Text(
                      "BudgetLens",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "Your financial snapshot",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withValues(alpha: 0.1)),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
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
                        text: "Top spends ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: "Breakdown",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ))
                    ])),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnalyticsPage()),
                    );
                  },
                  child: Text(
                    "View Insights",
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
            child: Row(
              children: [
                buildTopSpendsChart("FOOD & DRINKS", Color(0xFFFF3AF2), .3),
                const SizedBox(
                  width: 2,
                ),
                buildTopSpendsChart("UTILITIES", Colors.red, .25),
                const SizedBox(
                  width: 2,
                ),
                buildTopSpendsChart("GROCERIES", Color(0xFFFFC300), .20),
                const SizedBox(
                  width: 2,
                ),
                buildTopSpendsChart("SHOPPING", Color(0xFF6E1BFF), .23),
              ],
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
                  return Center(child: Text('No transactions available.'));
                }

                final transactions = snapshot.data!;

                return ListView(
                  padding: EdgeInsets.all(25),
                  children: [
                    const Text(
                      "Cash Flow",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        buildCashFlowColumn(Icons.account_balance_wallet,
                            "Income", DatabaseHelper().getTotalIncome()),
                        SizedBox(width: availableScreenWidth * .03),
                        buildCashFlowColumn(Icons.monetization_on, "Balance",
                            DatabaseHelper().getBalance()),
                        SizedBox(width: availableScreenWidth * .03),
                        buildCashFlowColumn(Icons.payments, "Expense",
                            DatabaseHelper().getTotalExpenses())
                      ],
                    ),
                    Divider(height: 60),
                    Row(
                      children: [
                        Text(
                          "Transaction History",
                          style: TextStyle(
                              color: Colors.black,
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
                          "\$${transaction.amount.toStringAsFixed(2)}");
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
                    return Text(
                      snapshot.data!.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    );
                  } else {
                    return Text(
                      'No data available',
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
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.blue.shade800),
                onSelected: (value) {
                  if (value == 'edit') {
                  } else if (value == 'delete') {
                    showDeleteConfirmationDialog(context, id);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            )
          ],
        ));
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
                            labelText: 'Transaction Name',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
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
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            prefixText: '\$',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
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
                              return 'Please enter amount';
                            }
                            if (double.tryParse(
                                    value.replaceAll(RegExp(r'[^\d.]'), '')) ==
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
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
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
                              return 'Please enter a transaction date';
                            }
                            RegExp dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
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
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
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
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: transactionType,
                          decoration: InputDecoration(
                            labelText: 'Transaction Type',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
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
                              return 'Please select a transaction type';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: transactionNotesController,
                          decoration: InputDecoration(
                            labelText: 'Transaction Notes',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
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
                          'Cancel',
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
                                  DateFormat('dd MMM yy').format(date);
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
                          'Submit',
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
        return AlertDialog(
          title: Text(
            'Confirm Deletion',
            style: TextStyle(fontSize: 24, color: Colors.blue.shade800),
          ),
          content: Text(
            'Are you sure you want to delete this transaction?',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                await deleteTransaction(id);
                Navigator.of(context).pop();
              },
              child: Text('Yes',
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
}
