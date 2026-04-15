import 'dart:io';
import 'dart:typed_data';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// OCR Service using Google ML Kit Text Recognition
/// Extracts text from coffee bag images
class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  /// Process image file and extract all text
  Future<String> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  /// Process image bytes and extract all text
  Future<String> extractTextFromBytes(Uint8List imageBytes) async {
    final inputImage = InputImage.fromBytes(bytes: imageBytes);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  /// Get structured text blocks with position info
  Future<List<TextBlock>> getTextBlocks(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.blocks;
  }

  /// Clean and normalize extracted text
  String cleanText(String rawText) {
    // Remove extra whitespace, newlines
    final lines = rawText
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    return lines.join('\n');
  }

  void dispose() {
    _textRecognizer.close();
  }
}
