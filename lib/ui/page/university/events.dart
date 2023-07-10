import 'package:flutter/material.dart';
import 'package:academiaspace/helper/enum.dart';
import 'package:academiaspace/model/feedModel.dart';
import 'package:academiaspace/state/bookmarkState.dart';
import 'package:academiaspace/ui/theme/theme.dart';
import 'package:academiaspace/widgets/customAppBar.dart';
import 'package:academiaspace/widgets/newWidget/emptyList.dart';
import 'package:academiaspace/widgets/tweet/tweet.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  static Route<T> getRoute<T>() {
    return MaterialPageRoute(
      builder: (_) {
        return Provider(
          create: (_) => BookmarkState(),
          child: ChangeNotifierProvider(
            create: (BuildContext context) => BookmarkState(),
            builder: (_, child) => const EventsPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColor.mystic,
      appBar: CustomAppBar(
        title: Text("Events - universityName", style: TextStyles.titleStyle),
        isBackButton: true,
      ),
      body: const EventsPageBody(),
    );
  }
}

class EventsPageBody extends StatelessWidget {
  const EventsPageBody({Key? key}) : super(key: key);

  Widget _tweet(BuildContext context, FeedModel model) {
    return Container(
      color: Colors.white,
      child: Tweet(
        model: model,
        type: TweetType.Tweet,
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //var state = Provider.of<BookmarkState>(context);
    //var list = state.tweetList;
    var state = null;
    var list = null;
    if (state != null) {
      return const SizedBox(
        height: 3,
        child: LinearProgressIndicator(),
      );
    } else if (list == null || list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: EmptyList(
          'No Event available yet',
          subTitle: 'When Events are published, they\'ll show up here.',
        ),
      );
    }
    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemBuilder: (context, index) => _tweet(context, list[index]),
      itemCount: list.length,
    );
  }
}
