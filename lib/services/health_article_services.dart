import 'package:dio/dio.dart';
import 'package:cure_link/models/health_artilcle_model.dart';

class HealthArticleService {
  final Dio _dio = Dio();

  Future<List<HealthArticleModel>> fetchHealthArticles({int page = 1}) async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'category': 'health',
          'language': 'en',
          'pageSize': 5,
          'page': page,
          'apiKey': 'f0aa326d8b584a5cba68fc2114d9087e',
        },
      );

      if (response.statusCode == 200 && response.data['articles'] != null) {
        final List<dynamic> articlesData = response.data['articles'];
        return articlesData.map((element) {
          return HealthArticleModel(
            title: element['title'] ?? 'No Title',
            author: element['author'] ?? 'Unknown',
            content: element['content'] ?? 'No Content',
            url: element['url'] ?? '',
            description: element['description'] ?? 'No description',
            publishedAt: DateTime.parse(
              element['publishedAt'] ?? DateTime.now().toString(),
            ),
            imageUrl:
                element['urlToImage'] ??
                'https://media.istockphoto.com/id/2173059563/vector/coming-soon-image-on-white-background-no-photo-available.jpg?s=612x612&w=0&k=20&c=v0a_B58wPFNDPULSiw_BmPyhSNCyrP_d17i2BPPyDTk=',
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
