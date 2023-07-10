import 'package:flutter/material.dart';
import 'package:academiaspace/helper/utility.dart';
import 'package:academiaspace/ui/page/settings/widgets/headerWidget.dart';
import 'package:academiaspace/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:academiaspace/ui/theme/theme.dart';
import 'package:academiaspace/widgets/customAppBar.dart';
import 'package:academiaspace/widgets/customWidgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'About AcademiaSpace',
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const HeaderWidget(
            'Help',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Help Centre",
            vPadding: 0,
            showDivider: false,
            onPressed: () {
              Utility.launchURL(
                  "https://github.com/TheAlphamerc/academiaspace/issues");
            },
          ),
          const HeaderWidget('Legal'),
          const SettingRowWidget(
            "Terms of Service",
            showDivider: true,
          ),
          const SettingRowWidget(
            "Privacy policy",
            showDivider: true,
          ),
          const SettingRowWidget(
            "Cookie use",
            showDivider: true,
          ),
          SettingRowWidget(
            "Legal notices",
            showDivider: true,
            onPressed: () async {
              showLicensePage(
                context: context,
                applicationName: 'AcademiaSpace',
                applicationVersion: '1.0.0',
                useRootNavigator: true,
              );
            },
          ),
          const HeaderWidget("Developer's contact"),
          SettingRowWidget("Github", showDivider: true, onPressed: () {
            Utility.launchURL("https://github.com/LoickAdjiwanou");
          }),
          SettingRowWidget("LinkidIn", showDivider: true, onPressed: () {
            Utility.launchURL(
                "https://www.linkedin.com/in/loick-adjiwanou-36837b229");
          }),
          SettingRowWidget("Email", showDivider: true, onPressed: () {
            Text("loickadjiwanou1111@gmail.com");
          }),
        ],
      ),
    );
  }
}
