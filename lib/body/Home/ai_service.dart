import 'package:google_generative_ai/google_generative_ai.dart';


const String _apiKey = 'AIzaSyDpB7ABm3v9AiiyN77ZR86IS8VOT2JkZac';// here i write my api key, i can't share you because it's private
class AIService {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  AIService() {
    if (_apiKey.isEmpty) {
      throw Exception('API_KEY is missing. Run with --dart-define=API_KEY=your_api_key');
    }
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _apiKey,
    );
    _chat = _model.startChat();
  }
  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ?? "No response from AI.";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
//
//     _chat = _model.startChat();
//   }
//
//   Future<String> sendMessage(String message) async {
//     try {
//       final response = await _chat.sendMessage(Content.text(message));
//       return response.text ?? "No response from AI.";
//     } catch (e) {
//       return "Error: ${e.toString()}";
//     }
//   }
// }
}




// import 'package:google_generative_ai/google_generative_ai.dart';
//
// /// Fetch the API key from dart-define (set in Run Configurations)
// const String _apiKey = 'AIzaSyDpB7ABm3v9AiiyN77ZR86IS8VOT2JkZac';
//
// class AIService {
//   late final GenerativeModel _model;
//   late final ChatSession _chat;
//
//   AIService() {
//     if (_apiKey.isEmpty) {
//       throw Exception('API_KEY is missing. Run with --dart-define=API_KEY=your_api_key');
//     }
//
//     _model = GenerativeModel(
//       model: 'gemini-1.5-flash-latest',
//       apiKey: _apiKey,
//     );
//
//     _chat = _model.startChat();
//   }
//
//   Future<String> sendMessage(String message) async {
//     try {
//       final response = await _chat.sendMessage(Content.text(message));
//       return response.text ?? "No response from AI.";
//     } catch (e) {
//       return "Error: ${e.toString()}";
//     }
//   }
// }
