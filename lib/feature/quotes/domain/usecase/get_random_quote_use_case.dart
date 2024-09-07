import '../../data/model/quote_model.dart';
import '../repostory/quote_repostory.dart';

class GetRandomQuoteUseCase {
  final QuoteRepository repository;

  GetRandomQuoteUseCase(this.repository);

  Future<QuoteModel> execute() async {
    return await repository.getRandomQuote();
  }
}
