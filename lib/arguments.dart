import 'data.dart';

class EditCommentArguments {
  final String forumID;
  final Comment comment;

  EditCommentArguments({
    required this.forumID,
    required this.comment,
  });
}

class EditReplyArguments {
  final String forumID;
  final int commentID;
  final Reply reply;
  
  EditReplyArguments({
    required this.forumID,
    required this.commentID,
    required this.reply,
  });
}

class ChatRoomArguments {
  final String commuID;
  final Room room;

  ChatRoomArguments({
    required this.commuID,
    required this.room,
  });
}

class FilterArguments {
  final Community commu;
  final int member;

  FilterArguments({
    required this.commu,
    required this.member,
  });
}