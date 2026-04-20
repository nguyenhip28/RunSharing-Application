import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'PCDatabase.dart';

class PcEntryPage extends StatefulWidget {
  final Map<String, dynamic>? pcToEdit;
  const PcEntryPage({super.key, this.pcToEdit});

  @override
  State<PcEntryPage> createState() => _PcEntryPageState();
}

class _PcEntryPageState extends State<PcEntryPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ramController = TextEditingController();
  final TextEditingController cpuController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isGaming = false;
  bool isOffice = false;
  
  DateTime pcDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.pcToEdit != null) {
      final pc = widget.pcToEdit!;
      nameController.text = pc['name'];
      final categoryString = pc['category'] as String? ?? '';
      isGaming = categoryString.contains('Gaming');
      isOffice = categoryString.contains('Office');
      ramController.text = pc['ram'];
      cpuController.text = pc['cpu'];
      priceController.text = pc['price'] ?? '';
      pcDate = DateTime.parse(pc['date']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pcToEdit != null ? 'Edit PC' : 'Enter PC Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'PC Name *'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Category *', style: Theme.of(context).textTheme.bodyLarge),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: isGaming,
                    onChanged: (bool? value) {
                      setState(() {
                        isGaming = value ?? false;
                      });
                    },
                  ),
                  const Text('Gaming'),
                  const SizedBox(width: 24),
                  Checkbox(
                    value: isOffice,
                    onChanged: (bool? value) {
                      setState(() {
                        isOffice = value ?? false;
                      });
                    },
                  ),
                  const Text('Office'),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Date: ${DateFormat('yyyy-MM-dd').format(pcDate)}', style: Theme.of(context).textTheme.bodyLarge),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              TextFormField(
                controller: ramController,
                decoration: const InputDecoration(labelText: 'Ram *'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: cpuController,
                decoration: const InputDecoration(labelText: 'CPU *'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitPC,
        child: const Icon(Icons.check),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: pcDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF0066FF),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => pcDate = date);
  }

  Future<void> _submitPC() async {
    if (_formKey.currentState!.validate()) {
      if (!isGaming && !isOffice) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category.')),
        );
        return;
      }

      final List<String> selectedCategories = [];
      if (isGaming) selectedCategories.add('Gaming');
      if (isOffice) selectedCategories.add('Office');
      final String categoryText = selectedCategories.join(', ');

      bool confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF003399),
          title: const Text('Confirm PC', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Text(
              'Name: ${nameController.text}\n'
              'Category: $categoryText\n'
              'Date: ${DateFormat('yyyy-MM-dd').format(pcDate)}\n'
              'RAM: ${ramController.text}\n'
              'CPU: ${cpuController.text}\n'
              'Price: ${priceController.text}',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Edit')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirm')),
          ],
        ),
      ) ?? false;

      if (confirmed) {
        Map<String, dynamic> pcData = {
          'name': nameController.text,
          'category': categoryText,
          'date': pcDate.toIso8601String(),
          'ram': ramController.text,
          'cpu': cpuController.text,
          'price': priceController.text,
        };

        if (widget.pcToEdit != null) {
          await PCDatabase.updatePC(widget.pcToEdit!['id'], pcData);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PC updated!')));
        } else {
          await PCDatabase.savePC(pcData);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PC saved!')));
        }

        Navigator.pop(context, true);
      }
    }
  }
}
