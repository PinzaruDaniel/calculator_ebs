import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}


class _CalculatorScreenState extends State<CalculatorScreen> {

    late TextEditingController _expressionController;
    String formatNumber(String input) {
  if (input.isEmpty) return '';
  final number = double.tryParse(input.replaceAll(',', ''));
  if (number == null) return input;
  final formatter = NumberFormat("#,###.########");
  return formatter.format(number);
}

  @override
  void initState() {
    super.initState();
    _expressionController = TextEditingController();
  }

  @override
  void dispose() {
    _expressionController.dispose();
    super.dispose();
  }
  String number1 ="";
  String number2 ="";
  String operand = "";
  String expressionDisplay = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 60,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            expressionDisplay,
                            style: const TextStyle(
                              fontSize: 52,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 55,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            formatNumber(number1),
                            style: const TextStyle(
                              fontSize: 60,
                              color: Colors.grey,
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton(Btn.clr),
                      buildButton(""),
                      buildButton(Btn.del),
                      buildButton(Btn.divide),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton("7"),
                      buildButton("8"),
                      buildButton("9"),
                      buildButton(Btn.multiply),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton("4"),
                      buildButton("5"),
                      buildButton("6"),
                      buildButton(Btn.subtract),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton("1"),
                      buildButton("2"),
                      buildButton("3"),
                      buildButton(Btn.add),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton(""),
                      buildButton("0"),
                      buildButton(Btn.dot),
                      buildButton(Btn.calculate),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      );
    }
    
  Widget buildButton(String value) {
    final isOperator = [
      Btn.add,
      Btn.subtract,
      Btn.multiply,
      Btn.divide,
      Btn.calculate,
    ].contains(value);

    return Padding(
  padding: const EdgeInsets.all(6.0),
  child: SizedBox(
    width: 80,  
    height: 100, 
    child: ElevatedButton(
      onPressed: () => onBtnTap(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: value == Btn.calculate ? Colors.teal : Colors.transparent,
        foregroundColor: value == Btn.calculate
            ? Colors.white
            : value == Btn.clr
                ? Colors.red
                : isOperator
                    ? Colors.teal
                    : Colors.grey[600],
        shadowColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        padding: const EdgeInsets.all(20), 
      ),
      child: value == Btn.del
          ? const Icon(Icons.backspace_outlined, size: 26, color: Colors.teal)
          : Text(
              value,
              style: const TextStyle(
                fontSize: 32, 
              ),
            ),
    ),
  ),
);
  }

void onBtnTap(String value) {
  if(value==Btn.del){
    delete();
    return;
  }

  if(value==Btn.clr){
    clearAll();
    return;
  }

  if(value==Btn.calculate){
    calculate();
    return;
  }

  appendValue(value);
}

void calculate() {
  if (number1.isEmpty || number2.isEmpty || operand.isEmpty) return;

  final double num1 = double.parse(number1);
  final double num2 = double.parse(number2);

  var result = 0.0;
  switch (operand) {
    case Btn.add:
      result = num1 + num2;
      break;
    case Btn.subtract:
      result = num1 - num2;
      break;
    case Btn.multiply:
      result = num1 * num2;
      break;
    case Btn.divide:
      result = num1 / num2;
      break;
    default:
      return;
  }

  setState(() {
    number1 = result.toString();
    if (number1.endsWith(".0")) {
      number1 = number1.substring(0, number1.length - 2);
    }
    number2 = "";
    operand = "";
    
  });
}

void clearAll() {
  setState(() {
    number1 = "";
    number2 = "";
    operand = "";
    _expressionController.text = "";
  });
}
void delete() {
  if (number2.isNotEmpty) {
    number2 = number2.substring(0, number2.length - 1);
  } else if (operand.isNotEmpty) {
    operand = "";
  } else if (number1.isNotEmpty) {
    number1 = number1.substring(0, number1.length - 1);
  }
  setState(() {
    _expressionController.text = "$number1 $operand $number2";
  });
}

void appendValue(String value){
  if(value!=Btn.dot && int.tryParse(value)==null){
    if(operand.isNotEmpty && number2.isNotEmpty){
      calculate();
    }
    operand=value;
  }
  else if(number1.isEmpty|| operand.isEmpty){
    if(value==Btn.dot && number1.contains(Btn.dot)) return;
    if(value==Btn.dot && (number1.isEmpty || number1==Btn.n0)){
      value="0.";
    }
    number1 += value;
  }
  else if(number2.isEmpty || operand.isNotEmpty){
    if(value==Btn.dot && number2.contains(Btn.dot)) return;
    if(value==Btn.dot && (number2.isEmpty || number2==Btn.n0)){
      value="0.";
    }
    number2 += value;
  }
  expressionDisplay = "${formatNumber(number1)} $operand ${formatNumber(number2)}";
  setState(() {});
}
}