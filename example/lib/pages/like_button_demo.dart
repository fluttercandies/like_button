import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

///
///  create by zhoumaotuo on 2019/5/27
///

const double buttonSize = 40.0;

@FFRoute(
  name: 'fluttercandies://LikeButtonDemo',
  routeName: 'like button',
  description: 'show how to build like button',
)
class LikeButtonDemo extends StatefulWidget {
  @override
  _LikeButtonDemoState createState() => _LikeButtonDemoState();
}

class _LikeButtonDemoState extends State<LikeButtonDemo> {
  final int likeCount = 999;
  final GlobalKey<LikeButtonState> _globalKey = GlobalKey<LikeButtonState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Like Button Demo'),
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300),
        children: <Widget>[
          LikeButton(
            size: buttonSize,
            likeCount: likeCount,
            key: _globalKey,
            isLiked: true,
            postFrameCallback: (LikeButtonState state) {
              state.controller?.forward();
            },
            countBuilder: (int? count, bool isLiked, String text) {
              final ColorSwatch<int> color =
                  isLiked ? Colors.pinkAccent : Colors.grey;
              Widget result;
              if (count == 0) {
                result = Text(
                  'love',
                  style: TextStyle(color: color),
                );
              } else
                result = Text(
                  count! >= 1000
                      ? (count / 1000.0).toStringAsFixed(1) + 'k'
                      : text,
                  style: TextStyle(color: color),
                );
              return result;
            },
            likeCountAnimationType: likeCount < 1000
                ? LikeCountAnimationType.part
                : LikeCountAnimationType.none,
            likeCountPadding: const EdgeInsets.only(left: 15.0),
            onTap: onLikeButtonTapped,
          ),
          LikeButton(
            size: buttonSize,
            circleColor: const CircleColor(
                start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: const BubblesColor(
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
            likeCount: 665,
            countBuilder: (int? count, bool isLiked, String text) {
              final ColorSwatch<int> color =
                  isLiked ? Colors.deepPurpleAccent : Colors.grey;
              Widget result;
              if (count == 0) {
                result = Text(
                  'love',
                  style: TextStyle(color: color),
                );
              } else
                result = Text(
                  text,
                  style: TextStyle(color: color),
                );
              return result;
            },
            likeCountPadding: const EdgeInsets.only(left: 15.0),
          ),
          LikeButton(
            size: buttonSize,
            circleColor: const CircleColor(
                start: Color(0xff669900), end: Color(0xff669900)),
            bubblesColor: const BubblesColor(
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
            likeCount: 665,
            likeCountAnimationType: LikeCountAnimationType.all,
            countBuilder: (int? count, bool isLiked, String text) {
              final MaterialColor color = isLiked ? Colors.green : Colors.grey;
              Widget result;
              if (count == 0) {
                result = Text(
                  'love',
                  style: TextStyle(color: color),
                );
              } else
                result = Text(
                  text,
                  style: TextStyle(color: color),
                );
              return result;
            },
            likeCountPadding: const EdgeInsets.only(left: 15.0),
          ),
          LikeButton(
            size: buttonSize,
            isLiked: null,
            circleColor: CircleColor(
              start: Colors.redAccent[100]!,
              end: Colors.redAccent[400]!,
            ),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Colors.red[300]!,
              dotSecondaryColor: Colors.red[200]!,
            ),
            likeBuilder: (bool isLiked) {
              return const Icon(
                Icons.assistant_photo,
                color: Colors.red,
                size: buttonSize,
              );
            },
            likeCount: 888,
            countBuilder: (int? count, bool isLiked, String text) {
              return Text(
                count == 0 ? 'love' : text,
                style: const TextStyle(color: Colors.red),
              );
            },
            likeCountPadding: const EdgeInsets.only(left: 15.0),
          ),
          LikeButton(
            size: buttonSize,
            circleColor: CircleColor(
                start: Colors.pinkAccent[200]!, end: Colors.pinkAccent[400]!),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Colors.lightBlue[300]!,
              dotSecondaryColor: Colors.lightBlue[200]!,
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
            isLiked: null,
            circleColor: CircleColor(
              start: Colors.grey[200]!,
              end: Colors.grey[400]!,
            ),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Colors.grey[600]!,
              dotSecondaryColor: Colors.grey[200]!,
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.cloud,
                color: isLiked ? Colors.grey[900] : Colors.grey,
                size: buttonSize,
              );
            },
            likeCount: 888,
            countPostion: CountPostion.left,
            countBuilder: (int? count, bool isLiked, String text) {
              return Text(
                count == 0 ? 'love' : text,
                style: const TextStyle(color: Colors.grey),
              );
            },
            likeCountPadding: const EdgeInsets.only(right: 15.0),
          ),
          LikeButton(
            size: buttonSize,
            isLiked: null,
            circleColor: CircleColor(
              start: Colors.indigoAccent[200]!,
              end: Colors.indigoAccent[400]!,
            ),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Colors.indigoAccent[700]!,
              dotSecondaryColor: Colors.indigoAccent[200]!,
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.access_alarm,
                color: isLiked ? Colors.indigoAccent[700] : Colors.grey,
                size: buttonSize,
              );
            },
            likeCount: 888,
            countPostion: CountPostion.bottom,
            countBuilder: (int? count, bool isLiked, String text) {
              return Text(
                text,
                style: const TextStyle(color: Colors.grey),
              );
            },
            likeCountPadding: const EdgeInsets.only(top: 15.0),
            countDecoration: (Widget count, int? likeCount) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  count,
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text(
                    'loves',
                    style: TextStyle(color: Colors.indigoAccent),
                  )
                ],
              );
            },
          ),
          LikeButton(
            size: buttonSize,
            isLiked: null,
            circleColor: CircleColor(
              start: Colors.orange[200]!,
              end: Colors.orange[400]!,
            ),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Colors.orange[600]!,
              dotSecondaryColor: Colors.orange[200]!,
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.camera_alt,
                color: isLiked ? Colors.orange[900] : Colors.grey,
                size: buttonSize,
              );
            },
            likeCount: 888,
            countPostion: CountPostion.top,
            countBuilder: (int? count, bool isLiked, String text) {
              return Text(
                text,
                style: const TextStyle(color: Colors.grey),
              );
            },
            likeCountPadding: const EdgeInsets.only(bottom: 15.0),
            countDecoration: (Widget count, int? likeCount) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  count,
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text(
                    'loves',
                    style: TextStyle(color: Colors.orange),
                  )
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.favorite),
        onPressed: () {
          _globalKey.currentState!.onTap();
        },
      ),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }
}
