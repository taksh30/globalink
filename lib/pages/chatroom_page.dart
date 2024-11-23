import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:globalink/models/messages.dart';
import 'package:globalink/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatroomPage extends StatefulWidget {
  const ChatroomPage(
      {super.key, required this.chatroomName, required this.chatroomId});
  final String chatroomName;
  final String chatroomId;

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  final _messageCtr = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> _sendMessage() async {
    final name =
        Provider.of<UserProvider>(context, listen: false).currentUser?.name ??
            '';
    final text = _messageCtr.text;
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser?.id ?? '';

    if (text.isEmpty) {
      return;
    }

    // prepare message to send
    Messages message = Messages(
      name: name,
      text: text,
      chatroomId: widget.chatroomId,
      timestamp: FieldValue.serverTimestamp(),
      userId: userId,
    );

    try {
      // send message
      await db.collection('messages').add(message.toJson());
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    // clear the message
    _messageCtr.clear();
  }

  // load all messages in realtime
  Stream<List<Messages>> _getMessages(String chatroomId) {
    return db
        .collection('messages')
        .where('chatroom_id', isEqualTo: chatroomId)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Messages.fromJson(doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatroomName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Messages>>(
                stream: _getMessages(widget.chatroomId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  final messages = snapshot.data ?? [];

                  // show messages
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      String? userId =
                          Provider.of<UserProvider>(context).currentUser?.id;

                      return ListTile(
                        title: Text(
                          textAlign: message.userId == userId
                              ? TextAlign.end
                              : TextAlign.start,
                          message.name,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          textAlign: message.userId == userId
                              ? TextAlign.end
                              : TextAlign.start,
                          message.text,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 19.0,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // message field
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _messageCtr,
                      decoration: InputDecoration(
                        hintText: 'Write Message Here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// send button
                IconButton(
                  // on send button pressed
                  onPressed: _sendMessage,
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
