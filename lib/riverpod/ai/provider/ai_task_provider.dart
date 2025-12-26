// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:hr_tool/riverpod/task/model/task_model.dart';
// import 'package:hr_tool/riverpod/ai/service/ai_service.dart';

// part 'ai_task_provider.g.dart';

// @riverpod
// class AiTaskPriority extends _$AiTaskPriority {
//   @override
//   FutureOr<List<Map<String, String>>> build() {
//     return []; // Start with an empty list
//   }

//   /// Trigger the AI analysis
//   Future<void> generatePlan(List<TaskModel> tasks) async {
//     state = const AsyncValue.loading();
//     state = await AsyncValue.guard(() => AIService.prioritizeTasks(tasks));
//   }
// }
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hr_tool/riverpod/task/model/task_model.dart';
import 'package:hr_tool/riverpod/ai/service/ai_service.dart';

part 'ai_task_provider.g.dart';

@Riverpod(keepAlive: true)
class AiTaskPriority extends _$AiTaskPriority {
  bool _mounted = true;

  @override
  FutureOr<List<Map<String, String>>> build() {
    ref.onDispose(() => _mounted = false);
    return [];
  }

  Future<void> generatePlan(List<TaskModel> tasks) async {
    // 1. Set loading state
    state = const AsyncValue.loading();

    try {
      // 2. Fetch data
      final result = await AIService.prioritizeTasks(tasks);
      print('AI Provider: Received ${result.length} items from service');

      // 3. Update state only if we are still mounted/valid
      if (_mounted) {
        state = AsyncValue.data(result);
        print('AI Provider: State updated with data');
      } else {
        print('AI Provider: Not mounted, skipping state update');
      }
    } catch (e, st) {
      // 4. Handle any unexpected errors that AIService didn't catch
      if (_mounted) {
        state = AsyncValue.error(e, st);
      }
    }
  }
}
