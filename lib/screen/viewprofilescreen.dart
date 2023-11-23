import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/helper/mydateutil.dart';
import 'package:chitchat/models/chatuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chitchat/main.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});
  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.user.Name),
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.indigo),
        ),

        floatingActionButton: 
        Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Joined On : ', 
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                    ),

                    Text(MyDateUtil.getLastMessageTime(
                      context: context, 
                      time: widget.user.CreateAt,
                      showYear: true),
                        style:
                            const TextStyle(color: Colors.black54, fontSize: 16)),
                  ],
                ),
        
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: mq.width,
                  height: mq.height * .03,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 1),
                  child: CachedNetworkImage(
                  width: mq.height * .2,
                  height: mq.height * .2,
                  fit: BoxFit.fill,
                  imageUrl: widget.user.Image,
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(
                          child: Icon(CupertinoIcons.person))),
                ),
                SizedBox(height: mq.height * .03),
                Text(widget.user.Email,
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 16)),
                
                SizedBox(height: mq.height * .02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('About : ', 
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                    ),

                    Text(widget.user.About,
                        style:
                            const TextStyle(color: Colors.black54, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
