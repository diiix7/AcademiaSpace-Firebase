import 'package:flutter/material.dart';
import 'package:academiaspace/helper/enum.dart';
import 'package:academiaspace/model/feedModel.dart';
import 'package:academiaspace/state/bookmarkState.dart';
import 'package:academiaspace/ui/theme/theme.dart';
import 'package:academiaspace/widgets/customAppBar.dart';
import 'package:academiaspace/widgets/newWidget/emptyList.dart';
import 'package:academiaspace/widgets/tweet/tweet.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class LibraryPage extends StatefulWidget {
  @override
  _PdfListPageState createState() => _PdfListPageState();

  static Route<T> getRoute<T>() {
    return MaterialPageRoute(
      builder: (_) {
        return Provider(
          create: (_) => BookmarkState(),
          child: ChangeNotifierProvider(
            create: (BuildContext context) => BookmarkState(),
            builder: (_, child) => LibraryPage(),
          ),
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: TwitterColor.mystic,
  //     appBar: CustomAppBar(
  //       title: Text("Library - universityName", style: TextStyles.titleStyle),
  //       isBackButton: true,
  //     ),
  //     body: const LibraryPageBody(),
  //   );
  // }
}

class PdfViewPage extends StatelessWidget {
  final String pdfPath;

  PdfViewPage({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}

Future<List<String>> getPdfFiles() async {
  Directory directory =
      Directory('../../../library'); // Chemin vers le dossier contenant les PDF
  List<String> pdfFiles = [];

  if (await directory.exists()) {
    var files = directory.listSync();

    for (var file in files) {
      if (file is File && file.path.endsWith('.pdf')) {
        pdfFiles.add(file.path);
      }
    }
  }

  return pdfFiles;
}

/*
  @override
  Widget build(BuildContext context) {
    //var state = Provider.of<BookmarkState>(context);
    var state = null;
    //var list = state.tweetList;
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
          'No document yet',
          subTitle: 'When new document found, they\'ll show up here.',
        ),
      );
    }
    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemBuilder: (context, index) => _tweet(context, list[index]),
      itemCount: list.length,
    );
  }
  */

class _PdfListPageState extends State<LibraryPage> {
  List<String> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    loadPdfFiles();
  }

  Future<void> loadPdfFiles() async {
    List<String> files = await getPdfFiles();
    setState(() {
      pdfFiles = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF List'),
      ),
      body: ListView.builder(
        itemCount: pdfFiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pdfFiles[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewPage(pdfPath: pdfFiles[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
