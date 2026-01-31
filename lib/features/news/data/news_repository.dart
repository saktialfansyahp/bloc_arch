import 'package:bloc_projects/features/news/data/news_api.dart';
import 'package:bloc_projects/features/news/models/news.dart';

class NewsRepository {
  final NewsApiService api;

  NewsRepository(this.api);

  Future<List<News>> getNews() async {
    return api.fetchNews();
  }
}
