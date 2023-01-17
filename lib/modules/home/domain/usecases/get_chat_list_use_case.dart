import '../../../../app/common/usecase/base_use_case.dart';
import '../entities/chat_message.dart';
import '../repositories/base_home_repository.dart';

class GetChatListUseCae
    implements BaseUseCase<Stream<List<ChatMessage>>, String> {
  final BaseHomeRespository baseHomeRespository;

  GetChatListUseCae(this.baseHomeRespository);

  @override
  Stream<List<ChatMessage>> call(String parameters) =>
      baseHomeRespository.getChatList(parameters);
}
