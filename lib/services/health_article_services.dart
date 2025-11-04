import 'package:dio/dio.dart';
import 'package:cure_link/models/model/health_artilcle_model.dart';

class HealthArticleService {
  final Dio _dio = Dio();

  Future<List<HealthArticleModel>> fetchHealthArticles({int page = 1}) async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'category': 'health',
          'language': 'en',
          'pageSize': 5, // عدد الأخبار في كل تحميل
          'page': page,
          'apiKey': 'f0aa326d8b584a5cba68fc2114d9087e',
        },
      );

      if (response.statusCode == 200 && response.data['articles'] != null) {
        final List<dynamic> articlesData = response.data['articles'];
        return articlesData.map((element) {
          return HealthArticleModel(
            title: element['title'] ?? 'No Title',
            imageUrl:
                element['urlToImage'] ??
                'https://img.freepik.com/free-vector/medical-healthcare-concept-illustration_114360-6261.jpg',
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
