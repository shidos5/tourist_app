import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tourist_app/ui/color/app_colors.dart';
import 'package:tourist_app/ui/screens/trip/add_trip_screen.dart';


class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchTrips() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return [];
      }
      final response = await supabase
          .from('trips')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching trips: $e")),
        );
      }
      return [];
    }
  }

  Future<void> _deleteTrip(String id) async {
    await supabase.from('trips').delete().eq('id', id);
    setState(() {}); // refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Trips"),
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                MaterialPageRoute(builder: (_) => const AddTripScreen()),
                ).then((_) => setState(() {}));
              },
              icon: const Icon(Icons.add, size: 18,color: AppColors.white,),
              label: const Text("Plan Trip",style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTrips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
          
          if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error loading trips\nPlease try again later",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[700]),
                ),
              );
            }

          final trips = snapshot.data!;
              if (trips.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.flight_takeoff, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        "No trips planned yet!\nTap the 'Plan Trip' button to start your adventure",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(trip['destination']),
                  subtitle: Text(
                      "${trip['start_date']} → ${trip['end_date']} • ${trip['pace']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                              builder: (_) =>
                                  AddTripScreen(existingTrip: trip),
                        ),
                          ).then((_) => setState(() {}));
                    },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTrip(trip['id']),
                      ),
                    ],
                  ),
                ),
                  );
                },
              );
          },
      ),
    );
  }
}
