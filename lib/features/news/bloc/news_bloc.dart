import 'package:bloc/bloc.dart';
import 'package:bloc_projects/features/news/data/news_repository.dart';
import 'package:bloc_projects/features/news/state/news_state.dart';

class NewsBloc extends Cubit<NewsState> {
  final NewsRepository repo;
  NewsBloc(this.repo) : super(NewsInitial());

  Future<void> fetchNews() async {
    try {
      emit(NewsLoading());
      final news = await repo.getNews();

      if (news.isEmpty) {
        emit(NewsEmpty());
      } else {
        emit(NewsLoaded(news));
      }
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  void tes() async {
    emit(NewsLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(NewsError('tes error'));
  }
}
