import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pickupjob/helpers/firestore_db.dart';
import 'package:pickupjob/models/models.dart';

import '../../controllers/controllers.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  dynamic argumentData = Get.arguments;
  final messageController = TextEditingController();
  final getStorage = GetStorage();

  String chat_id = '';
  String user_id = '';
  String user_name = '';
  String user_image = '';
  String driver_id = '';
  String driver_name = '';
  String driver_image = '';
  String job_id = '';
  String job_title = '';

  @override
  void initState() {
    chat_id = argumentData['chat_id'];
    user_id = argumentData['user_id'];
    user_name = argumentData['user_name'];
    user_image = argumentData['user_image'];
    driver_id = argumentData['driver_id'];
    driver_name = argumentData['driver_name'];
    driver_image = argumentData['driver_image'];
    job_id = argumentData['job_id'];
    job_title = argumentData['job_title'];
    getStorage.write('chat_id', chat_id);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) => controller.firestoreUser == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  ((controller.firestoreUser.value!.userType == 'USER')
                          ? driver_name
                          : user_name) +
                      ' - ' +
                      job_title,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        margin: EdgeInsets.only(bottom: 90),
                        child: GetX<ChatController>(
                          init: Get.put<ChatController>(ChatController()),
                          builder: (ChatController chatController) {
                            return Container(
                              padding:
                                  EdgeInsets.only(left: 15, right: 15, top: 30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                itemCount: chatController.chats.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // print(chatController.chats[index]);
                                  final chatData = chatController.chats[index];
                                  return Align(
                                      alignment: (chatData.send_by ==
                                              controller.firestoreUser.value!
                                                  .userType)
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          padding: EdgeInsets.all(5),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            // color: (chatData.send_by ==
                                            //         controller.firestoreUser
                                            //             .value!.userType)
                                            //     ? Colors.white
                                            //     : Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: (chatData.send_by ==
                                                        controller.firestoreUser
                                                            .value!.userType)
                                                    ? Alignment.centerLeft
                                                    : Alignment.centerRight,
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  color: Colors.black12,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        chatData.message
                                                            .toString(),
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: (chatData
                                                                        .send_by ==
                                                                    controller
                                                                        .firestoreUser
                                                                        .value!
                                                                        .userType)
                                                                ? Colors.black
                                                                : Colors
                                                                    .blue[800]),
                                                      ),
                                                      // Text(
                                                      //   chatData.createdon
                                                      //       .toString(),
                                                      //   style: TextStyle(
                                                      //       fontSize: 10),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            padding: EdgeInsets.all(10),
                            //  margin:
                            //     EdgeInsets.only(top: MediaQuery.of(context).size.height - 150),
                            child: TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  suffixIcon: IconButton(
                                    color: Colors.black,
                                    icon: Icon(Icons.send),
                                    onPressed: () async {
                                      ChatModel chatModel = ChatModel(
                                          chat_id: chat_id,
                                          user_id: user_id,
                                          driver_id: driver_id,
                                          job_id: job_id,
                                          message: messageController.text,
                                          send_by: controller
                                              .firestoreUser.value!.userType,
                                          status: '1',
                                          type: 'text',
                                          updatedon: DateTime.now(),
                                          createdon: DateTime.now());
                                      if (messageController.text != '') {
                                        await FirestoreDb.addChat(chatModel);
                                      }

                                      messageController.text = '';
                                    },
                                  ),
                                )),
                          ))
                    ],
                  ))),
    );
  }
}
