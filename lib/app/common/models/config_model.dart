import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigModel {
  final bool showSocial;
  final bool showDeletion;
  final AppVersion version;
  ConfigModel(
      {required this.showSocial,
      required this.showDeletion,
      required this.version});
  factory ConfigModel.fromJson(Map<String, dynamic> map) => ConfigModel(
        showSocial: map['show-social'],
        showDeletion: map['show-deletion'],
        version: map['version'],
      );
  factory ConfigModel.fromSnapshot(DocumentSnapshot snapshot) => ConfigModel(
        showSocial: snapshot.get('show-social'),
        showDeletion: snapshot.get('show-deletion'),
        version: AppVersion.fromJson(snapshot.get('version')),
      );
  toJson() => {
        'show-social': showSocial,
        'show-deletion': showDeletion,
        'version': version,
      };
}

class AppVersion {
  final bool forceUpdate;
  final Map<String, dynamic> description;
  AppVersion({required this.forceUpdate, required this.description});
  factory AppVersion.fromJson(Map<String, dynamic> map) => AppVersion(
        forceUpdate: map['foce-update'],
        description: map['description'],
      );
  toJson() => {
        'foce-update': forceUpdate,
        'description': description,
      };
}
