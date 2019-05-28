import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

///
///  create by zhoumaotuo on 2019/5/27
///

const double buttonSize = 40.0;

class LikeButtonDemo extends StatefulWidget {
  @override
  _LikeButtonDemoState createState() => _LikeButtonDemoState();
}

class _LikeButtonDemoState extends State<LikeButtonDemo> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(children: <Widget>[
      AppBar(
        title: Text("Like Button Demo"),
      ),
      Expanded(
        child: GridView(
          children: <Widget>[
            LikeButton(size: buttonSize),
            LikeButton(
              size: buttonSize,
              circleStartColor: Color(0xff00ddff),
              circleEndColor: Color(0xff0099cc),
              dotColor: DotColor(
                dotPrimaryColor: Color(0xff33b5e5),
                dotSecondaryColor: Color(0xff0099cc),
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.home,
                  color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                  size: buttonSize,
                );
              },
            ),
            LikeButton(
              size: buttonSize,
              circleStartColor: Color(0xff669900),
              circleEndColor: Color(0xff669900),
              dotColor: DotColor(
                dotPrimaryColor: Color(0xff669900),
                dotSecondaryColor: Color(0xff99cc00),
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.adb,
                  color: isLiked ? Colors.green : Colors.grey,
                  size: buttonSize,
                );
              },
            ),
            LikeButton(
              size: buttonSize,
              isLiked: true,
              circleStartColor: Colors.redAccent[100],
              circleEndColor: Colors.redAccent[400],
              dotColor: DotColor(
                dotPrimaryColor: Colors.red[300],
                dotSecondaryColor: Colors.red[200],
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.assistant_photo,
                  color: isLiked ? Colors.red : Colors.grey,
                  size: buttonSize,
                );
              },
            ),
            LikeButton(
              size: buttonSize,
              circleStartColor: Colors.pinkAccent[200],
              circleEndColor: Colors.pinkAccent[400],
              dotColor: DotColor(
                dotPrimaryColor: Colors.lightBlue[300],
                dotSecondaryColor: Colors.lightBlue[200],
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.insert_emoticon,
                  color: isLiked ? Colors.lightBlueAccent : Colors.grey,
                  size: buttonSize,
                );
              },
            ),
            LikeButton(
              size: buttonSize,
              circleStartColor: Colors.grey[200],
              circleEndColor: Colors.grey[400],
              dotColor: DotColor(
                dotPrimaryColor: Colors.grey[600],
                dotSecondaryColor: Colors.grey[200],
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.cloud,
                  color: isLiked ? Colors.grey[900] : Colors.grey,
                  size: buttonSize,
                );
              },
            ),
          ],
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        ),
      )
    ]));
  }
}
