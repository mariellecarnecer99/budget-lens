import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transactions.dart';
import 'package:expense_tracker/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'navbar.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => AnalyticsPageState();
}

class AnalyticsPageState extends State<AnalyticsPage> {
  int touchedIndex = 0;
  int selectedIndex = 0;
  List<Color> gradientColors = [
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
  ];

  bool showAvg = false;

  List<Map<String, dynamic>> categorySpendings = [];
  double totalSpending = 0.0;
  String? touchedCategory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper().fetchCategorySpending();

    totalSpending =
        result.fold(0.0, (sum, item) => sum + item['total_spending']);

    setState(() {
      categorySpendings = result;
    });
  }

  List<PieChartSectionData> showingSections() {
    return categorySpendings.map((category) {
      double percentage = (category['total_spending'] / totalSpending) * 100;
      bool isTouched = category['category'] == touchedCategory;
      double fontSize = isTouched ? 20.0 : 16.0;
      double radius = isTouched ? 110.0 : 100.0;
      double widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: getCategoryColor(category['category']),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: _Badge(
          getCategoryIcon(category['category']),
          size: widgetSize,
          borderColor: Colors.black,
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
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

  IconData getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Food':
        return Icons.fastfood;
      case 'Transport':
        return Icons.directions_car;
      case 'Groceries':
        return Icons.local_grocery_store;
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Electronics':
        return Icons.devices;
      default:
        return Icons.category;
    }
  }

  Widget indicatorWithColor(String category, Color color, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8),
            Text(
              category,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: categorySpendings.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(children: [
              Container(
                padding: const EdgeInsets.only(top: 80),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(color: Colors.blue.shade800),
                child: Text(
                  "Analytics",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 25, bottom: 0, left: 25, right: 25),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(color: Colors.blue.shade800),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Top spending categories ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text("Week",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                            SizedBox(width: 10),
                            Text("Month",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                            SizedBox(width: 10),
                            Text("Year",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      ],
                    ),
                  )),
              Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(color: Colors.blue.shade800),
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedCategory = null;
                                return;
                              }
                              touchedCategory = categorySpendings[
                                  pieTouchResponse.touchedSection!
                                      .touchedSectionIndex]['category'];
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: showingSections(),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 27),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(color: Colors.blue.shade800),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: categorySpendings.map((category) {
                    double percentage =
                        (category['total_spending'] / totalSpending) * 100;
                    return indicatorWithColor(category['category'],
                        getCategoryColor(category['category']), percentage);
                  }).toList(),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 25, bottom: 0, left: 25, right: 25),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Progress Rate ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text("Week",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                )),
                            SizedBox(width: 15),
                            Text("Month",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                )),
                            SizedBox(width: 15),
                            Text("Year",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ],
                    ),
                  )),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: AspectRatio(
                    aspectRatio: 1.90,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 25,
                        left: 25,
                        top: 24,
                      ),
                      child: LineChart(
                        showAvg ? avgData() : mainData(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                height: 34,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAvg = !showAvg;
                    });
                  },
                  child: Text(
                    'avg',
                    style: TextStyle(
                      fontSize: 12,
                      color: showAvg
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withValues(alpha: 0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.icon, {
    required this.size,
    required this.borderColor,
  });
  final IconData icon;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Icon(icon),
      ),
    );
  }
}
