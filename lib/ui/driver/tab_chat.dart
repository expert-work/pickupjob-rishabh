import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../controllers/controllers.dart';
import '../ui.dart';

class TabChatDriver extends StatefulWidget {
  const TabChatDriver({super.key});

  @override
  State<TabChatDriver> createState() => _TabChatDriverState();
}

class _TabChatDriverState extends State<TabChatDriver> {
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) => controller.firestoreUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                body: GetX<ChatListController>(
                  init: Get.put<ChatListController>(ChatListController()),
                  builder: (ChatListController chatListController) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: chatListController.chatLists_driver.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(chatListController.chatLists_driver[index]);
                          final chatListData =
                              chatListController.chatLists_driver[index];
                          return Container(
                              padding: EdgeInsets.all(15),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 40,
                                        padding: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Image.network(
                                          chatListData.user_image.toString(),
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    2 /
                                                    3 -
                                                80,
                                        child: Text(
                                          chatListData.user_name.toString() +
                                              ' - ' +
                                              chatListData.job_title.toString(),
                                          style: TextStyle(
                                              overflow: TextOverflow.clip,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                          icon: const Icon(
                                            Icons.message,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Get.to(() => Chat(), arguments: {
                                              "chat_id": chatListData.chat_id,
                                              "user_id": chatListData.user_id,
                                              "user_name":
                                                  chatListData.user_name,
                                              "user_image":
                                                  chatListData.user_image,
                                              "driver_id":
                                                  chatListData.driver_id,
                                              "driver_name":
                                                  chatListData.driver_name,
                                              "driver_image":
                                                  chatListData.driver_image,
                                              "job_id": chatListData.job_id,
                                              "job_title":
                                                  chatListData.job_title,
                                              "status": chatListData.status,
                                              "updatedon":
                                                  chatListData.updatedon,
                                              "createdon":
                                                  chatListData.createdon
                                            });
                                          })
                                    ],
                                  ),
                                ],
                              ));
                        },
                      ),
                    );
                  },
                ),
              ));
  }
}
