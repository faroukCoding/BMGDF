import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'app_constant.dart';

class GeminiService {
  final String _apiKey;
  final String _baseUrl = AppConstant.GEMINI_API_URL;
  
  GeminiService({String? apiKey}) 
      : _apiKey = apiKey ?? AppConstant.GEMINI_API_KEY;

  Future<String> generateText({
    required String prompt,
    String? systemPrompt,
    String model = AppConstant.TEXT_MODEL,
    double temperature = AppConstant.TEMPERATURE,
    int maxTokens = AppConstant.MAX_TOKENS,
  }) async {
    final url = Uri.parse('$_baseUrl$model:generateContent?key=$_apiKey');
    
    final requestBody = {
      'contents': [
        {
          'parts': [
            {
              'text': systemPrompt != null 
                  ? '$systemPrompt

User: $prompt' 
                  : prompt
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': temperature,
        'maxOutputTokens': maxTokens,
        'topP': AppConstant.TOP_P,
        'topK': AppConstant.TOP_K,
      },
      'safetySettings': [
        {'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE'},
        {'category': 'HARM_CATEGORY_HATE_SPEECH', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE'},
        {'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE'},
        {'category': 'HARM_CATEGORY_DANGEROUS_CONTENT', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE'},
      ],
    };
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 60));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final text = data['candidates'][0]['content']['parts'][0]['text'];
          return text ?? 'No response generated';
        }
        return 'No valid response from AI';
      } else {
        throw Exception('Failed to generate text: ${response.statusCode} ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Error generating text: $e');
    }
  }

  bool isConfigured() {
    return _apiKey != 'YOUR_GEMINI_API_KEY_HERE' && _apiKey.isNotEmpty;
  }
}