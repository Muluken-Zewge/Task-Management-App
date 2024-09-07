import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/get_random_quote_use_case.dart';
import 'quotes_event.dart';
import 'quotes_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final GetRandomQuoteUseCase getRandomQuoteUseCase;

  QuoteBloc(this.getRandomQuoteUseCase) : super(QuoteInitial()) {
    on<LoadQuoteEvent>(_onLoadQuoteEvent);
  }

  Future<void> _onLoadQuoteEvent(
      LoadQuoteEvent event, Emitter<QuoteState> emit) async {
    emit(QuoteLoading());
    try {
      final quote = await getRandomQuoteUseCase.execute();
      emit(QuoteLoaded(quote));
    } catch (e) {
      emit(QuoteError('Failed to load quote'));
    }
  }
}
