import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tourist_app/ui/color/app_colors.dart';

class AddTripScreen extends StatefulWidget {
  final Map<String, dynamic>? existingTrip;
  const AddTripScreen({super.key, this.existingTrip});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final supabase = Supabase.instance.client;

  final TextEditingController _destinationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _interests = [];
  String _pace = "Relaxed";
  bool _isSaving = false;

  final List<String> _allInterests = [
    "Culture & History",
    "Art & Museums",
    "Food & Dining",
    "Shopping",
    "Nightlife",
    "Nature & Parks"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingTrip != null) {
      _destinationController.text = widget.existingTrip!['destination'];
      _startDate = DateTime.tryParse(widget.existingTrip!['start_date'] ?? "");
      _endDate = DateTime.tryParse(widget.existingTrip!['end_date'] ?? "");
      _pace = widget.existingTrip!['pace'] ?? "Relaxed";
      _interests = List<String>.from(widget.existingTrip!['interests'] ?? []);
    }
  }

  Future<void> _pickDate(BuildContext ctx, bool isStart) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _saveTrip() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ You must be logged in to save a trip")),
      );
      return;
    }

    final trip = {
      'destination': _destinationController.text,
      'start_date': _startDate?.toIso8601String(),
      'end_date': _endDate?.toIso8601String(),
      'pace': _pace,
      'interests': _interests,
      'user_id': user.id, // ✅ logged-in user ID
    };

    setState(() => _isSaving = true);

    try {
      if (widget.existingTrip != null) {
        await supabase.from('trips').update(trip).eq('id', widget.existingTrip!['id']);
      } else {
        await supabase.from('trips').insert(trip);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to save trip: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat("dd/MM/yyyy");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.existingTrip == null ? "Plan Your Trip" : "Edit Trip"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Destination
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: "Destination",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
      
            // Dates
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_startDate == null ? "Start Date" : df.format(_startDate!)),
                  onPressed: () => _pickDate(context, true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_endDate == null ? "End Date" : df.format(_endDate!)),
                  onPressed: () => _pickDate(context, false),
                ),
              ),
            ]),
            const SizedBox(height: 16),
      
            // Interests
            const Text("Your Interests"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _allInterests.map((interest) {
                final selected = _interests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: selected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _interests.add(interest);
                      } else {
                        _interests.remove(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
      
            // Pace
            const Text("Travel Pace"),
            RadioListTile<String>(
              title: const Text("Relaxed - Take it easy"),
              value: "Relaxed",
              groupValue: _pace,
              onChanged: (v) => setState(() => _pace = v!),
            ),
            RadioListTile<String>(
              title: const Text("Moderate - Balanced exploration"),
              value: "Moderate",
              groupValue: _pace,
              onChanged: (v) => setState(() => _pace = v!),
            ),
            RadioListTile<String>(
              title: const Text("Intense - See everything"),
              value: "Intense",
              groupValue: _pace,
              onChanged: (v) => setState(() => _pace = v!),
            ),
            const SizedBox(height: 24),
      
            Center(
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveTrip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(widget.existingTrip == null ? "Save Trip" : "Update Trip",
                        style: TextStyle(color: AppColors.white)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }
}
