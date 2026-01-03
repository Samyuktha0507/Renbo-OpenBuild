import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/time_capsule.dart';
import '../providers/capsule_provider.dart';
import '../utils/theme.dart'; // Ensure theme is imported
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class CreateCapsuleScreen extends StatefulWidget {
  const CreateCapsuleScreen({super.key});

  @override
  State<CreateCapsuleScreen> createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<CreateCapsuleScreen> {
  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDateTime =
      DateTime.now().add(const Duration(minutes: 10));

  Future<void> _pickDateTime() async {
    final theme = Theme.of(context);

    // 1. Pick Date with Theme
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      // This ensures the calendar picker matches the theme
      builder: (context, child) => Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: theme.colorScheme.primary, // Matcha Green
            onPrimary: theme.brightness == Brightness.dark
                ? AppTheme.darkBackground
                : Colors.white,
            surface: theme.colorScheme.surface,
          ),
        ),
        child: child!,
      ),
    );

    if (pickedDate == null) return;

    // 2. Pick Time with Theme
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) => Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: theme.colorScheme.primary,
            surface: theme.colorScheme.surface,
          ),
        ),
        child: child!,
      ),
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
    final theme = Theme.of(context);

    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.capsuleEmptyError)), // ✅ Translated
      );
      return;
    }

    if (_selectedDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.capsuleTimeError)), // ✅ Translated
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
      SnackBar(
        content: Text(l10n.capsuleSealed), // ✅ Translated
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Dynamic Theme Colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color;
    final primaryAccent = theme.colorScheme.primary;

    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    // ✅ Format date based on current language
    final formattedDate =
        DateFormat('MMM dd, yyyy - hh:mm a', l10n.localeName)
            .format(_selectedDateTime);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Adaptive background
      appBar: AppBar(
        title: Text(
          l10n.newTimeCapsule, // ✅ Translated
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
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
                style: TextStyle(color: textColor),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: l10n.dearFutureMe, // ✅ Translated
                  hintStyle: TextStyle(color: textColor?.withOpacity(0.4)),
                  filled: true,
                  // 🌙 Dynamic Fill: Coffee Bean in dark mode, Light Grey in light
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              onTap: _pickDateTime,
              // 🌓 Themed tile background
              tileColor: isDark
                  ? theme.colorScheme.surface
                  : Colors.blue[50]?.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              leading: Icon(Icons.access_time, color: primaryAccent),
              title: Text(
                l10n.unlocksAt, // ✅ Translated
                style:
                    TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                formattedDate,
                style: TextStyle(color: textColor?.withOpacity(0.7)),
              ),
              trailing: Icon(Icons.edit,
                  color: textColor?.withOpacity(0.5), size: 20),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _saveCapsule(l10n),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  l10n.sealCapsule, // ✅ Translated
                  style: TextStyle(
                    color: isDark ? AppTheme.darkBackground : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}