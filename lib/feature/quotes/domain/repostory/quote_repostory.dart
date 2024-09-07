import '../../data/model/quote_model.dart';

abstract class QuoteRepository {
  Future<QuoteModel> getRandomQuote();
}
