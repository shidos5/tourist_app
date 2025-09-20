import 'package:bloc/bloc.dart';
import '../../repositories/city_repository.dart';
import 'cities_event.dart';
import 'cities_state.dart';

class CitiesBloc extends Bloc<CitiesEvent, CitiesState> {
  final CityRepository repo;
  CitiesBloc(this.repo): super(CitiesInitial()) {
    on<LoadCities>((e, emit) async {
      emit(CitiesLoading());
      try {
        final cities = await repo.fetchCities(query: e.query);
        emit(CitiesLoaded(cities));
      } catch (err) {
        emit(CitiesError(err.toString()));
      }
    });
  }
}
