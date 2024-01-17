// import 'package:cryptocalc/main_screen/Model/ExchangeModel.dart';
import 'package:cryptocalc/main_screen/widget/exchangeControlsWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputAmountWidget extends StatefulWidget {
  const InputAmountWidget({super.key});

  @override
  InputAmountWidgetState createState() => InputAmountWidgetState();
}

class InputAmountWidgetState extends State<InputAmountWidget> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onChanged: (String value) => context
          .read<ExchangeModel>()
          .setAmount(double.tryParse(value) ?? 1.0),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
