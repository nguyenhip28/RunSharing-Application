import 'package:flutter/material.dart';
import 'pc_detail_page.dart';
import 'PCDatabase.dart';

class PcListPage extends StatefulWidget {
  const PcListPage({super.key});

  @override
  State<PcListPage> createState() => _PcListPageState();
}

class _PcListPageState extends State<PcListPage> {
  List<Map<String, dynamic>> pcs = [];

  @override
  void initState() {
    super.initState();
    _loadPcs();
  }

  Future<void> _loadPcs() async {
    pcs = await PCDatabase.getPCs();
    if (mounted) setState(() {});
  }

  Future<void> _deletePc(int id) async {
    await PCDatabase.deletePC(id);
    await _loadPcs();
  }

  Future<void> _deleteAll() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF003399),
        title: const Text('Delete All PC?', style: TextStyle(color: Colors.white)),
        content: const Text('This will delete all PC permanently.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete All')),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await PCDatabase.deleteAll();
      await _loadPcs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PC List'),
        actions: [IconButton(onPressed: _deleteAll, icon: const Icon(Icons.delete_forever))],
      ),
      body: pcs.isEmpty
          ? const Center(child: Text('No PC available', style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: pcs.length,
        itemBuilder: (context, index) {
          final pc = pcs[index];
          return Card(
            color: const Color(0xFF003399).withOpacity(0.8),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              textColor: Colors.white,
              title: Text(pc['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category: ${pc['category']}"),
                  Text("CPU: ${pc['cpu']}"),
                  Text("RAM: ${pc['ram']}"),
                  if(pc['price'] != null && pc['price'].isNotEmpty)
                    Text("Price: ${pc['price']}"),
                ],
              ),
              isThreeLine: true,
              onTap: () async {
                bool? updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PcDetailPage(pc: pc)),
                );
                if (updated == true) await _loadPcs();
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () async {
                  bool confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF003399),
                      title: const Text('Delete PC?', style: TextStyle(color: Colors.white)),
                      content: Text('Are you sure you want to delete "${pc['name']}"?', style: const TextStyle(color: Colors.white70)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                      ],
                    ),
                  ) ?? false;
                  if (confirm) await _deletePc(pc['id']);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
