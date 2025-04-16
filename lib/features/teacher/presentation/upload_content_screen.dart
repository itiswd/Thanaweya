// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sec_learning/core/supabase_init.dart' show SupabaseInit;
import 'package:sec_learning/core/utils/snackbar.dart';

class UploadContentScreen extends StatefulWidget {
  const UploadContentScreen({super.key});

  @override
  UploadContentScreenState createState() => UploadContentScreenState();
}

class UploadContentScreenState extends State<UploadContentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String? _selectedContentType = 'exam';
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _uploadContent() async {
    if (!_formKey.currentState!.validate() || _selectedFile == null) return;

    setState(() => _isUploading = true);

    try {
      final fileBytes = _selectedFile!.bytes;
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${_selectedFile!.name}';

      // Upload file to storage
      await SupabaseInit.client.storage
          .from('school_content')
          .uploadBinary(fileName, fileBytes!);

      // Get public URL
      final fileUrl = SupabaseInit.client.storage
          .from('school_content')
          .getPublicUrl(fileName);

      // Insert record to database
      await SupabaseInit.client.from(_selectedContentType!).insert({
        'title': _titleController.text,
        'file_url': fileUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      showSuccessSnackbar(context, 'تم رفع المحتوى بنجاح');
      Navigator.pop(context);
    } catch (e) {
      showErrorSnackbar(context, 'حدث خطأ أثناء الرفع: ${e.toString()}');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رفع محتوى جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedContentType,
                items: const [
                  DropdownMenuItem(value: 'exams', child: Text('اختبار')),
                  DropdownMenuItem(value: 'schedules', child: Text('جدول')),
                  DropdownMenuItem(value: 'lectures', child: Text('محاضرة')),
                ],
                onChanged:
                    (value) => setState(() => _selectedContentType = value),
                decoration: const InputDecoration(labelText: 'نوع المحتوى'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'عنوان المحتوى'),
                validator: (value) => value!.isEmpty ? 'يجب إدخال عنوان' : null,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _pickFile,
                child: const Text('اختر ملف'),
              ),
              if (_selectedFile != null) ...[
                const SizedBox(height: 8),
                Text(
                  'الملف المحدد: ${_selectedFile!.name}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadContent,
                child:
                    _isUploading
                        ? const CircularProgressIndicator()
                        : const Text('رفع المحتوى'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
