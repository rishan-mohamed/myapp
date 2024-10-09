import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/currency_bloc.dart';
import '../../bloc/currency_event.dart';
import '../../bloc/currency_state.dart';
import '../widgets/currency_input_field.dart';
import '../widgets/conversion_result_card.dart';
import 'currency_list_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Currency Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CurrencyInputField(),
            BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                if (state is CurrencyLoading) {
                  return CircularProgressIndicator();
                } else if (state is CurrencyLoaded) {
                  return Expanded(
                    child: ListView(
                      children: state.targetCurrencies.map((currency) {
                        return ConversionResultCard(
                          currency: currency,
                          rate: state.rates[currency] ?? 1.0,
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return Text("Select a base currency to start");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
