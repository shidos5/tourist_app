import 'package:equatable/equatable.dart';
import '../../models/city.dart';

abstract class CitiesState extends Equatable {
  @override List<Object?> get props => [];
}
class CitiesInitial extends CitiesState {}
class CitiesLoading extends CitiesState {}
class CitiesLoaded extends CitiesState {
  final List<City> cities;
  CitiesLoaded(this.cities);
  @override List<Object?> get props => [cities];
}
class CitiesError extends CitiesState {
  final String message;
  CitiesError(this.message);
  @override List<Object?> get props => [message];
}
