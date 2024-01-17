import 'package:cryptocalc/main_screen/widget/exchangeControlsWidget.dart';
import 'package:cryptocalc/main_screen/widget/exchangeWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( ChangeNotifierProvider(
    create: (context) => ExchangeModel(),
    child: const MyApp(),
  )
);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExchangFullScreenWidget(),
    );
  }
}
