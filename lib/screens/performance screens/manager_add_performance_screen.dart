// lib/screens/performance/manager_add_performance_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_tool/riverpod/employee%20list%20provider/employee_list_provider.dart';
import 'package:hr_tool/riverpod/performance/model/performance_model.dart';
import 'package:hr_tool/riverpod/performance/provider/performance_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ManagerAddPerformanceScreen extends ConsumerStatefulWidget {
  const ManagerAddPerformanceScreen({super.key});

  @override
  ConsumerState<ManagerAddPerformanceScreen> createState() => _ManagerAddPerformanceScreenState();
}

class _ManagerAddPerformanceScreenState extends ConsumerState<ManagerAddPerformanceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedUserId;
  int _rating = 5;
  final _feedbackController = TextEditingController();
  final _achievementsController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    _achievementsController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedUserId != null) {
      setState(() => _isSubmitting = true);
      try {
        final managerId = Supabase.instance.client.auth.currentUser!.id;
        final performance = PerformanceModel(
          id: const Uuid().v4(),
          userId: _selectedUserId!,
          managerId: managerId,
          rating: _rating,
          feedback: _feedbackController.text.trim(),
          achievements: _achievementsController.text.trim(),
          name: _nameController.text.trim(),
        );

        await ref.read(insertPerformanceProvider(performance).future);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Performance review added successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add performance review: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an employee and fill all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final managerId = Supabase.instance.client.auth.currentUser!.id;
    final employeesAsync = ref.watch(employeeListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Add Performance Review',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Employee',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              employeesAsync.when(
                data: (employees) {
                  final filteredEmployees = employees.where((e) => e['id'] != managerId).toList();
                  return DropdownButtonFormField<String>(
                    value: _selectedUserId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Select an employee',
                    ),
                    items: filteredEmployees.map((e) => DropdownMenuItem<String>(
                      value: e['id'] as String, // Explicitly cast to String
                      child: Text(e['name'] as String),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedUserId = value),
                    validator: (value) => value == null ? 'Please select an employee' : null,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text(
                  'Error loading employees: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Review Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter review name (e.g., Q3 2025 Review)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Review name is required';
                  if (value.length > 100) return 'Review name must be less than 100 characters';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Rating (1-10)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _rating.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: _rating.toString(),
                activeColor: const Color(0xFF22C55E),
                onChanged: (value) => setState(() => _rating = value.toInt()),
              ),
              Center(
                child: Text(
                  'Selected Rating: $_rating / 10',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Feedback',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  hintText: 'Provide detailed feedback on employee performance',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 5,
                maxLength: 1000,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Feedback is required';
                  if (value.length < 10) return 'Feedback must be at least 10 characters';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Achievements',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _achievementsController,
                decoration: InputDecoration(
                  hintText: 'List key achievements or contributions',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 5,
                maxLength: 1000,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Achievements are required';
                  if (value.length < 10) return 'Achievements must be at least 10 characters';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Review',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}