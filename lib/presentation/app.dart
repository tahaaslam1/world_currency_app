import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_currency_app/logger.dart';
import 'package:world_currency_app/presentation/screens/home_screen/home_screen.dart';
import 'package:world_currency_app/provider/currency_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CurrencyProvider _countryProvider;

  @override
  void initState() {
    _countryProvider = Provider.of<CurrencyProvider>(context, listen: false);
    _countryProvider.loadCurrencies().then((value) {
      logger.i('countries data sett');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: Consumer<CurrencyProvider>(
        builder: (context, provider, _) {
          return provider.isLoading
              ? SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: const Center(
                        child: Text('Convert'),
                      ),
                    ),
                    body: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : provider.hasError
                  ? SafeArea(
                      child: Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          title: const Center(
                            child: Text('Convert'),
                          ),
                        ),
                        body: Center(
                          child: Text(provider.errorMessage),
                        ),
                      ),
                    )
                  : const HomeScreen();
        },
      ),
    );
  }
}
