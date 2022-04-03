import 'package:flutter/material.dart';

class Forum {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String thumbnail;
  final User author;
  final bool incognito;
  final int viewed;
  final int favorited;
  final String date;
  final String updateDate;
  final List<Comment> comments; 
  final List<Tag> tags;
  final List<String> favoritedBy;

  Forum({
    required this.id, 
    required this.title,
    required this.subtitle,
    required this.content,
    required this.thumbnail, 
    required this.author,
    required this.incognito,
    required this.viewed,
    required this.favorited,
    required this.date,
    required this.updateDate,
    required this.comments,
    required this.tags,
    required this.favoritedBy,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      content: json['content'],
      thumbnail: json['thumbnail'],
      author: getAuthorFromJson(json['author']),
      incognito: json['incognito'],
      viewed: json['viewed'],
      favorited: json['favorite_amount'],
      date: json['date'],
      updateDate: json['update_date'],
      comments: getCommentsFromJson(json['comments']),
      tags: getTagsFromJson(json['tags']),
      favoritedBy: getFavoritedByFromJson(json['favoritedBy'])
    );
  }

  static User getAuthorFromJson(author) {
    return User.formJson(author);
  }

  static List<Comment> getCommentsFromJson(comments) {
    List<Comment> list = [];
    if(comments != null) {
      comments.forEach( (obj) => list.add(Comment.fromJson(obj)));
      list.sort((a, b) => a.id.compareTo(b.id));
    }
    return list;
  }

  static List<Tag> getTagsFromJson(tags) {
    List<Tag> list = [];
    if(tags != []) {
      tags.forEach( (obj) => list.add(Tag.fromOtherClassJson(obj)));
      list.sort((a, b) => a.id.compareTo(b.id));
    }
    return list;
  }

  static List<String> getFavoritedByFromJson(users) {
    List<String> list = [];
    if(users != null) {
      users.forEach( (user) => list.add(user['user']['id']));
    }

    return list;
  }
}

class Comment {
  final int id;
  final String content;
  final User author;
  final bool incognito;
  final int replied;
  final int favorited;
  final String date;
  final String updateDate;
  final List<Reply> replies;
  final List<String> favoritedBy;

  Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.incognito,
    required this.replied,
    required this.favorited,
    required this.date,
    required this.updateDate,
    required this.replies,
    required this.favoritedBy,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      content: json["body"],
      author: getAuthorFromJson(json['author']),
      incognito: json["incognito"],
      replied: json["reply_amount"],
      favorited: json["liked"],
      date: json["date"],
      updateDate: json["update_date"],
      replies: getRepliesFromJson(json["replies"]),
      favoritedBy: getFavoritedByFromJson(json["favoritedBy"])
    );
  }

  static User getAuthorFromJson(author) {
    return User.formJson(author);
  }

  static List<Reply> getRepliesFromJson(replies) {
    List<Reply> list = [];
    if (replies != null) {
      replies.forEach( (obj) => list.add(Reply.fromJson(obj)));
      list.sort((a, b) => a.id.compareTo(b.id));
    }
    return list;

  }

  static List<String> getFavoritedByFromJson(users) {
    List<String> list = [];
    if(users != null) {
      users.forEach( (user) => list.add(user['user']['id']));
    }

    return list;
  }
}

class Reply {
  final int id;
  final String content;
  final User author;
  final bool incognito;
  final int favorited;
  final String date;
  final String updateDate;
  final List<String> favoritedBy;

  Reply({
    required this.id,
    required this.content,
    required this.author,
    required this.incognito,
    required this.favorited,
    required this.date,
    required this.updateDate,
    required this.favoritedBy,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json["id"],
      content: json["body"],
      author: getAuthorFromJson(json["author"]),
      incognito: json["incognito"],
      favorited: json["liked_reply"],
      date: json["date"],
      updateDate: json["update_date"],
      favoritedBy: getFavoritedByFromJson(json["favoritedBy"])
    );
  }

  static User getAuthorFromJson(author) {
    return User.formJson(author);
  }

  static List<String> getFavoritedByFromJson(users) {
    List<String> list = [];
    if(users != null) {
      users.forEach( (user) => list.add(user['user']['id']));
    }

    return list;
  }
}

class Tag {
  final int id;
  final String name;
  final int usage;

  Tag({
    required this.id,
    required this.name,
    required this.usage,
  });

  factory Tag.fromOtherClassJson(Map<String, dynamic> json) {
    return Tag(
      id: json["tag"]["id"],
      name: json["tag"]["name"],
      usage: json["tag"]["usage_amount"],
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json["id"],
      name: json["name"],
      usage: json["usage_amount"],
    );
  }

  @override
  String toString() => name;

  @override
  operator == (other) => other is Tag && other.id == id;

  @override
  int get hashCode => id.hashCode^name.hashCode;
}

class User {
  final String id;
  final String name;
  final String profilePic;
  final String? bio;
  final String? email;
  final List<Tag>? tags;

  User({
    required this.id,
    required this.name,
    required this.profilePic,
    required this.bio,
    required this.email,
    required this.tags
  });

  factory User.formJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      email: json['email'],
      profilePic: json['profile_pic'],
      tags: getTagsFromJson(json['tags'])
    );
  }

  factory User.fromMemberJson(Map<String, dynamic> json) {
    return User(
      id: json['member']['id'], 
      name: json['member']['name'],
      bio: json['member']['bio'],
      email: json['member']['email'],
      profilePic: json['member']['profile_pic'],
      tags: getTagsFromJson(json['member']['tags'])
    );
  }

  static List<Tag> getTagsFromJson(tags) {
    List<Tag> list = [];
    if(tags != [] && tags != null) {
      tags.forEach( (obj) => list.add(Tag.fromOtherClassJson(obj)));
      list.sort((a, b) => a.id.compareTo(b.id));
    }
    return list;
  }
}

class Community {
  final String id;
  final String name;
  final String shortdesc;
  final String desc;
  final String thumbnail;
  final int memberAmount;
  final User owner;
  final String date;
  final List<User> members;

  Community({
    required this.id,
    required this.name,
    required this.shortdesc,
    required this.desc,
    required this.thumbnail,
    required this.memberAmount,
    required this.date,
    required this.owner,
    required this.members,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'], 
      name: json['name'], 
      shortdesc: json['shortdesc'], 
      desc: json['desc'], 
      thumbnail: json['thumbnail'], 
      memberAmount: json['member_amount'], 
      date: json['date'], 
      owner: User.formJson(json['owner']), 
      members: getMembersFromJson(json['members'])
    );
  }

  static List<User> getMembersFromJson(members) {
    List<User> list = [];
    if(members != null) {
      members.forEach( (member) => list.add(User.fromMemberJson(member)));
      list.sort((a, b) => a.id.compareTo(b.id));
    }
    return list;
  }
}

class Event {
  final String id;
  final String name;
  final String body;
  final String thumbnail;
  final String location;
  final int interestedAmount;
  final String date;
  final User host;
  final List<User> members;

  Event({
    required this.id,
    required this.name,
    required this.body,
    required this.thumbnail,
    required this.location,
    required this.interestedAmount,
    required this.date,
    required this.host,
    required this.members
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'], 
      name: json['name'], 
      body: json['body'], 
      thumbnail: json['thumbnail'], 
      location: json['location'], 
      interestedAmount: json['interested_amount'], 
      date: json['date'], 
      host: User.formJson(json['host']), 
      members: getMembersFromJson(json['members']),
    );
  } 

  static List<User> getMembersFromJson(members) {
    List<User> list = [];
    if(members != null) {
      members.forEach( (member) => list.add(User.fromMemberJson(member)));
      list.sort((a, b) => a.id.compareTo(b.id));
    }
    return list;
  }
}

class ServerResponse {
  final int status;
  final String message;

  ServerResponse({
    required this.status,
    required this.message
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(status: json['statusCode'], message: json['message']);
  }
}

