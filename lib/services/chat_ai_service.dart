import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class ChatAiService {
  final Dio _dio = Dio();

  Future<String> sendMessage(String message, {Uint8List? imageBytes}) async {
    try {
      final apiKey = 'AIzaSyD046QSAkJKKs7DtneEkfWM_3UzZR-AdZg';
      final baseUrl =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

      if (apiKey.isEmpty || baseUrl.isEmpty) {
        throw Exception('API key or base URL not set');
      }

      final parts = <Map<String, dynamic>>[];

      if (message.isNotEmpty) {
        parts.add({"text": message});
      }

      if (imageBytes != null) {
        final base64Image = base64Encode(imageBytes);
        parts.add({
          "inline_data": {"mime_type": "image/jpeg", "data": base64Image},
        });
      }

      final payload = {
        "contents": [
          {"parts": parts},
        ],
      };

      final response = await _dio.post(
        '$baseUrl?key=$apiKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: payload,
      );

      if (response.data != null &&
          response.data['candidates'] != null &&
          response.data['candidates'].isNotEmpty) {
        final candidate = response.data['candidates'][0];
        final content = candidate['content'];
        if (content != null &&
            content['parts'] != null &&
            content['parts'].isNotEmpty) {
          final text = content['parts'][0]['text'];
          if (text != null) return text.toString();
        }
      }

      return 'No valid response from AI service.';
    } catch (e) {
      return 'Error occurred while sending the message.';
    }
  }
}
