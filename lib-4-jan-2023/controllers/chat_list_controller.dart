import 'package:pickupjob/models/chat_list_model.dart';
import 'package:pickupjob/helpers/firestore_db.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  Rx<List<ChatListModel>> chatListListDriver = Rx<List<ChatListModel>>([]);
  Rx<List<ChatListModel>> chatListListUser = Rx<List<ChatListModel>>([]);

  List<ChatListModel> get chatLists_driver => chatListListDriver.value;
  List<ChatListModel> get chatLists_user => chatListListUser.value;

  @override
  void onReady() {
    chatListListDriver.bindStream(FirestoreDb.chatListDriverStream());
    chatListListUser.bindStream(FirestoreDb.chatListUserStream());
  }
}
