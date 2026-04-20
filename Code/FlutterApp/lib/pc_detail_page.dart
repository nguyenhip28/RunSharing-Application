import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pc_entry_page.dart';

class PcDetailPage extends StatelessWidget {
  final Map<String, dynamic> pc;
  const PcDetailPage({super.key, required this.pc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pc['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              bool? updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PcEntryPage(pcToEdit: pc)),
              );
              if (updated == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Name: ${pc['name']}", style: const TextStyle(fontSize: 18)),
            Text("Category: ${pc['category']}", style: const TextStyle(fontSize: 18)),
            Text("Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(pc['date']))}", style: const TextStyle(fontSize: 18)),
            Text("Ram: ${pc['ram']}", style: const TextStyle(fontSize: 18)),
            Text("CPU: ${pc['cpu']}", style: const TextStyle(fontSize: 18)),
            Text("Price: ${pc['price']}", style: const TextStyle(fontSize: 18)),

          ],
        ),
      ),
    );
  }
}
