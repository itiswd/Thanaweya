import 'package:flutter/material.dart';
import 'package:sec_learning/core/supabase_init.dart' show SupabaseInit;
import 'package:sec_learning/core/utils/snackbar.dart' show showErrorSnackbar;
import 'package:url_launcher/url_launcher.dart';

class ContentList extends StatelessWidget {
  final String title;
  final String collectionName;

  const ContentList({
    super.key,
    required this.title,
    required this.collectionName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: SupabaseInit.client.from(collectionName).select(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showErrorSnackbar(context, 'حدث خطأ في جلب البيانات');
            return const Center(child: Text('حدث خطأ'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final contents = snapshot.data!;

          return ListView.builder(
            itemCount: contents.length,
            itemBuilder: (context, index) {
              final content = contents[index];
              return ListTile(
                title: Text(content['title']),
                subtitle: Text(content['created_at']),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () async {
                    final url = content['file_url'];
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      // ignore: use_build_context_synchronously
                      showErrorSnackbar(context, 'لا يمكن فتح الملف');
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
