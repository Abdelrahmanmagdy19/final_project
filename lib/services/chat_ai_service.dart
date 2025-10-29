import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatAiService {
  final Dio _dio = Dio();

  Future<String> sendMessage(String message, {Uint8List? imageBytes}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('ai_api_key') ?? '';
      final baseUrl = prefs.getString('ai_base_url') ?? '';

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

      // adapt to the expected response structure — keep safe access
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

      return 'لا يوجد رد من الخادم.';
    } catch (e) {
      return 'حصل خطأ أثناء إرسال الرسالة.';
    }
  }
}
