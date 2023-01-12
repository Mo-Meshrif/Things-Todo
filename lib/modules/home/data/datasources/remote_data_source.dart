import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo/app/common/models/notifiy_model.dart';
import '../../../../app/errors/exception.dart';
import '../../../../app/helper/enums.dart';
import '../../../../app/services/notification_services.dart';
import '../../../../app/services/services_locator.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../domain/usecases/send_problem_use_case.dart';
import '../models/chat_message_model.dart';

abstract class BaseHomeRemoteDataSource {
  Future<bool> sendMessage(ChatMessageModel messageModel);
  Future<Stream<List<ChatMessageModel>>> getChatList(String uid);
  Future<void> updateMessage(ChatMessageModel messageModel);
  Future<bool> sendProblem(ProblemInput problemInput);
}

class HomeRemoteDataSource implements BaseHomeRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  HomeRemoteDataSource(this.firebaseFirestore, this.firebaseStorage);
  @override
  Future<Stream<List<ChatMessageModel>>> getChatList(String uid) async {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> val = firebaseFirestore
          .collection(AppConstants.chatCollection)
          .where('uid', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .snapshots();
      return val.map((querySnap) => querySnap.docs
          .map((queryDoc) => ChatMessageModel.fromSnapshot(queryDoc))
          .toList());
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<bool> sendMessage(ChatMessageModel messageModel) async {
    try {
      if (messageModel.type == MessageType.text) {
        return _uploadToFireStore(messageModel);
      } else {
        String _filePath = messageModel.content;
        String voiceLink = await _uploadToFireStorage(_filePath);
        return _uploadToFireStore(messageModel.copySubWith(content: voiceLink));
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  Future<bool> _uploadToFireStore(ChatMessageModel messageModel) async {
    DocumentReference<Map<String, dynamic>> val = await firebaseFirestore
        .collection(AppConstants.chatCollection)
        .add(messageModel.toJson());
    return val.id.isNotEmpty;
  }

  Future<String> _uploadToFireStorage(String filePath) async {
    TaskSnapshot task = await firebaseStorage
        .ref('voices')
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
        return await sl<NotificationServices>()
            .sendNotification(NotifyActionModel(
          id: problemInput.id,
          to: "topic/${AppConstants.toAdmin}",
          title: 'Problem from user',
          body: problemInput.problem,
        ));
      } else {
        return false;
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
