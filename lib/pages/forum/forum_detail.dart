import 'dart:async';
import 'package:xculturetestapi/constants.dart';
import 'package:xculturetestapi/data.dart';
import 'dart:convert';
import 'package:xculturetestapi/arguments.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/forum/forum_edit.dart';
import 'package:xculturetestapi/pages/reply/reply_edit.dart';
import 'package:xculturetestapi/pages/comments/comment_edit.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:xculturetestapi/widgets/guesthamburger_widget.dart';

import '../../widgets/hamburger_widget.dart';
import '../report/report_page.dart';



class ForumDetailPage extends StatefulWidget {
  const ForumDetailPage({ Key? key }) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  Future<Forum>? fullDetail;

  final TextEditingController _contentComment = TextEditingController();
  final GlobalKey<FormState> _formKeyComment = GlobalKey<FormState>();
  final List<TextEditingController> _contentReplies = [];
  final List<bool> incognitoReplies = [];
  final List<bool> _favComments = [];
  final List<bool> _isReply = [];
  final List<bool> _isShowReply = [];
  final List<List<bool>> _favRepliesTotal = [];
  final List<GlobalKey<FormState>> _formKeyReplies = [];
  bool incognitoComment = false;
  bool incognitoReply = false;
  bool favourite = false;
  bool _favComment = false;
  bool _favReply = false;
  bool isReply = false;
  bool isShowReply = false;
  bool isFirstVisited = true;

  bool isTapFavForum = false;
  bool isTapComment = false;
  bool isTapConfirmDelete = false;
  final List<bool> isTapFavComments = [];
  final List<bool> isTapReplies = [];
  final List<List<bool>> isTapFavReplies = [];

  @override
  Widget build(BuildContext context) {
    final forumDetail = ModalRoute.of(context)!.settings.arguments as Forum;
    fullDetail = getFullDetail(forumDetail.id);

    if(isFirstVisited) {
      setState(() {
        forumViewed(forumDetail.id);
        isFirstVisited = !isFirstVisited;
      });
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<Forum>(
            future: fullDetail,
            builder: (BuildContext context, AsyncSnapshot<Forum> snapshot) {
              if (snapshot.hasData) {
                favourite = (AuthHelper.checkAuth() && snapshot.data!.favoritedBy.contains(AuthHelper.auth.currentUser!.uid)) ? true : false;
                var viewed = snapshot.data!.viewed.toString();
                var favorited = snapshot.data!.favorited.toString();
                var dt = DateTime.parse(snapshot.data!.updateDate).toLocal();
                String dateforum = DateFormat('MMMM dd, yyyy ??? HH:mm a').format(dt);
                for (var comment in snapshot.data!.comments) {
                  _favComment = (AuthHelper.checkAuth() && comment.favoritedBy.contains(AuthHelper.auth.currentUser!.uid));
                  final TextEditingController _contentReply = TextEditingController();
                  List<bool> _favRepliesPerComment = [];
                  List<bool> isTapFavRepliesPerComment = [];
                  var index = snapshot.data!.comments.indexOf(comment);
    
                  if(_contentReplies.length < snapshot.data!.comments.length) { // Depend on the amount of comments
                    _favComments.add(_favComment);
                    _isReply.add(isReply);
                    _isShowReply.add(isShowReply);
                    _contentReplies.add(_contentReply);
                    incognitoReplies.add(incognitoReply);
                    _formKeyReplies.add(GlobalKey<FormState>());
                    _favRepliesTotal.add(_favRepliesPerComment);
                    isTapFavComments.add(false);
                    isTapReplies.add(false);
                    isTapFavReplies.add(isTapFavRepliesPerComment);
                  }
                  
                  for(var reply in comment.replies) {
                    _favReply = (AuthHelper.checkAuth() && reply.favoritedBy.contains(AuthHelper.auth.currentUser!.uid));
                    if(_favRepliesTotal[index].length < comment.replies.length) { // Depend on the amount of replies
                      _favRepliesTotal[index].add(_favReply);
                      isTapFavReplies[index].add(false);
                    }
                  }
                }
    
                return Stack(
                    children: [
                    
                      // Thumbnail Image
                      Container(
                        margin: const EdgeInsets.only(right: 0, left: 0),
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data!.thumbnail),
                              fit: BoxFit.cover, 
                            )
                          ),
                        )
                      ),

                      // Iconbutton back
                      Container(
                        margin: const EdgeInsets.only(top: 40, left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.arrow_back),
                            iconSize: 30,
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),   
                      ),

                      // Iconbutton menu
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(top: 40, right: 20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Text("Edit"),
                                onTap: () async {
                                  if (AuthHelper.checkAuth() && snapshot.data!.author.id == AuthHelper.auth.currentUser!.uid) {
                                    await Future.delayed(const Duration(milliseconds: 1));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const EditForumPage(),
                                        settings: RouteSettings(
                                          arguments: snapshot.data,
                                        ),
                                      )
                                    ).then(refreshPage);
                                  }
                                  else {
                                    Fluttertoast.showToast(msg: "You are not the owner");
                                  }
                                },
                              ),
                              PopupMenuItem(
                                child: const Text("Delete"),
                                onTap: () async {
                                  if (AuthHelper.checkAuth() && snapshot.data!.author.id == AuthHelper.auth.currentUser!.uid) {
                                    await Future.delayed(const Duration(milliseconds: 1));
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Delete"),
                                        content: const Text("Do you really want to delete this event?"),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              //No
                                              Navigator.pop(context);
                                            }, 
                                            child: const Text("No", style: TextStyle(color: Colors.grey)),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              if (isTapConfirmDelete) {
                                                Fluttertoast.showToast(msg: "Please wait before press again");
                                              }
                                              else {
                                                setState(() {
                                                  isTapConfirmDelete = !isTapConfirmDelete;
                                                });
                                                var success = await deleteForum(snapshot.data!.id);
                                                if (success) {
                                                  Fluttertoast.showToast(msg: "Deleted");
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }
                                                else {
                                                  Navigator.pop(context);
                                                }
                                                setState(() {
                                                  isTapConfirmDelete = !isTapConfirmDelete;
                                                });
                                              }
                                            }, 
                                            child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                        elevation: 24.0,
                                      ),
                                    ); 
                                  }
                                  else {
                                    Fluttertoast.showToast(msg: "You are not the owner");
                                  }
                                },
                              ),
                              PopupMenuItem(
                                child: const Text("Report"),
                                onTap: () async {
                                  if (AuthHelper.checkAuth() && snapshot.data!.author.id != AuthHelper.auth.currentUser!.uid) {
                                    await Future.delayed(const Duration(milliseconds: 1));
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        builder: (context) => const ReportPage(),
                                        settings: RouteSettings(
                                          arguments: snapshot.data!.id,
                                        ),
                                      )
                                    ).then(refreshPage);
                                  } else {
                                    Fluttertoast.showToast(msg: "The owner can't report their forum");
                                  }
                                }
                              ),
                            ],
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 30,
                            ), 
                          ),
                        ),
                      ),
                     
                      //Contents
                      Container(
                        margin: const EdgeInsets.only(top: 280, left: 0, right: 0, bottom: 0),
                        //top: 280,
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Title with favorite button
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Text(snapshot.data!.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
                                      ),
                                    ),
                                  ),

                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: favourite == false ? const Icon(Icons.favorite_outline) : const Icon(Icons.favorite),
                                    color: Colors.red,
                                    iconSize: 40,
                                    onPressed: () async {
                                      if (isTapFavForum) {
                                        Fluttertoast.showToast(msg: "Please wait before tap again");
                                      }
                                      else {
                                        setState(() {
                                          isTapFavForum = !isTapFavForum;
                                        });
                                        if (favourite == false ) {
                                          favourite = true;
                                          var success = await forumFavorited(snapshot.data!.id);
                                          if(success) {
                                            Fluttertoast.showToast(msg: "Favorited.");
                                          }
                                        } else {
                                          favourite = false;
                                          var success = await forumUnfavorited(snapshot.data!.id);
                                          if(success) {
                                            Fluttertoast.showToast(msg: "Unfavorited.");
                                          }
                                        } 
                                        setState(() {
                                          isTapFavForum = !isTapFavForum;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),

                              // Subtitle
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.subtitle,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
    
                              // Tags
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: snapshot.data!.tags.map((tag) => Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Chip(
                                      label: Text(tag.name),
                                    ),
                                  )).toList(),
                                ),
                              ),

                              // Author
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: snapshot.data!.incognito == true ? const AssetImage("assets/images/User_icon.jpg") :
                                        snapshot.data!.author.profilePic == "" ? const AssetImage("assets/images/User_icon.jpg") : NetworkImage(snapshot.data!.author.profilePic) as ImageProvider,
                                    ),
                                    const SizedBox(width: 5),
                                    (snapshot.data!.incognito == false) ? Text(snapshot.data!.author.name) : const Text("Author")
                                  ],
                                ),
                              ),

                              // Date and Like/Favorite count
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Text(dateforum),
                                    const Spacer(),
                                    Row(
                                      children: [
                                          const Icon(Icons.visibility_sharp),
                                          const SizedBox(width: 5),
                                          Text(viewed),                    //total viewed
                                          const SizedBox(width: 5),
                                          const Icon(Icons.favorite),
                                          const SizedBox(width: 5),
                                          Text(favorited),                 //total favourite
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Division line
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Container(
                                    height: 1.0,
                                    width: 400,
                                    color: Colors.grey,
                                ),
                              ),

                              // Desc Header
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Description",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),

                              // Desc Content
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.content),
                              ),

                              // Comment Header
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Comments",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),

                              // Comment Box
                              Form(
                                key: _formKeyComment,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [

                                          const CircleAvatar(
                                            radius: 20,
                                            backgroundImage: AssetImage("assets/images/User_icon.jpg"),
                                          ),

                                          const SizedBox(width: 20),

                                          Expanded(
                                            child: TextFormField(
                                              controller: _contentComment,
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.all(15),
                                                hintText: "Type your comment here....",
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: const Icon(
                                                    Icons.send,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    if (isTapComment) {
                                                      Fluttertoast.showToast(msg: "Please wait before tap again");
                                                    }
                                                    else {
                                                      setState(() {
                                                        isTapComment = !isTapComment;
                                                      });
                                                      if(_formKeyComment.currentState!.validate()) {
                                                        var success = await sendCommentDetail(snapshot.data!.id, _contentComment.text, incognitoComment);
                                                        if (success) {
                                                          Fluttertoast.showToast(msg: "Your comment has been posted.");
                                                          refreshPage(snapshot.data!.id);
                                                        }
                                                      }
                                                      setState(() {
                                                        isTapComment = !isTapComment;
                                                        _contentComment.text = "";
                                                      });
                                                    }
                                                    
                                                  },
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return "Please enter comment";
                                                }
                                                else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          const Text("Incognito : "),
                                          Switch(
                                            value: incognitoComment, 
                                            onChanged: (value) {
                                              setState(() {
                                                incognitoComment = value;
                                              });
                                            }
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Commented List
                              ListView.builder(
                                itemCount: snapshot.data!.comments.length,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  var favComments = snapshot.data!.comments[index].favorited.toString();
                                  var replied = snapshot.data!.comments[index].replied.toString();
                                  var dt = DateTime.parse(snapshot.data!.comments[index].updateDate).toLocal();
                                  var datecomment = DateFormat('HH:mm a').format(dt);
                                  
                                  return Column(
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        child: Column(
                                          children: [

                                            ListTile(
                                              leading: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: snapshot.data!.comments[index].incognito == true ? const AssetImage("assets/images/User_icon.jpg") :
                                                        snapshot.data!.comments[index].author.profilePic == "" ? const AssetImage("assets/images/User_icon.jpg") : NetworkImage(snapshot.data!.comments[index].author.profilePic) as ImageProvider,
                                              ),
                                              title: Row(
                                                children: [

                                                  Expanded(
                                                    // Condition of incognito
                                                    child: (snapshot.data!.comments[index].incognito == false) ? 
                                                    Text(snapshot.data!.comments[index].author.name, 
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1
                                                    ) : const Text("Author",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                    ),
                                                  ),
                                                  // Date time
                                                  Text(datecomment, style: const TextStyle(fontSize: 12)),
                                                ],
                                              ),
                                              subtitle: Text(snapshot.data!.comments[index].content),
                                            ),
                                            Row(
                                              children: [

                                                Expanded(
                                                  child: TextButton(
                                                    child: Container(
                                                      alignment: Alignment.centerLeft,
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: Text(replied + " Replies"),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isShowReply[index] = !_isShowReply[index];
                                                      });
                                                    },
                                                  ),
                                                ),

                                                IconButton(
                                                  visualDensity: VisualDensity.compact,
                                                  icon: _favComments[index] == false ? const Icon(Icons.thumb_up_alt_outlined) : const Icon(Icons.thumb_up),
                                                  color: Colors.red,
                                                  iconSize: 20,
                                                  onPressed: () async {
                                                    if (isTapFavComments[index]) {
                                                      Fluttertoast.showToast(msg: "Please wait before tap again");
                                                    }
                                                    else {
                                                      setState(() {
                                                        isTapFavComments[index] = !isTapFavComments[index];
                                                      });
                                                      if (_favComments[index] == false ) {
                                                        _favComments[index] = true;
                                                        var success = await commentFavorited(snapshot.data!.id, snapshot.data!.comments[index].id);
                                                        if (success) {
                                                          Fluttertoast.showToast(msg: "Favorited Comment.");
                                                        }
                                                      } else {
                                                        _favComments[index] = false;
                                                        var success = await commentUnfavorited(snapshot.data!.id, snapshot.data!.comments[index].id);
                                                        if (success) {
                                                          Fluttertoast.showToast(msg: "Unfavorited Comment.");
                                                        }
                                                      }  
                                                      setState(() {
                                                        isTapFavComments[index] = !isTapFavComments[index];
                                                      });
                                                    }
                                                  },
                                                ),

                                                Text(favComments, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                                
                                                TextButton(
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.reply, size: 20),
                                                      SizedBox(width: 5),
                                                      Text('Reply'),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _isReply[index] = !_isReply[index];
                                                    });
                                                  },
                                                ),

                                                TextButton(
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.edit, size: 20),
                                                      SizedBox(width: 5),
                                                      Text('Edit'),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (AuthHelper.checkAuth() && snapshot.data!.comments[index].author.id == AuthHelper.auth.currentUser!.uid) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const EditCommentPage(),
                                                            settings: RouteSettings(
                                                              arguments: EditCommentArguments(
                                                                forumID: snapshot.data!.id, 
                                                                comment: snapshot.data!.comments[index]
                                                              ),
                                                            )
                                                          )
                                                        ).then(refreshPage);
                                                      }
                                                      else {
                                                        Fluttertoast.showToast(msg: "Only owner can edit this comment");
                                                      }
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Reply TextField
                                      Visibility(
                                        visible: _isReply[index],
                                        child: Form(
                                          key: _formKeyReplies[index],
                                          child: Card(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: Column(
                                                children: [

                                                  Row(
                                                    children: [

                                                      const CircleAvatar(
                                                        radius: 20,
                                                        backgroundImage: AssetImage("assets/images/User_icon.jpg"),
                                                      ),

                                                      const SizedBox(width: 20),

                                                      Expanded(
                                                        child: TextFormField(
                                                          controller: _contentReplies[index],
                                                          decoration: InputDecoration(
                                                            //contentPadding: const EdgeInsets.all(15),
                                                            hintText: "Type your reply....",
                                                            border: InputBorder.none,
                                                            suffixIcon: IconButton(
                                                              icon: const Icon(
                                                                Icons.reply,
                                                                color: Colors.red,
                                                                size: 30,
                                                              ),
                                                              onPressed: () async {
                                                                if (isTapReplies[index]) {
                                                                  Fluttertoast.showToast(msg: "Please wait before tap again");
                                                                }
                                                                else {
                                                                  setState(() {
                                                                    isTapReplies[index] = !isTapReplies[index];
                                                                  });
                                                                  if(_formKeyReplies[index].currentState!.validate()) {
                                                                    var success = await sendReplyDetail(snapshot.data!.id, snapshot.data!.comments[index].id, _contentReplies[index].text, incognitoReplies[index]);
                                                                    if (success) {
                                                                      Fluttertoast.showToast(msg: "Your reply has been posted.");
                                                                      refreshPage(snapshot.data!.id);
                                                                    }
                                                                  }
                                                                  setState(() {
                                                                    isTapReplies[index] = !isTapReplies[index];
                                                                    _contentReplies[index].text = "";
                                                                    _isReply[index] = false;
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return "Please enter reply";
                                                            }
                                                            else {
                                                              return null;
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  Row(
                                                    children: [
                                                      const Text("Incognito : "),
                                                      Switch(
                                                        value: incognitoReplies[index], 
                                                        onChanged: (value) {
                                                          setState(() {
                                                            incognitoReplies[index] = value;
                                                          });
                                                        }
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Reply List
                                      Visibility(
                                        visible: _isShowReply[index],
                                        child: ListView.builder(
                                          itemCount: snapshot.data!.comments[index].replies.length,
                                          shrinkWrap: true,
                                          physics: const ClampingScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index2) {
                                            var favReply = snapshot.data!.comments[index].replies[index2].favorited.toString();
                                            var dt = DateTime.parse(snapshot.data!.comments[index].replies[index2].updateDate).toLocal();
                                            String datereplies = DateFormat('HH:mm a').format(dt);
                                            return Container(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: Card(
                                                color: Colors.grey[200],
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                child: Column(
                                                  children: [
                                                    
                                                    ListTile(
                                                      leading: CircleAvatar(
                                                        radius: 20,
                                                        backgroundImage: snapshot.data!.comments[index].replies[index2].incognito == true ? const AssetImage("assets/images/User_icon.jpg") :
                                                        snapshot.data!.comments[index].replies[index2].author.profilePic == "" ? const AssetImage("assets/images/User_icon.jpg") : NetworkImage(snapshot.data!.comments[index].replies[index2].author.profilePic) as ImageProvider,
                                                      ),
                                                      title: Row(
                                                        children: [

                                                          Expanded(   
                                                            child: (snapshot.data!.comments[index].replies[index2].incognito == false) ? 
                                                              Text(snapshot.data!.comments[index].replies[index2].author.name, 
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                              ) : const Text("Author",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                              ),
                                                          ),

                                                          Text(datereplies, style: const TextStyle(fontSize: 12)),
                                                        ],
                                                      ),
                                                      subtitle: Text(snapshot.data!.comments[index].replies[index2].content),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [

                                                        IconButton(
                                                          visualDensity: VisualDensity.compact,
                                                          icon: _favRepliesTotal[index][index2] == false ? const Icon(Icons.thumb_up_alt_outlined) : const Icon(Icons.thumb_up),
                                                          color: Colors.red,
                                                          iconSize: 20,
                                                          onPressed: () async {
                                                            if (isTapFavReplies[index][index2]) {
                                                              Fluttertoast.showToast(msg: "Please wait before tap again");
                                                            }
                                                            else {
                                                              setState(() {
                                                                isTapFavReplies[index][index2] = !isTapFavReplies[index][index2];
                                                              });
                                                              if (_favRepliesTotal[index][index2] == false ) {
                                                                _favRepliesTotal[index][index2] = true;
                                                                var success = await replyFavorited(snapshot.data!.id, snapshot.data!.comments[index].id, snapshot.data!.comments[index].replies[index2].id);
                                                                if (success) {
                                                                  Fluttertoast.showToast(msg: "Favorited Reply.");
                                                                }
                                                              } else {
                                                                _favRepliesTotal[index][index2] = false;
                                                                var success = await replyUnfavorited(snapshot.data!.id, snapshot.data!.comments[index].id, snapshot.data!.comments[index].replies[index2].id);
                                                                if (success) {
                                                                  Fluttertoast.showToast(msg: "Unfavorited Reply.");
                                                                }
                                                              }  
                                                              setState(() {
                                                                isTapFavReplies[index][index2] = !isTapFavReplies[index][index2];
                                                              });
                                                            }
                                                          },
                                                        ),

                                                        Text(favReply, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                                        
                                                        TextButton(
                                                          child: Row(
                                                            children: const [
                                                              Icon(Icons.edit, size: 20),
                                                              SizedBox(width: 5),
                                                              Text('Edit'),
                                                            ],
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              if (AuthHelper.checkAuth() && snapshot.data!.comments[index].replies[index2].author.id == AuthHelper.auth.currentUser!.uid) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => const EditReplyPage(),
                                                                    settings: RouteSettings(
                                                                      arguments: EditReplyArguments(
                                                                        forumID: snapshot.data!.id, 
                                                                        commentID: snapshot.data!.comments[index].id,
                                                                        reply: snapshot.data!.comments[index].replies[index2]
                                                                      ),
                                                                    )
                                                                  )
                                                                ).then(refreshPage);
                                                              }
                                                              else {
                                                                Fluttertoast.showToast(msg: "Only owner can edit this reply");
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
              } else {
                  return const CircularProgressIndicator();
              }
            }
          ),
        ),
        endDrawer: AuthHelper.checkAuth() ? const NavigationDrawerWidget() : const GuestHamburger(),
        bottomNavigationBar: const Navbar(currentIndex: 2),
      ),
    );
  }

  FutureOr refreshPage(forumID) {
    setState(() {
      fullDetail = getFullDetail(forumID);
    });
  }

  Future<Forum> getFullDetail(forumID) async {
    final response =
        await http.get(Uri.parse('https://xculture-server.herokuapp.com/forums/$forumID'));

    if (response.statusCode == 200) {
      return Forum.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return Forum(id: "", title: "", subtitle: "", content: "", thumbnail: "", author: User(id: "", name: "", profilePic: "", bio: "", email: "", lastBanned: "", userType: "", bannedAmount: 0, tags: []), 
      incognito: false, viewed: 0, favorited: 0, createDate: DateTime.now().toString(), updateDate: DateTime.now().toString(), comments: [], tags: [], favoritedBy: []);
    }
  }
  
  Future<bool> forumViewed(forumID) async {
    final response = await http.put(
      Uri.parse('https://xculture-server.herokuapp.com/forums/$forumID/viewed'));
  
    if (response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }

  Future<bool> forumFavorited(forumID) async {
    final userToken = await AuthHelper.getToken();

    final response = await http.put(
      Uri.parse('https://xculture-server.herokuapp.com/forums/$forumID/favorite'), 
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }

  Future<bool> forumUnfavorited(forumID) async {
    final userToken = await AuthHelper.getToken();

    final response = await http.put(
      Uri.parse('https://xculture-server.herokuapp.com/forums/$forumID/unfavorite'),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }

  Future<bool> deleteForum(forumID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.delete(
      Uri.parse("https://xculture-server.herokuapp.com/forums/$forumID"),
      headers: <String, String> {
        'Authorization' : 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }

  Future<bool> sendCommentDetail(forumID, content, incognito) async {
    final userToken = await AuthHelper.getToken();

    final response = await http.post(
      Uri.parse('https://xculture-server.herokuapp.com/forums/$forumID/comments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken',
      },
      body: jsonEncode(<String, dynamic>{
        'content': content,
        'incognito': incognito,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }

  Future<bool> commentFavorited(forumID, commentID) async {
    final userToken = await AuthHelper.getToken();

    final response = await http.put(
      Uri.parse('https://xculture-server.herokuapp.com/forums/$forumID/comments/$commentID/favorite'),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }

  Future<bool> commentUnfavorited(forumID, commentID) async {
    final userToken = await AuthHelper.getToken();

    final response = await http.put(
      Uri.parse('https://xculture-server.herokuapp.com/forums/$forumID/comments/$commentID/unfavorite'),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }

  Future<bool> sendReplyDetail(forumID, commentID, content, incognito) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.post(
      Uri.parse('https://xculture-server.herokuapp.com/forums/$forumID/comments/$commentID/replies'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken'
      },
      body: jsonEncode(<String, dynamic>{
        'content': content,
        'incognito': incognito,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
    
  }

  Future<bool> replyFavorited(forumID, commentID, replyID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse('https://xculture-server.herokuapp.com/forums/$forumID/comments/$commentID/replies/$replyID/favorite'),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }

  Future<bool> replyUnfavorited(forumID, commentID, replyID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse('https://xculture-server.herokuapp.com/forums/$forumID/comments/$commentID/replies/$replyID/unfavorite'),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }


}