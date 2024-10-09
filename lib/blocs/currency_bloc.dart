import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/currency_service.dart';

abstract class CurrencyEvent {}

class FetchCurrencies extends CurrencyEvent {
  final String inputCurrency;

  FetchCurrencies(this.inputCurrency);
}

class AddPreferredCurrency extends CurrencyEvent {
  final String currencyCode;

  AddPreferredCurrency(this.currencyCode);
}

class RemovePreferredCurrency extends CurrencyEvent {
  final String currencyCode;

  RemovePreferredCurrency(this.currencyCode);
}

class CurrencyState {
  final Map<String, double> exchangeRates;
  final List<String> preferredCurrencies;

  CurrencyState({
    this.exchangeRates = const {},
    this.preferredCurrencies = const [],
  });
}

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyService currencyService;

  CurrencyBloc(this.currencyService) : super(CurrencyState());

  Stream<CurrencyState> mapEventToState(CurrencyEvent event)  {
    // Change here to async*
    if (event is FetchCurrencies) {
      try {
        final rates =
            await currencyService.fetchExchangeRates(event.inputCurrency);
        // Ensure rates are of type Map<String, double>
        yield CurrencyState(
            exchangeRates: rates,
            preferredCurrencies: state.preferredCurrencies);
      } catch (_) {
        // Handle error, possibly yield an error state
      }
    } else if (event is AddPreferredCurrency) {
      final updatedPreferredCurrencies = List.from(state.preferredCurrencies)
        ..add(event.currencyCode);
      yield CurrencyState(
          exchangeRates: state.exchangeRates,
          preferredCurrencies: updatedPreferredCurrencies);
      // Save to shared preferences (not shown here)
    } else if (event is RemovePreferredCurrency) {
      final updatedPreferredCurrencies = List.from(state.preferredCurrencies)
        ..remove(event.currencyCode);
      yield CurrencyState(
          exchangeRates: state.exchangeRates,
          preferredCurrencies: updatedPreferredCurrencies);
      // Save to shared preferences (not shown here)
    }
  }
}
