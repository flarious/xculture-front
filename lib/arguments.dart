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