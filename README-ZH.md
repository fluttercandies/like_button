# like_button

[![pub package](https://img.shields.io/pub/v/like_button.svg)](https://pub.dartlang.org/packages/like_button) [![GitHub stars](https://img.shields.io/github/stars/fluttercandies/like_button)](https://github.com/fluttercandies/like_button/stargazers) [![GitHub forks](https://img.shields.io/github/forks/fluttercandies/like_button)](https://github.com/fluttercandies/like_button/network)  [![GitHub license](https://img.shields.io/github/license/fluttercandies/like_button)](https://github.com/fluttercandies/like_button/blob/master/LICENSE)  [![GitHub issues](https://img.shields.io/github/issues/fluttercandies/like_button)](https://github.com/fluttercandies/like_button/issues) <a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="flutter-candies" title="flutter-candies"></a>

文档语言: [English](README.md) | [中文简体](README-ZH.md)

Like Button 支持推特点赞效果和喜欢数量动画的Flutter库.

感谢 [jd-alexander](https://github.com/jd-alexander/LikeButton) and [吉原拉面](https://github.com/yumi0629/FlutterUI/tree/master/lib/likebutton) 对点赞动画的原理的开源。

[Flutter 仿掘金推特点赞按钮](https://juejin.im/post/5cee3b43e51d45773f2e8ed7)  

[Web Demo for LikeButton](https://fluttercandies.github.io/like_button/)

![](https://github.com/fluttercandies/Flutter_Candies/blob/master/gif/like_button/like_button.gif)

- [like_button](#likebutton)
  - [如何使用.](#%e5%a6%82%e4%bd%95%e4%bd%bf%e7%94%a8)
  - [什么时候去请求服务改变状态](#%e4%bb%80%e4%b9%88%e6%97%b6%e5%80%99%e5%8e%bb%e8%af%b7%e6%b1%82%e6%9c%8d%e5%8a%a1%e6%94%b9%e5%8f%98%e7%8a%b6%e6%80%81)
  - [参数](#%e5%8f%82%e6%95%b0)

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
      onTap: onLikeButtonTapped,
    ),
```
这是一个异步回调，你可以等待服务返回之后再改变状态。也可以先改变状态，请求失败之后重置回状态

```dart
  Future<bool> onLikeButtonTapped(bool isLiked) async{
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }
```

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
| countPostion               | top,right,bottom,left. count的位置(上下左右)                                                          | CountPostion.right                                                                                                                                                                    |
| countDecoration            | count 的修饰器，你可以通过它为count增加其他文字或者效果                                               | null                                                                                                                                                                                  |  |
| postFrameCallback            | 第一帧回调返回 LikeButtonState                                                       | null                                                                                                                                                                                  |

## ☕️Buy me a coffee

![img](http://zmtzawqlp.gitee.io/my_images/images/qrcode.png)
