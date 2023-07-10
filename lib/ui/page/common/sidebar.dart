import 'package:flutter/material.dart';
import 'package:academiaspace/helper/constant.dart';
import 'package:academiaspace/state/authState.dart';
import 'package:academiaspace/ui/page/bookmark/bookmarkPage.dart';
//import 'package:academiaspace/ui/page/feed/feedFollow.dart';
import 'package:academiaspace/ui/page/feed/feedPage.dart';
import 'package:academiaspace/ui/page/profile/follow/followerListPage.dart';
import 'package:academiaspace/ui/page/profile/follow/followingListPage.dart';
import 'package:academiaspace/ui/page/profile/profilePage.dart';
import 'package:academiaspace/ui/page/profile/qrCode/scanner.dart';
import 'package:academiaspace/ui/page/profile/widgets/circular_image.dart';
import 'package:academiaspace/ui/theme/theme.dart';
import 'package:academiaspace/widgets/customWidgets.dart';
import 'package:academiaspace/widgets/url_text/customUrlText.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:academiaspace/ui/page/university/myuniversity.dart';
import 'package:academiaspace/ui/page/university/library.dart';
import 'package:academiaspace/ui/page/university/events.dart';
import 'package:academiaspace/ui/page/university/chatGPT.dart';

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({Key? key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  Widget _menuHeader() {
    final state = context.watch<AuthState>();
    if (state.userModel == null) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 200, minHeight: 100),
        child: Center(
          child: Text(
            'Login to continue',
            style: TextStyles.onPrimaryTitleText,
          ),
        ),
      ).ripple(() {
        _logOut();
      });
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 56,
              width: 56,
              margin: const EdgeInsets.only(left: 17, top: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  image: customAdvanceNetworkImage(
                    state.userModel!.profilePic ?? Constants.dummyProfilePic,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    ProfilePage.getRoute(profileId: state.userModel!.userId!));
              },
              title: Row(
                children: <Widget>[
                  UrlText(
                    text: state.userModel!.displayName ?? "",
                    style: TextStyles.onPrimaryTitleText
                        .copyWith(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  state.userModel!.isVerified ?? false
                      ? customIcon(context,
                          icon: AppIcon.blueTick,
                          isTwitterIcon: true,
                          iconColor: Colors.purple,
                          size: 18,
                          paddingIcon: 3)
                      : const SizedBox(
                          width: 0,
                        ),
                ],
              ),
              subtitle: customText(
                state.userModel!.userName,
                style: TextStyles.onPrimarySubTitleText
                    .copyWith(color: Colors.black54, fontSize: 15),
              ),
              trailing: customIcon(context,
                  icon: AppIcon.arrowDown,
                  iconColor: Colors.purple,
                  paddingIcon: 20),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 17,
                  ),
                  _textButton(context, state.userModel!.getFollower,
                      ' Followers', 'FollowerListPage'),
                  const SizedBox(width: 10),
                  _textButton(context, state.userModel!.getFollowing,
                      ' Following', 'FollowingListPage'),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _textButton(
      BuildContext context, String count, String text, String navigateTo) {
    return InkWell(
      onTap: () {
        var authState = context.read<AuthState>();
        late List<String> usersList;
        authState.getProfileUser();
        Navigator.pop(context);
        switch (navigateTo) {
          case "FollowerListPage":
            usersList = authState.userModel!.followersList!;
            Navigator.push(
              context,
              FollowerListPage.getRoute(
                profile: authState.userModel!,
                userList: usersList,
              ),
            );
            break;
          case "FollowingListPage":
            usersList = authState.userModel!.followingList!;
            Navigator.push(
              context,
              FollowingListPage.getRoute(
                profile: authState.userModel!,
                userList: usersList,
              ),
            );
            break;
        }
      },
      child: Row(
        children: <Widget>[
          customText(
            '$count ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          customText(
            text,
            style: const TextStyle(color: AppColor.darkGrey, fontSize: 17),
          ),
        ],
      ),
    );
  }

  ListTile _menuListRowButton(String title,
      {Function? onPressed, IconData? icon, bool isEnable = false}) {
    return ListTile(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      leading: icon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 5),
              child: customIcon(
                context,
                icon: icon,
                size: 25,
                iconColor: isEnable ? AppColor.darkGrey : AppColor.lightGrey,
              ),
            ),
      title: customText(
        title,
        style: TextStyle(
          fontSize: 20,
          color: isEnable ? AppColor.secondary : AppColor.lightGrey,
        ),
      ),
    );
  }

  Positioned _footer() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: <Widget>[
          const Divider(height: 0),
          Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
                height: 45,
              ),
              customIcon(context,
                  icon: AppIcon.bulbOn,
                  isTwitterIcon: true,
                  size: 25,
                  iconColor: Colors.purple),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      ScanScreen.getRoute(
                          context.read<AuthState>().profileUserModel!));
                },
                child: Image.asset(
                  "assets/images/qr.png",
                  height: 25,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(
                width: 0,
                height: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _logOut() {
    final state = Provider.of<AuthState>(context, listen: false);
    Navigator.pop(context);
    state.logoutCallback();
  }

  void _navigateTo(String path) {
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/$path');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 45),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: _menuHeader(),
                  ),
                  const Divider(),
                  _menuListRowButton('Profile',
                      icon: AppIcon.profile, isEnable: true, onPressed: () {
                    var state = context.read<AuthState>();
                    Navigator.push(
                        context, ProfilePage.getRoute(profileId: state.userId));
                  }),
                  _menuListRowButton(
                    'Bookmark',
                    icon: AppIcon.bookmark,
                    isEnable: true,
                    onPressed: () {
                      Navigator.push(context, BookmarkPage.getRoute());
                    },
                  ),
                  _menuListRowButton(
                    'Events',
                    icon: AppIcon.pin,
                    isEnable: true,
                    onPressed: () {
                      _navigateTo('');
                      //Navigator.push(context, EventsPage.getRoute());
                    },
                  ),
                  _menuListRowButton(
                    'My University',
                    icon: AppIcon.moments,
                    isEnable: true,
                    onPressed: () {
                      _navigateTo('');
                      //Navigator.push(context, UniversityPage.getRoute());
                    },
                  ),
                  _menuListRowButton(
                    'Library',
                    icon: AppIcon.viewHidden,
                    isEnable: true,
                    onPressed: () {
                      _navigateTo('');
                      //Navigator.push(context, LibraryPage.getRoute());
                    },
                  ),
                  _menuListRowButton(
                    'Intership search',
                    icon: AppIcon.twitterAds,
                    isEnable: true,
                    onPressed: () {
                      //Navigator.push(context, IntershipPage.getRoute());
                    },
                  ),
                  _menuListRowButton(
                    'ChatGPT',
                    icon: AppIcon.report,
                    isEnable: true,
                    onPressed: () {
                      Navigator.push(context, ChatGPT.getRoute());
                    },
                  ),
                  const Divider(),
                  _menuListRowButton(
                    'Settings & Privacy',
                    icon: AppIcon.settings,
                    isEnable: true,
                    onPressed: () {
                      _navigateTo('SettingsAndPrivacyPage');
                    },
                  ),
                  _menuListRowButton(
                    'Help Center',
                    icon: AppIcon.adTheRate,
                    isEnable: false,
                    onPressed: () {
                      _navigateTo('');
                    },
                  ),
                  const Divider(),
                  _menuListRowButton('Logout',
                      icon: AppIcon.delete, onPressed: _logOut, isEnable: true),
                ],
              ),
            ),
            _footer()
          ],
        ),
      ),
    );
  }
}
