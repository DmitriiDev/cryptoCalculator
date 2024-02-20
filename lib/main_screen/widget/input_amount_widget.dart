import 'package:cryptocalc/main_screen/widget/exchange_controls_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputAmountWidget extends StatefulWidget {
  const InputAmountWidget({super.key});

  @override
  InputAmountWidgetState createState() => InputAmountWidgetState();
}

class InputAmountWidgetState extends State<InputAmountWidget> {
  final TextEditingController _textController = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: _textController,
        textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold), // Set the font size
          decoration: const InputDecoration(border: InputBorder.none),
          onChanged: (String value) {
            context
                .read<ExchangeModel>()
                .setAmount(double.tryParse(value) ?? 1.0);
          }),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
