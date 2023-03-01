import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_currency_app/models/currency.dart';
import 'package:world_currency_app/presentation/widgets/add_currency_button.dart';
import 'package:world_currency_app/provider/currency_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _snackBar = const SnackBar(
    content: Text('Enter value in correct format'),
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text('Convert'),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return context.read<CurrencyProvider>().getCurrencyRates();
          },
          child: Consumer<CurrencyProvider>(
            builder: (context, provider, _) {
              return provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : provider.hasError
                      ? Center(
                          child: Text(provider.errorMessage),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          itemCount: provider.addedCurrencyList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == provider.addedCurrencyList.length) {
                              return Column(
                                children: const [
                                  AddCurrencyButton(),
                                ],
                              );
                            } else {
                              return Dismissible(
                                direction: provider.addedCurrencyList.length <= 2 ? DismissDirection.none : DismissDirection.endToStart,
                                background: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.red,
                                  ),
                                ),
                                key: ValueKey<Currency>(provider.addedCurrencyList[index]),
                                onDismissed: (DismissDirection direction) async {
                                  if (direction == DismissDirection.endToStart) {
                                    await provider.removeFromList(provider.addedCurrencyList[index]);
                                  }
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!(provider.baseCurrency == provider.addedCurrencyList[index])) {
                                      await provider.changeBaseCurrency(provider.addedCurrencyList[index]);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color: Colors.white,
                                        border: !provider.isBaseCurrency(provider.addedCurrencyList[index])
                                            ? Border.all(
                                                color: Colors.grey,
                                              )
                                            : Border.all(
                                                color: const Color.fromARGB(255, 18, 97, 162),
                                                width: 3.0,
                                              ),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                                        leading: Text(
                                          '${provider.addedCurrencyList[index].countryEmoji}',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        title: Text(
                                          provider.addedCurrencyList[index].currencyCode.toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        trailing: !provider.isBaseCurrency(provider.addedCurrencyList[index])
                                            ? Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    provider.getRateAgainstAmount(provider.addedCurrencyList[index]),
                                                  ),
                                                  const SizedBox(
                                                    height: 4.0,
                                                  ),
                                                  Text(
                                                    '1 ${provider.baseCurrency?.currencyCode} = ${provider.getSingleRate(provider.addedCurrencyList[index])} ${provider.addedCurrencyList[index].currencyCode}',
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    width: 60.0,
                                                    child: TextField(
                                                      onSubmitted: (value) {
                                                        if (value.contains(',') || value.contains('-') || value.contains(' ')) {
                                                          ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                                                        } else {
                                                          provider.setBaseCurrencyAmount(value);
                                                        }
                                                      },
                                                      cursorWidth: 1.5,
                                                      cursorColor: Colors.grey,
                                                      cursorHeight: 20.0,
                                                      keyboardType: TextInputType.number,
                                                      textDirection: TextDirection.rtl,
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: provider.baseCurrencyAmount,
                                                        hintTextDirection: TextDirection.rtl,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
            },
          ),
        ),
      ),
    );
  }
}
