import 'package:equatable/equatable.dart';

class QuoteModel extends Equatable {
  final String text;
  final String author;

  const QuoteModel({
    required this.text,
    required this.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      text: json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
    );
  }

  @override
  List<Object?> get props => [text, author];
}
