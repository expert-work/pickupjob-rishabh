import 'package:pickupjob/models/chat_model.dart';
import 'package:pickupjob/helpers/firestore_db.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  Rx<List<ChatModel>> chatList = Rx<List<ChatModel>>([]);

  List<ChatModel> get chats => chatList.value;

  @override
  void onReady() {
    chatList.bindStream(FirestoreDb.chatStream());
  }
}
