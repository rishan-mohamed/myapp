// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/services/currency_service.dart';
import '../blocs/currency_bloc.dart';

class HomePage extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: BlocProvider(
        create: (context) => CurrencyBloc(CurrencyService()),
        child: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Enter amount'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: currencyController,
                    decoration: InputDecoration(
                        labelText: 'Enter currency code (e.g., USD)'),
                    onSubmitted: (value) {
                      BlocProvider.of<CurrencyBloc>(context)
                          .add(FetchCurrencies(value));
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final amount = double.tryParse(amountController.text);
                      final inputCurrency = currencyController.text;
                      if (amount != null && state.exchangeRates.isNotEmpty) {
                        state.preferredCurrencies.forEach((currencyCode) {
                          final rate = state.exchangeRates[currencyCode] ?? 0;
                          final convertedAmount = amount * rate;
                          print(
                              '$amount $inputCurrency = $convertedAmount $currencyCode');
                        });
                      }
                    },
                    child: Text('Convert'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.preferredCurrencies.length,
                      itemBuilder: (context, index) {
                        final currencyCode = state.preferredCurrencies[index];
                        return ListTile(
                          title: Text(currencyCode),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              BlocProvider.of<CurrencyBloc>(context)
                                  .add(RemovePreferredCurrency(currencyCode));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final currencyCode = currencyController.text;
                      if (currencyCode.isNotEmpty) {
                        BlocProvider.of<CurrencyBloc>(context)
                            .add(AddPreferredCurrency(currencyCode));
                      }
                    },
                    child: Text('Add Preferred Currency'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
