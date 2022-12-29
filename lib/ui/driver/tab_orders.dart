import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../controllers/controllers.dart';
import '../ui.dart';

class TabOrdersDriver extends StatefulWidget {
  const TabOrdersDriver({super.key});

  @override
  State<TabOrdersDriver> createState() => _TabOrdersDriverState();
}

class _TabOrdersDriverState extends State<TabOrdersDriver> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) => controller.firestoreUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                child: Stack()));
  }
}
