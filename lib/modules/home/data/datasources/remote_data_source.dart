import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../app/helper/extentions.dart';
import '../../../../app/common/models/notifiy_model.dart';
import '../../../../app/errors/exception.dart';
import '../../../../app/helper/enums.dart';
import '../../../../app/services/notification_services.dart';
import '../../../../app/services/services_locator.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../domain/usecases/send_problem_use_case.dart';
import '../models/chat_message_model.dart';

abstract class BaseHomeRemoteDataSource {
  Future<bool> sendMessage(ChatMessageModel messageModel);
  Stream<List<ChatMessageModel>> getChatList(String uid);
  Future<void> updateMessage(ChatMessageModel messageModel);
  Future<bool> sendProblem(ProblemInput problemInput);
}

class HomeRemoteDataSource implements BaseHomeRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  HomeRemoteDataSource(this.firebaseFirestore, this.firebaseStorage);
  @override
  Stream<List<ChatMessageModel>> getChatList(String uid) {
    Stream<QuerySnapshot<Map<String, dynamic>>> val = firebaseFirestore
        .collection(AppConstants.chatCollection)
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
    return val.map((querySnap) => querySnap.docs
        .map((queryDoc) => ChatMessageModel.fromSnapshot(queryDoc))
        .toList());
  }

  @override
  Future<bool> sendMessage(ChatMessageModel messageModel) async {
    try {
      if (messageModel.type == MessageType.text) {
        return _uploadToFireStore(messageModel);
      } else {
        List<String> contentList = messageModel.content.split(',');
        List<String> links = await Future.wait(
          contentList.map(
            (content) => _uploadToFireStorage(content, messageModel.type),
          ),
        );
        return _uploadToFireStore(
          messageModel.copySubWith(
            content: links.join(','),
          ),
        );
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  Future<bool> _uploadToFireStore(ChatMessageModel messageModel) async {
    DocumentReference<Map<String, dynamic>> val = await firebaseFirestore
        .collection(AppConstants.chatCollection)
        .add(messageModel.toJson());
    if (val.id.isNotEmpty) {
      return await sl<NotificationServices>().sendNotification(
        NotifyActionModel(
          toToken: "topic/${AppConstants.toAdmin}",
          toId: AppConstants.toAdmin,
          fromId: messageModel.idFrom,
          title: 'Message from user'.tr(),
          body: 'Click to check it !'.tr(),
          type: messageModel.type,
        ),
      );
    } else {
      return false;
    }
  }

  Future<String> _uploadToFireStorage(String filePath, MessageType type) async {
    Reference reference = firebaseStorage.ref(
      type.toStringVal(),
    );
    TaskSnapshot task = await reference
        .child(filePath.substring(filePath.lastIndexOf('/'), filePath.length))
        .putFile(File(filePath));
    //delete file from local
    File(filePath).delete();
    return task.ref.getDownloadURL();
  }

  @override
  Future<void> updateMessage(ChatMessageModel messageModel) async {
    try {
      await firebaseFirestore
          .collection(AppConstants.chatCollection)
          .doc(messageModel.msgId)
          .update(messageModel.toJson());
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<bool> sendProblem(ProblemInput problemInput) async {
    try {
      DocumentReference<Map<String, dynamic>> val = await firebaseFirestore
          .collection(AppConstants.complaintsCollection)
          .add(problemInput.toJson());
      if (val.id.isNotEmpty) {
        return await sl<NotificationServices>().sendNotification(
          NotifyActionModel(
            toToken: "topic/${AppConstants.toAdmin}",
            toId: AppConstants.toAdmin,
            fromId: problemInput.from,
            title: 'Problem from user'.tr(),
            body: problemInput.problem,
            type: MessageType.problem,
          ),
        );
      } else {
        return false;
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
