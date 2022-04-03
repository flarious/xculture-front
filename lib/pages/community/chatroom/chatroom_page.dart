import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({ Key? key }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  List<Message> messages = [
    Message(
      text: "Yes sure!",
      date: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: false,
    ),
    Message(
      text: "No sure!",
      date: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: true,
    ),
    Message(
      text: "galley of type and scrambled it to make a type specimen book.",
      date: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: false,
    ),
    Message(
      text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
      date: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: false,
    ),
  ].reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: const Color.fromRGBO(220, 71, 47, 1),
        title: Text("# Lorem Ipsum"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text("Edit"),
                  onTap: (){
                    //
                  },
                ),
                PopupMenuItem(
                  child: const Text("Delete"),
                  onTap: (){
                    //delete
                  },
                ),
              ],
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 30,
              ), 
            ),
          ),
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(10),
              reverse: true,
              order: GroupedListOrder.DESC,
              //useStickyGroupSeparators: true,
              //floatingHeader: true,
              elements: messages,
              groupBy: (message) => DateTime(
                message.date.year,
                message.date.month,
                message.date.day,
              ),
              groupHeaderBuilder: (Message message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(DateFormat.yMMMd().format(message.date)),
                ),
              ),
              itemBuilder: (context, Message message) => message.isSentByMe 
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Card(
                        elevation: 8,
                        color: const Color.fromRGBO(220, 71, 47, 1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(message.text,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: message.date.hour.toString(),
                            style: TextStyle(color: Colors.grey),
                            children: [
                              const TextSpan(text: ":", style: TextStyle(color: Colors.grey),),
                              TextSpan(text: message.date.minute.toString(), style: TextStyle(color: Colors.grey),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: AssetImage("assets/images/tomoe.jpg"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("Mr. ABC"),
                        ),
                      ],
                    ),
                    Card(
                      elevation: 8,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(message.text),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: message.date.hour.toString(),
                          style: TextStyle(color: Colors.grey),
                          children: [
                            const TextSpan(text: ":", style: TextStyle(color: Colors.grey),),
                            TextSpan(text: message.date.minute.toString(), style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            )
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        hintText: "Type your message here....",
                        border: InputBorder.none,
                        suffixIcon: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color.fromRGBO(220, 71, 47, 1),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onSubmitted: (text) {
                        final message = Message(
                          text: text,
                          date: DateTime.now(),
                          isSentByMe: true,
                        );
                        setState(() {
                          messages.add(message);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}