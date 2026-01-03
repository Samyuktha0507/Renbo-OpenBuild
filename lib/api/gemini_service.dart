import 'dart:convert';
import 'package:renbo/utils/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiClassifiedResponse {
  final bool isHarmful;
  final String response;

  GeminiClassifiedResponse({
    this.isHarmful = false,
    this.response = "Sorry, I couldn't connect. Please try again.",
  });
}

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
      : _model = GenerativeModel(
          // Use the stable alias for the most current Flash model
          model: 'gemini-2.5-flash-lite',
          apiKey: AppConstants.geminiApiKey,
        );

  /// Updated to accept languageName to match the call in ChatScreen
  Future<GeminiClassifiedResponse> generateAndClassify(
      String prompt, String languageName) async {
    try {
      final systemPrompt = """
You are Renbot, a supportive and non-judgmental AI assistant. Your role is to provide a safe space for users to express their thoughts and feelings. 

*Instructions:*
1. Create an empathetic and supportive response to the user's message. 
2. Classify the user's message for self-harm or suicidal ideation.
3. Language: The user has selected $languageName. You MUST reply in $languageName.
4. If the user communicates in regional language using english, you must reply using the same.

*Core Principles:*
- Be calm, neutral, and non-judgmental.
- Listen and validate the user's feelings.
- Keep replies simple, crisp, and conversational.
- If the conversation is concluding, provide parting support.

*Safety Classification:*
- "isHarmful": true only if there is an indication of self-harm, suicide, or immediate physical danger.

You MUST respond in valid JSON format:
{
  "isHarmful": boolean,
  "response": "your empathetic message here in $languageName"
}

User's message: "$prompt"
""";

      final content = [Content.text(systemPrompt)];

      final response = await _model.generateContent(
        content,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      if (response.text != null) {
        final Map<String, dynamic> data = jsonDecode(response.text!);
        return GeminiClassifiedResponse(
          isHarmful: data['isHarmful'] ?? false,
          response: data['response'] ?? "I'm here for you.",
        );
      }
      return GeminiClassifiedResponse();
    } catch (e) {
      print("Gemini API Error: $e");
      return GeminiClassifiedResponse(
        response: "I'm having trouble connecting to my brain right now. 😞",
      );
    }
  }

  Future<String> generateThoughtOfTheDay() async {
    try {
      final response = await _model.generateContent(
          [Content.text('Give me one short, positive mental health quote.')]);
      return response.text ?? "You are enough just as you are.";
    } catch (e) {
      return "Take it one breath at a time.";
    }
  }
}
