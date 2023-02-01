import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/service_settings.dart';
import '../models/config_model.dart';
part 'config_event.dart';
part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ServiceSettings serviceSettings;
  ConfigBloc({required this.serviceSettings}) : super(ConfigInitial()) {
    on<GetConfigData>(_getConfigData);
    on<UpdateConfigData>(_updateConfigData);
  }

  FutureOr<void> _getConfigData(
      GetConfigData event, Emitter<ConfigState> emit) async {
    emit(ConfigLoading());
    ConfigModel? config = await serviceSettings.getServiceSettings();
    config == null
        ? emit(ConfigFailed())
        : emit(ConfigLoaded(configModel: config));
  }

  FutureOr<void> _updateConfigData(
      UpdateConfigData event, Emitter<ConfigState> emit) {
    emit(ConfigLoading());
    emit(ConfigLoaded(configModel: event.config));
  }
}
