import 'package:calculator_app/history_db.dart';
import 'package:flutter/material.dart';

class CalculatorHomeScreen extends StatefulWidget {
  const CalculatorHomeScreen({super.key});

  @override
  State<CalculatorHomeScreen> createState() => _CalculatorHomeScreenState();
}

class _CalculatorHomeScreenState extends State<CalculatorHomeScreen> {
  String display = '0';
  String? firstNumber;
  String? operator;
  bool startNewNumber = false;

  final buttons = [
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    '*',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '⌫',
    '=',
    '+',
  ];

  void onButtonTap(String value) {
    if (value == 'C') {
      setState(() {
        display = '0';
        firstNumber = null;
        operator = null;
        startNewNumber = false;
      });
      return;
    }

    if (value == '⌫') {
      setState(() {
        if (startNewNumber || display.length <= 1 || display == '-') {
          display = '0';
          startNewNumber = false;
        } else {
          display = display.substring(0, display.length - 1);
        }
      });
      return;
    }

    if (value == '+' || value == '-' || value == '*' || value == '/') {
      setState(() {
        firstNumber = display;
        operator = value;
        startNewNumber = true;
      });
      return;
    }

    if (value == '=') {
      calculate();
      return;
    }

    setState(() {
      if (startNewNumber || display == '0') {
        display = value;
        startNewNumber = false;
      } else {
        display += value;
      }
    });
  }

  Future<void> calculate() async {
    if (firstNumber == null || operator == null) return;

    final a = double.parse(firstNumber!);
    final b = double.parse(display);
    double result;
    String resultText = '';
    if (operator == '+') {
      result = a + b;
      resultText = result.toInt().toString();
    } else if (operator == '-') {
      result = a - b;
      resultText = result.toInt().toString();
    } else if (operator == '*') {
      result = a * b;
      resultText = result.toInt().toString();
    } else {
      result = b == 0 ? 0 : a / b;
      if ((result - (result.toInt())) == 0) {
        resultText = result.toInt().toString();
      } else {
        resultText = result.toString();
      }
    }

    final formula = '$firstNumber $operator $display';

    setState(() {
      display = resultText;
      firstNumber = null;
      operator = null;
      startNewNumber = true;
    });

    await saveHistory(formula, resultText);
  }

  Widget buildKey(String value, {double aspect = 1}) {
    final isOperator = ['+', '-', '*', '/', '='].contains(value);
    final isUtility = ['C', '⌫'].contains(value);
    final bgColor = isOperator
        ? const Color(0xFFFF9500)
        : isUtility
        ? Colors.grey[300]
        : Colors.grey[850];
    final textColor = isUtility ? Colors.black : Colors.white;

    final shape = (value == '0' || value == 'C' || value == '⌫')
        ? const StadiumBorder()
        : const CircleBorder();

    return AspectRatio(
      aspectRatio: aspect,
      child: ElevatedButton(
        onPressed: () => onButtonTap(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: shape,
          padding: EdgeInsets.zero,
          elevation: 2,
        ),
        child: Center(
          child: Text(value, style: TextStyle(fontSize: 28, color: textColor)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Calculator', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              alignment: Alignment.bottomRight,
              child: Text(
                display,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: buildKey('7')),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('8')),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('9')),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('/')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: buildKey('4')),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('5')),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('6')),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('*')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: buildKey('1')),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('2')),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('3')),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('-')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(flex: 2, child: buildKey('0', aspect: 2.4)),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('=')),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('+')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: buildKey('C', aspect: 2.4)),
                      const SizedBox(width: 12),
                      Expanded(child: buildKey('⌫', aspect: 2.4)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final rows = await getHistory();
      if (!mounted) return;
      setState(() {
        history = rows;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.history), SizedBox(width: 8), Text('History')],
        ),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? const Center(child: Text('No calculations yet'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  title: Text('${item['formula']}'),
                  subtitle: Text('= ${item['result']}'),
                );
              },
            ),
    );
  }
}
