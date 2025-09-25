import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tourist_app/models/trip.dart';
import 'package:tourist_app/repositories/trip_repository.dart';

part 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  final TripRepository _tripRepository;
  final String userId;

  TripsCubit(this._tripRepository, this.userId) : super(TripsInitial()) {
    fetchTrips();
  }

  void fetchTrips() async {
    try {
      emit(TripsLoading());
      final trips = await _tripRepository.getTrips(userId);
      emit(TripsLoaded(trips));
    } catch (e) {
      emit(TripsError(e.toString()));
    }
  }

  void addTrip(Trip trip) async {
    try {
      await _tripRepository.addTrip(trip);
      fetchTrips();
    } catch (e) {
      emit(TripsError(e.toString()));
    }
  }

  void updateTrip(Trip trip) async {
    try {
      await _tripRepository.updateTrip(trip);
      fetchTrips();
    } catch (e) {
      emit(TripsError(e.toString()));
    }
  }

  void deleteTrip(String tripId) async {
    try {
      await _tripRepository.deleteTrip(tripId);
      fetchTrips();
    } catch (e) {
      emit(TripsError(e.toString()));
    }
  }
}
