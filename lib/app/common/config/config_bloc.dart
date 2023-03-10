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

  late ConfigModel _config;
  ConfigModel get config => _config;

  FutureOr<void> _getConfigData(
      GetConfigData event, Emitter<ConfigState> emit) async {
    emit(ConfigLoading());
    ConfigModel? temp = await serviceSettings.getServiceSettings();
    if (temp == null) {
      _config = ConfigModel(
        showSocial: false,
        showDeletion: false,
        version: AppVersion(
          forceUpdate: false,
          description: {
            'ar': null,
            'en': null,
          },
        ),
      );
      emit(ConfigFailed());
    } else {
      _config = temp;
      emit(ConfigLoaded(configModel: _config));
    }
  }

  FutureOr<void> _updateConfigData(
      UpdateConfigData event, Emitter<ConfigState> emit) {
    emit(ConfigLoading());
    _config = event.config;
    emit(ConfigLoaded(configModel: _config));
  }
}
