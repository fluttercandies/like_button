# like_button

[like_button ![pub package](https://img.shields.io/pub/v/like_button.svg)](https://pub.dartlang.org/packages/like_button)

文档语言: [English](README.md) | [中文简体](README-ZH.md)

Like Button 支持推特点赞效果和喜欢数量动画的Flutter库.

感谢 [jd-alexander](https://github.com/jd-alexander/LikeButton) and [吉原拉面](https://github.com/yumi0629/FlutterUI/tree/master/lib/likebutton) 对点赞动画的原理的开源。

[Flutter 仿掘金推特点赞按钮](https://juejin.im/post/5cee3b43e51d45773f2e8ed7)  

![](https://github.com/fluttercandies/Flutter_Candies/blob/master/gif/like_button/like_button.gif)

![](https://github.com/fluttercandies/Flutter_Candies/blob/master/gif/like_button/photo_view.gif)

- [like_button](#likebutton)
  - [How to use it.](#How-to-use-it)
  - [The time to send your request](#The-time-to-send-your-request)
  - [parameters](#parameters)

##  如何使用.

默认效果是Icons.favorite
```dart
  LikeButton(),
```

你可以自定义一些效果，比如颜色，比如喜欢数量显示，
```dart
  LikeButton(
          size: buttonSize,
          circleColor:
              CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
          bubblesColor: BubblesColor(
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
          countBuilder: (int count, bool isLiked, String text) {
            var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
            Widget result;
            if (count == 0) {
              result = Text(
                "love",
                style: TextStyle(color: color),
              );
            } else
              result = Text(
                text,
                style: TextStyle(color: color),
              );
            return result;
          },
        ),
```

## 什么时候去请求服务改变状态
```dart
  LikeButton(
        onTap: (bool isLiked) 
        {
          return onLikeButtonTap(isLiked, item);
          },)
```
这是一个异步回调，你可以等待服务返回之后再改变状态。也可以先改变状态，请求失败之后重置回状态
```dart
  Future<bool> onLikeButtonTap(bool isLiked, TuChongItem item) {
    ///send your request here
    ///
    final Completer<bool> completer = new Completer<bool>();
    Timer(const Duration(milliseconds: 200), () {
      item.isFavorite = !item.isFavorite;
      item.favorites =
          item.isFavorite ? item.favorites + 1 : item.favorites - 1;

      // if your request is failed,return null,
      completer.complete(item.isFavorite);
    });
    return completer.future;
  }
```
[more detail](https://github.com/fluttercandies/like_button/blob/master/example/lib/photo_view_demo.dart)


## 参数
| 参数                       | 描述                                                                                                  | 默认                                                                                                                                                                                  |
| -------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| size                       | like Widget的大小                                                                                     | 30.0                                                                                                                                                                                  |
| animationDuration          | like widget动画的时间                                                                                 | const Duration(milliseconds: 1000)                                                                                                                                                    |
| bubblesSize                | 动画时候的泡泡的大小                                                                                  | size * 2.0                                                                                                                                                                            |
| bubblesColor               | 动画时候的泡泡的颜色，需要设置4种                                                                     | const BubblesColor(dotPrimaryColor: const Color(0xFFFFC107),dotSecondaryColor: const Color(0xFFFF9800),dotThirdColor: const Color(0xFFFF5722),dotLastColor: const Color(0xFFF44336),) |
| circleSize                 | 动画时候的圈的最大大小                                                                                | size * 0.8                                                                                                                                                                            |
| circleColor                | 动画时候的圈的颜色，需要设置2种                                                                       | const CircleColor(start: const Color(0xFFFF5722), end: const Color(0xFFFFC107)                                                                                                        |
| onTap                      | 点击时候的回调，你可以在里面请求服务改变状态                                                          |                                                                                                                                                                                       |
| isLiked                    | 是否喜欢。如果设置null的话，将会一直有动画，而且喜欢数量一直增长                                      | false                                                                                                                                                                                 |
| likeCount                  | 喜欢数量。如果为null的话，不显示                                                                      | null                                                                                                                                                                                  |
| mainAxisAlignment          | MainAxisAlignment ，like widget和like count widget是放在一个Row里面的，对应Row的mainAxisAlignment属性 | MainAxisAlignment.center                                                                                                                                                              |
| likeBuilder                | like widget的创建回调                                                                                 | null                                                                                                                                                                                  |
| countBuilder               | like count widget的创建回调                                                                           | null                                                                                                                                                                                  |
| likeCountAnimationDuration | 喜欢数量变化动画的时间                                                                                | const Duration(milliseconds: 500)                                                                                                                                                     |
| likeCountAnimationType     | 喜欢数量动画的类型(none,part,all)。没有动画；只动画改变的部分；全部部分                               | LikeCountAnimationType.part                                                                                                                                                           |
| likeCountPadding           | like count widget 跟 like widget的间隔                                                                | const EdgeInsets.only(left: 3.0)                                                                                                                                                      |
| postion                    | like count widget 位置(left,right).在like wiget的左边或者右边                                         | Postion.right                                                                                                                                                                         |

[more detail](https://github.com/fluttercandies/like_button/tree/master/example/lib)
