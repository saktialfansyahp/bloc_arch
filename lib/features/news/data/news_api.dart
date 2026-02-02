import 'dart:convert';
import 'package:bloc_projects/features/news/models/news.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = '7527e243d1564d6f992c57615a522e3e';
  // static const String _apiKey = '';

  Future<List<News>> fetchNews({
    String country = 'id',
    String category = 'general',
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/'
      'everything?q=apple&from=2026-02-01&to=2026-02-01&sortBy=popularity'
      '&apiKey=$_apiKey',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load news');
    }

    final Map<String, dynamic> jsonBody = json.decode(response.body);

    final List articles = jsonBody['articles'];
    // final List articles = [];

    return articles.map((e) => News.fromJson(e)).toList();
  }
}
