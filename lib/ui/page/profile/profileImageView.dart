import 'package:flutter/material.dart';
import 'package:academiaspace/helper/customRoute.dart';
import 'package:academiaspace/helper/utility.dart';
import 'package:academiaspace/ui/page/profile/profilePage.dart';
import 'package:academiaspace/ui/page/profile/widgets/circular_image.dart';
import 'package:academiaspace/ui/theme/theme.dart';

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({Key? key, required this.avatar}) : super(key: key);
  final String avatar;
  static Route<T> getRoute<T>(String avatar) {
    return SlideLeftRoute<T>(
        builder: (BuildContext context) => ProfileImageView(avatar: avatar));
  }

  @override
  Widget build(BuildContext context) {
    const List<Choice> choices = <Choice>[
      Choice(title: 'Share image link', icon: Icons.share, isEnable: true),
      Choice(
          title: 'Open in browser',
          icon: Icons.open_in_browser,
          isEnable: true),
      Choice(title: 'Save', icon: Icons.save),
    ];
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: (d) {
              switch (d.title) {
                case "Share image link":
                  Utility.share(avatar);
                  break;
                case "Open in browser":
                  Utility.launchURL(avatar);
                  break;
                case "Save":
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title,
                        style: TextStyles.textStyle14.copyWith(
                          color: choice.isEnable
                              ? AppColor.secondary.withOpacity(.9)
                              : AppColor.lightGrey,
                        )));
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: customAdvanceNetworkImage(avatar),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
