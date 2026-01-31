import 'package:bloc_projects/features/news/models/news.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsEmpty extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> news;
  NewsLoaded(this.news);
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}
