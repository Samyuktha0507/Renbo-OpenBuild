import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/time_capsule.dart';
import '../providers/capsule_provider.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class CreateCapsuleScreen extends StatefulWidget {
  const CreateCapsuleScreen({super.key});

  @override
  State<CreateCapsuleScreen> createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<CreateCapsuleScreen> {
  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDateTime = DateTime.now().add(const Duration(minutes: 10));

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _saveCapsule(AppLocalizations l10n) {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.capsuleEmptyError)), // ✅ Translated
      );
      return;
    }

    if (_selectedDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.capsuleTimeError)), // ✅ Translated
      );
      return;
    }

    final newCapsule = TimeCapsule(
      id: const Uuid().v4(),
      content: _controller.text,
      createdAt: DateTime.now(),
      deliveryDate: _selectedDateTime,
    );

    Provider.of<CapsuleProvider>(context, listen: false).addCapsule(newCapsule);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.capsuleSealed)), // ✅ Translated
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;
    
    // ✅ Format date based on current language
    final formattedDate = DateFormat('MMM dd, yyyy - hh:mm a', l10n.localeName)
        .format(_selectedDateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newTimeCapsule), // ✅ Translated
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: l10n.dearFutureMe, // ✅ Translated
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              onTap: _pickDateTime,
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              leading: const Icon(Icons.access_time, color: Color(0xFF8E97FD)),
              title: Text(l10n.unlocksAt), // ✅ Translated
              subtitle: Text(formattedDate),
              trailing: const Icon(Icons.edit),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _saveCapsule(l10n),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E97FD),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(l10n.sealCapsule, // ✅ Translated
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}