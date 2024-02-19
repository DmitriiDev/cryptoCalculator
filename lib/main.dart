import 'dart:io';
import 'package:cryptocalc/crypto_coins/model/exchange_screen_coin_model.dart';
import 'package:cryptocalc/main_screen/widget/exchange_controls_widget.dart';
import 'package:cryptocalc/main_screen/widget/exchange_main_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

late Box box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ExchangeScreenCoinModelAdapter());
  box = await Hive.openBox<ExchangeScreenCoinModel>('exchangeScreenCoins');
  runApp(ChangeNotifierProvider(
    create: (context) => ExchangeModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
