// import 'dart:convert';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:hr_tool/core/constants/api_constants.dart';
// import 'package:hr_tool/riverpod/task/model/task_model.dart';

// class AIService {
//   /// Calls Google Gemini to prioritize tasks.
//   static Future<List<Map<String, String>>> prioritizeTasks(List<TaskModel> tasks) async {
//     // 1. Filter only active tasks to save tokens
//     final activeTasks = tasks.where((t) => t.status != 'completed').toList();
//     if (activeTasks.isEmpty) return [];

//     try {
//       // 2. Initialize the Model
//       final model = GenerativeModel(
//         model: 'gemini-1.5-flash', // Flash is fast and good for this
//         apiKey: ApiConstants.geminiApiKey,
//       );

//       // 3. Prepare the Prompt
//       final now = DateTime.now().toIso8601String().split('T')[0];

//       // Simplify task data for the AI
//       final tasksJson = activeTasks.map((t) => {
//         'id': t.id,
//         'title': t.title,
//         'due_date': t.due_date.toIso8601String().split('T')[0],
//         'description': t.description,
//       }).toList();

//       final promptText = '''
//       You are an expert Project Manager AI.
//       Current Date: $now

//       Here is a list of tasks assigned to an employee:
//       ${jsonEncode(tasksJson)}

//       Analyze the due dates and complexity (based on description).
//       Identify the top 3 tasks the employee must focus on TODAY to meet deadlines.

//       Return the response strictly as a JSON list of objects. Do not include Markdown formatting or code blocks.
//       Format: [{"task_id": "string", "reason": "string"}]
//       ''';

//       // 4. Call the API
//       final content = [Content.text(promptText)];
//       final response = await model.generateContent(content);

//       if (response.text == null) return [];

//       // 5. Clean and Parse Response
//       // Gemini sometimes wraps JSON in ```json ... ```, so we clean it.
//       final cleanJson = response.text!
//           .replaceAll('```json', '')
//           .replaceAll('```', '')
//           .trim();

//       final List<dynamic> jsonList = jsonDecode(cleanJson);

//       return jsonList.map((item) => {
//         'task_id': item['task_id'].toString(),
//         'reason': item['reason'].toString(),
//       }).toList();

//     } catch (e) {
//       // Fallback in case of AI error
//       print('AI Error: $e');
//       return [
//         {
//           'task_id': activeTasks.first.id,
//           'reason': 'AI service unavailable. Showing top task by default.'
//         }
//       ];
//     }
//   }
// }

import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hr_tool/core/constants/api_constants.dart';
import 'package:hr_tool/riverpod/task/model/task_model.dart';

class AIService {
  static Future<List<Map<String, String>>> prioritizeTasks(
    List<TaskModel> tasks,
  ) async {
    final activeTasks = tasks.where((t) => t.status != 'completed').toList();
    print('AI Service: Active tasks count: ${activeTasks.length}');
    if (activeTasks.isEmpty) {
      print('AI Service: No active tasks.');
      return [];
    }

    try {
      // Use 'gemini-flash-latest' which points to the latest stable flash model
      final model = GenerativeModel(
        model: 'gemini-flash-latest',
        apiKey: ApiConstants.geminiApiKey,
      );

      final now = DateTime.now().toIso8601String().split('T')[0];

      final tasksJson = activeTasks
          .map(
            (t) => {
              'id': t.id,
              'title': t.title,
              'due_date': t.due_date.toIso8601String().split('T')[0],
              'description': t.description,
            },
          )
          .toList();

      final promptText =
          '''
      You are an expert Project Manager AI. 
      Current Date: $now
      
      Here is a list of tasks:
      ${jsonEncode(tasksJson)}
      
      Identify the top 3 tasks to focus on TODAY.
      Return strictly a JSON list of objects.
      Format: [{"task_id": "string", "reason": "string"}]
      ''';

      final content = [Content.text(promptText)];
      print('AI Service: Sending request to model $model...');
      final response = await model.generateContent(content);
      print('AI Service: Response received: ${response.text}');

      if (response.text == null) throw Exception("Empty response from AI");

      final cleanJson = response.text!
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final List<dynamic> jsonList = jsonDecode(cleanJson);

      return jsonList
          .map(
            (item) => {
              'task_id': item['task_id'].toString(),
              'reason': item['reason'].toString(),
            },
          )
          .toList();
    } catch (e) {
      print('AI Error caught in service: $e');

      String reason = 'AI unavailable. This is the earliest due task.';
      if (e.toString().contains('Quota exceeded')) {
        reason = 'AI Limit Reached. This is the earliest due task.';
      }

      // Return a safe fallback to prevent app crash
      if (activeTasks.isNotEmpty) {
        return [
          {'task_id': activeTasks.first.id, 'reason': reason},
        ];
      }
      return [];
    }
  }
}
