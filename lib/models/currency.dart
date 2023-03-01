class Currency {
  String? countryEmoji;
  String currencyCode;
  String? currencyName;
  Map<String, dynamic>? rates;

  Currency({required this.countryEmoji, required this.currencyCode, required this.currencyName, this.rates});

  factory Currency.fromJsonInitial(Map<String, dynamic> json) {
    return Currency(
      countryEmoji: json['countryFlag'],
      currencyCode: json['Code'],
      currencyName: json['Currency'],
    );
  }
}
