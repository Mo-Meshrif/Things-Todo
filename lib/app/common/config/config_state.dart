part of 'config_bloc.dart';

abstract class ConfigState extends Equatable {
  const ConfigState();

  @override
  List<Object> get props => [];
}

class ConfigInitial extends ConfigState {}

class ConfigLoading extends ConfigState {}

class ConfigLoaded extends ConfigState {
  final ConfigModel configModel;
  const ConfigLoaded({required this.configModel});
}

class ConfigFailed extends ConfigState {}
