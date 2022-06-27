import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo/models/message_model.dart';
import 'package:shamo/models/product_model.dart';
import 'package:shamo/providers/auth_provider.dart';
import 'package:shamo/services/message_service.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/chat_bubble.dart';

class DetailChatPage extends StatefulWidget {
  ProductModel product;
  DetailChatPage(this.product);

  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  TextEditingController messageController = TextEditingController(text: '');
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleAddMessage() async {
      if (messageController.text != '') {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(microseconds: 300), curve: Curves.easeOut);
        await MessageService().addMessage(
          user: authProvider.user,
          isFromUser: true,
          product: widget.product,
          message: messageController.text,
        );

        setState(() {
          widget.product = UninitializedProductModel();
          messageController.text = '';
        });
      }
    }

    Widget productPreview() {
      return Container(
        width: 225,
        height: 74,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: backgroundCalor5,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: priceColor,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/shoes.png',
                width: 54,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.product.name,
                    style: primaryTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    '\$${widget.product.price} ',
                    style: priceTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.product = UninitializedProductModel();
                });
              },
              child: Image.asset(
                'assets/close.png',
                width: 22,
              ),
            ),
          ],
        ),
      );
    }

    Widget content() {
      return StreamBuilder<List<MessageModel>>(
          stream: MessageService()
              .getMessagesByUserId(userId: authProvider.user.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                reverse: true,
                controller: scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultMargin,
                ),
                children: snapshot.data
                    .map((MessageModel message) => ChatBubble(
                          isSender: message.isFromUser,
                          text: message.message,
                          product: message.product,
                        ))
                    .toList()
                    .reversed
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(' ${snapshot.hasData} '),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    }

    Widget chatInput() {
      return Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.product is UninitializedProductModel
                ? SizedBox()
                : productPreview(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundCalor4,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextFormField(
                        controller: messageController,
                        style: primaryTextStyle,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type Message ... ',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: handleAddMessage,
                  child: Image.asset(
                    'assets/send_button.png',
                    width: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundCalor3,
      appBar: AppBar(
        backgroundColor: backgroundCalor1,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/shop_online.png',
              width: 50,
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shoe Store',
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Online',
                  style: secondaryTextStyle.copyWith(
                    fontWeight: light,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: content(),
      bottomNavigationBar: chatInput(),
    );
  }
}
