import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/modules/message/controller/message_controller.dart';
import 'package:mobile_banking_app/modules/message/widgets/custom_msg_items.dart';

class MessageView extends StatelessWidget {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          'Message',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: GetBuilder<MessageController>(
        builder: (controller) => ListView.builder(
          itemCount: controller.messages.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Get.to(() => controller.pages[index]);
            },
            child: CustomMsgItems(
              title: controller.messages[index]['title']!,
              subtitle: controller.messages[index]['subtitle']!,
              time: controller.messages[index]['time']!,
              image: controller.messages[index]['image']!,
            ),
          ),
        ),
      ),
    );
  }
}
