import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

const String _apiKey = 'AIzaSyDXgTk9MmNI60dyQnQe7xecWX958foVeNs';
const String _baseUrl =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent'; // تم تغيير النموذج إلى 2.5 flash

class ChatAiService {
  final Dio _dio = Dio();

  Future<String> sendMessage(String message, {Uint8List? imageBytes}) async {
    if (_apiKey.isEmpty) {
      return 'Error: API key is missing or is a placeholder.';
    }

    if (message.isEmpty && imageBytes == null) {
      return 'Error: Message and imageBytes cannot both be empty.';
    }

    try {
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
        '$_baseUrl?key=$_apiKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          final content = candidate['content'];

          if (content != null &&
              content['parts'] != null &&
              content['parts'].isNotEmpty) {
            final text = content['parts'][0]['text'];
            if (text != null) {
              return text.toString().trim();
            }
          }
        }

        return 'Response received, but no text content found (safety check or error).';
      }

      return 'AI Service returned status code: ${response.statusCode}';
    } on DioException catch (e) {
      if (e.response != null) {
        return 'API Error: ${e.response!.statusCode}. Check API Key or request payload.';
      } else {
        return 'Network Error: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }
}