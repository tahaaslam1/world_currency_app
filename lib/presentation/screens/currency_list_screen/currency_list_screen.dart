import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/currency_provider.dart';

class CurrencyList extends StatefulWidget {
  const CurrencyList({super.key});

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  final _snackBar = const SnackBar(
    content: Text('You must have a minimum of two countries'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              CupertinoIcons.clear,
              size: 20.0,
              color: Colors.grey[600],
            ),
          ),
        ),
        title: const Center(
          child: Text('Select Currency'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, _) {
          return provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.hasError
                  ? Center(
                      child: Text(provider.errorMessage),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: provider.currencies.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async => {
                                  if (!provider.contains(currencyToCheck: provider.currencies[index]))
                                    {
                                      await provider.addToList(provider.currencies[index]),
                                    }
                                  else
                                    {
                                      if (provider.addedCurrencyList.length <= 2)
                                        {
                                          ScaffoldMessenger.of(context).showSnackBar(_snackBar),
                                        }
                                      else
                                        {
                                          await provider.removeFromList(provider.currencies[index]),
                                        }
                                    },
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Text(
                                      '${provider.currencies[index].countryEmoji}',
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    '${provider.currencies[index].currencyCode.toString()} - ${provider.currencies[index].currencyName.toString()}',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  trailing: provider.contains(currencyToCheck: provider.currencies[index])
                                      ? const Icon(
                                          Icons.done,
                                          color: Color.fromARGB(255, 5, 96, 176),
                                        )
                                      : const SizedBox(),
                                ),
                              );
                            },
                            separatorBuilder: ((context, index) {
                              return const Divider(
                                thickness: 1.5,
                                height: 15.0,
                              );
                            }),
                          ),
                        ),
                      ],
                    );
        },
      ),
    );
  }
}
