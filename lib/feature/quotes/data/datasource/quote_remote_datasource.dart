import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/quote_model.dart';

abstract class QuoteRemoteDataSource {
  Future<QuoteModel> fetchRandomQuote();
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  final http.Client client;

  QuoteRemoteDataSourceImpl(this.client);

  @override
  Future<QuoteModel> fetchRandomQuote() async {
    final response =
        await client.get(Uri.parse('https://api.quotable.io/quotes/random'));

    if (response.statusCode == 200) {
      final List<dynamic> quotesJson = json.decode(response.body);
      final randomIndex =
          (quotesJson.length * new DateTime.now().millisecondsSinceEpoch)
                  .toInt() %
              quotesJson.length;
      return QuoteModel.fromJson(quotesJson[randomIndex]);
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
