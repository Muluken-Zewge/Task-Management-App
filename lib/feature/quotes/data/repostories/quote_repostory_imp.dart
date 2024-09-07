import '../../domain/repostory/quote_repostory.dart';
import '../datasource/quote_remote_datasource.dart';
import '../model/quote_model.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDataSource remoteDataSource;

  QuoteRepositoryImpl(this.remoteDataSource);

  @override
  Future<QuoteModel> getRandomQuote() async {
    return await remoteDataSource.fetchRandomQuote();
  }
}
