import '../../../../app/common/usecase/base_use_case.dart';
import '../entities/chat_message.dart';
import '../repositories/base_help_repository.dart';

class GetChatListUseCae
    implements BaseUseCase<Stream<List<ChatMessage>>, String> {
  final BaseHelpRespository baseHelpRespository;

  GetChatListUseCae(this.baseHelpRespository);

  @override
  Stream<List<ChatMessage>> call(String parameters) =>
      baseHelpRespository.getChatList(parameters);
}
