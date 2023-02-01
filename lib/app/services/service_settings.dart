import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/models/config_model.dart';
import '../utils/constants_manager.dart';
import 'network_services.dart';

abstract class ServiceSettings {
  Future<ConfigModel?> getServiceSettings();
}

class ServiceSettingsImpl implements ServiceSettings {
  final NetworkServices networkServices;
  final FirebaseFirestore firebaseFirestore;
  ServiceSettingsImpl(this.firebaseFirestore, this.networkServices);
  @override
  Future<ConfigModel?> getServiceSettings() async {
    if (await networkServices.isConnected()) {
      try {
        QuerySnapshot<Map<String, dynamic>> val = await firebaseFirestore
            .collection(AppConstants.settingsCollection)
            .get();
        return ConfigModel.fromSnapshot(val.docs.first);
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }
}
