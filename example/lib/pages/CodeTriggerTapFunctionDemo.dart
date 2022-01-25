import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class CodeTriggerTapFunctionDemo extends StatelessWidget {
  const CodeTriggerTapFunctionDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CodeTriggerTapFunctionDemo'),
      ),
      body: Center(
        child: AgreeAndDisagreeBar(),
      ),
    );
  }
}

class AgreeAndDisagreeBar extends StatefulWidget {
  AgreeAndDisagreeBar({Key? key}) : super(key: key);

  @override
  _AgreeAndDisagreeBarState createState() => _AgreeAndDisagreeBarState();
}

class _AgreeAndDisagreeBarState extends State<AgreeAndDisagreeBar> {
  bool like = false;
  bool dislike = false;

  bool like2 = false;
  bool dislike2 = false;

  late Function agreeTap;
  late Function disagreeTap;

  late Function agreeTap2;
  late Function disagreeTap2;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Wait anime Demo"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LikeButton(
                //get tap function
                getTapFunction: (tapFunction) => agreeTap = tapFunction,
                //enable tap when animating,tap function will be called after anime finished
                disableTapWhenAnimating: false,
                onTap: (isLiked) async {
                  like = !isLiked;
                  if (!isLiked && dislike) {
                    disagreeTap();
                  }
                  return !isLiked;
                },
                likeBuilder: (isLiked) {
                  if (!isLiked) {
                    return const Icon(
                      Icons.thumb_up_alt_outlined,
                      color: Colors.black,
                    );
                  } else {
                    return const Icon(Icons.thumb_up_alt, color: Colors.blue);
                  }
                },
                likeCount: 0,
              ),
              LikeButton(
                //get tap function
                getTapFunction: (tapFunction) => disagreeTap = tapFunction,
                //enable tap when animating,tap function will be called after anime finished
                disableTapWhenAnimating: false,
                onTap: (isLiked) async {
                  dislike = !isLiked;
                  if (!isLiked && like) {
                    agreeTap();
                  }
                  return !isLiked;
                },
                likeBuilder: (isLiked) {
                  if (!isLiked) {
                    return const Icon(
                      Icons.thumb_down_alt_outlined,
                      color: Colors.black,
                    );
                  } else {
                    return const Icon(Icons.thumb_down_alt, color: Colors.blue);
                  }
                },
                likeCount: 0,
              )
            ],
          ),
          Text("Rapid Trigger Demo"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LikeButton(
                //get tap function
                getTapFunction: (tapFunction) => agreeTap2 = tapFunction,
                //enable tap when animating,tap function will be called after anime finished
                disableTapWhenAnimating: false,
                //don't wait for anime finishing
                rapidTriggerTap: true,
                onTap: (isLiked) async {
                  like2 = !isLiked;
                  if (!isLiked && dislike2) {
                    disagreeTap2();
                  }
                  return !isLiked;
                },
                likeBuilder: (isLiked) {
                  if (!isLiked) {
                    return const Icon(
                      Icons.thumb_up_alt_outlined,
                      color: Colors.black,
                    );
                  } else {
                    return const Icon(Icons.thumb_up_alt, color: Colors.blue);
                  }
                },
                likeCount: 0,
              ),
              LikeButton(
                //get tap function
                getTapFunction: (tapFunction) => disagreeTap2 = tapFunction,
                //enable tap when animating,tap function will be called after anime finished
                disableTapWhenAnimating: false,
                //don't wait for anime finishing
                rapidTriggerTap: true,
                onTap: (isLiked) async {
                  dislike2 = !isLiked;
                  if (!isLiked && like2) {
                    agreeTap2();
                  }
                  return !isLiked;
                },
                likeBuilder: (isLiked) {
                  if (!isLiked) {
                    return const Icon(
                      Icons.thumb_down_alt_outlined,
                      color: Colors.black,
                    );
                  } else {
                    return const Icon(Icons.thumb_down_alt, color: Colors.blue);
                  }
                },
                likeCount: 0,
              )
            ],
          )
        ],
      ),
    );
  }
}
