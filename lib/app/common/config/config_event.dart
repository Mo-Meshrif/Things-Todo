part of 'config_bloc.dart';

abstract class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  List<Object> get props => [];
}

class GetConfigData extends ConfigEvent {}

class UpdateConfigData extends ConfigEvent{
  final ConfigModel config;

  const UpdateConfigData({required this.config});
}
