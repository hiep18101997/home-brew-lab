import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Service to parse extracted text from coffee bag images
/// Uses MiniMax API to extract structured bean information
class BeanInfoParser {
  // TODO: Replace with your MiniMax API key
  static const String _apiKey = 'YOUR_MINIMAX_API_KEY';
  static const String _apiBase = 'https://api.minimax.io/v1';

  /// Parse extracted OCR text into structured bean information
  Future<BeanInfo> parseBeanInfo(String extractedText) async {
    if (extractedText.trim().isEmpty) {
      return BeanInfo.empty();
    }

    try {
      final response = await _callMiniMaxApi(extractedText);
      return _parseApiResponse(response);
    } catch (e) {
      debugPrint('BeanInfoParser error: $e');
      // Fallback: return basic parsing without AI
      return _fallbackParse(extractedText);
    }
  }

  /// Call MiniMax text API to parse bean information
  Future<String> _callMiniMaxApi(String text) async {
    final prompt = '''
You are a coffee expert. Extract information from this coffee bag label and return ONLY a JSON object with these fields:
- name: the coffee product name
- roaster: the roaster/brand name
- origin: country or region of origin
- variety: coffee variety (if mentioned, e.g., Arabica, Robusta, Heirloom, etc.)
- process: processing method (if mentioned, e.g., Washed, Natural, Honey, etc.)
- roastLevel: roast level if mentioned (Light, Medium, Medium-Light, Medium-Dark, Dark)
- notes: any flavor notes or tasting notes mentioned

Return ONLY the JSON object, no other text. Example:
{"name":"Ethiopia Yirgacheffe","roaster":"Local Roaster","origin":"Ethiopia","variety":"Heirloom","process":"Natural","roastLevel":"Light","notes":"Floral, citrus, berry"}

Text to parse:
$text
''';

    final payload = {
      'model': 'MiniMax-Text-01',
      'messages': [
        {
          'role': 'user',
          'content': prompt,
        }
      ],
      'temperature': 0.3,
    };

    final httpClient = HttpClient();
    final request = await httpClient.postUrl(Uri.parse('$_apiBase/text/chatcompletion_v2'));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer $_apiKey');
    request.write(jsonEncode(payload));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    final jsonResponse = jsonDecode(responseBody);
    return jsonResponse['choices'][0]['message']['content'];
  }

  BeanInfo _parseApiResponse(String response) {
    try {
      // Try to extract JSON from response
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(response);
      if (jsonMatch != null) {
        final json = jsonDecode(jsonMatch.group(0)!);
        return BeanInfo(
          name: json['name'] ?? '',
          roaster: json['roaster'] ?? '',
          origin: json['origin'],
          variety: json['variety'],
          process: json['process'],
          roastLevel: json['roastLevel'],
          notes: json['notes'],
        );
      }
    } catch (e) {
      debugPrint('Failed to parse API response: $e');
    }
    return _fallbackParse(response);
  }

  /// Simple fallback parsing without AI
  BeanInfo _fallbackParse(String text) {
    final lines = text.split('\n').where((l) => l.trim().isNotEmpty).toList();

    String? name;
    String? roaster;
    String? origin;
    String? process;
    String? roastLevel;
    List<String> flavorNotes = [];

    // Simple keyword-based extraction
    for (final line in lines) {
      final upperLine = line.toUpperCase();

      if (upperLine.contains('ORIGIN') || upperLine.contains('COUNTRY') || upperLine.contains('REGION')) {
        origin = line.split(':').last.trim();
      } else if (upperLine.contains('PROCESS')) {
        process = line.split(':').last.trim();
      } else if (upperLine.contains('ROAST')) {
        roastLevel = line.split(':').last.trim();
      } else if (upperLine.contains('TASTING') || upperLine.contains('FLAVOR') || upperLine.contains('NOTES')) {
        flavorNotes.add(line.split(':').last.trim());
      } else if (name == null && line.length > 3 && line.length < 100) {
        // First substantial line is likely the name
        name = line.trim();
      } else if (roaster == null && (upperLine.contains('ROASTER') || upperLine.contains('BRAND'))) {
        roaster = line.split(':').last.trim();
      }
    }

    return BeanInfo(
      name: name ?? '',
      roaster: roaster ?? '',
      origin: origin,
      variety: null,
      process: process,
      roastLevel: roastLevel,
      notes: flavorNotes.isNotEmpty ? flavorNotes.join(', ') : null,
    );
  }
}

/// Structured bean information extracted from image
class BeanInfo {
  final String name;
  final String roaster;
  final String? origin;
  final String? variety;
  final String? process;
  final String? roastLevel;
  final String? notes;

  BeanInfo({
    required this.name,
    required this.roaster,
    this.origin,
    this.variety,
    this.process,
    this.roastLevel,
    this.notes,
  });

  factory BeanInfo.empty() => BeanInfo(name: '', roaster: '');

  bool get isEmpty => name.isEmpty && roaster.isEmpty;
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() => 'BeanInfo(name: $name, roaster: $roaster, origin: $origin)';
}
