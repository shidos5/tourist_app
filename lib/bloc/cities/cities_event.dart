import 'package:equatable/equatable.dart';

abstract class CitiesEvent extends Equatable {
  @override List<Object?> get props => [];
}
class LoadCities extends CitiesEvent {
  final String? query;
  LoadCities({this.query});
  @override List<Object?> get props => [query];
}
