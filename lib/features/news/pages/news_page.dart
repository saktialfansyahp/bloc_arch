import 'package:bloc_projects/features/news/bloc/news_bloc.dart';
import 'package:bloc_projects/features/news/data/news_api.dart';
import 'package:bloc_projects/features/news/data/news_repository.dart';
import 'package:bloc_projects/features/news/state/news_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsBloc(NewsRepository(NewsApiService()))..fetchNews(),
      child: NewsView(),
    );
  }
}

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    NewsBloc newsBloc = context.read<NewsBloc>();
    return Stack(
      children: [
        BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () {
                return newsBloc.fetchNews();
              },
              child: _listNews(newsBloc, state, context),
            );
          },
        ),
        // Positioned(
        //   bottom: 16,
        //   left: 16,
        //   child: FloatingActionButton(
        //     onPressed: () {
        //       newsBloc.tes();
        //     },
        //     child: const Icon(Icons.bug_report),
        //   ),
        // ),
      ],
    );
  }

  Widget _listNews(NewsBloc news, NewsState state, BuildContext context) {
    if (state is NewsLoading) {
      return ListView(
        children: [
          SizedBox(height: 300),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (state is NewsEmpty) {
      return _buildEmptyState();
    }

    if (state is NewsError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 72,
                color: Theme.of(context).colorScheme.error,
              ),

              const SizedBox(height: 16),

              Text(
                'Terjadi kesalahan',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                state.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () {
                  news.fetchNews();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is NewsLoaded) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.news.length,
        itemBuilder: (context, index) {
          final news = state.news[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                _buildImage(news.imageUrl),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title.isNotEmpty ? news.title : 'Tanpa Judul',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        news.description.isNotEmpty
                            ? news.description
                            : 'Deskripsi tidak tersedia',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    return const Center(
      child: Text(
        'Terjadi kondisi yang tidak dikenali',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.newspaper, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No news available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return _imageFallback();
    }

    return Image.network(
      imageUrl,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imageFallback(),
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}
