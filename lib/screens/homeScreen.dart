import 'package:album/helper/APIHelper.dart';
import 'package:album/models/POST.dart';
import 'package:album/provider/homeScreenProvider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  ScrollController _scrollController = ScrollController();

  _showSnackbar(String message, {Color bgColor}) {
    _globalKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor ?? Colors.blue,
      ),
    );
  }

  _hideSnackbar() {
    _globalKey.currentState.hideCurrentSnackBar();
  }

  _getPosts({bool refresh = true}) async {
    var provider = Provider.of<HomeScreenProvider>(context, listen: false);
    if (!provider.shouldRefresh) {
      _showSnackbar('All post have been loaded!');
      return;
    }
    if (refresh) _showSnackbar('Load more...', bgColor: Colors.blue);

    var postsResponse = await HelperAPI.getPosts(
      limit: 10,
      page: provider.currentPage,
    );
    if (postsResponse.isSuccessful) {
      if (postsResponse.data.isNotEmpty) {
        if (refresh) {
          provider.mergePostsList(postsResponse.data, notify: false);
        } else {
          provider.setPostsList(postsResponse.data, notify: false);
        }
        provider.setCurrentPage(provider.currentPage + 1);
      } else {
        provider.setShouldRefresh(false);
      }
    } else {
      _showSnackbar(postsResponse.message);
    }
    provider.setIsHomePageProcessing(false);
    _hideSnackbar();
  }



  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          _getPosts();
        }
      }
    });
    _getPosts(refresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Albums'),
      ),
      body: Consumer<HomeScreenProvider>(
        builder: (_, provider, __) => provider.isHomePageProcessing
            ? Center(
          child: Transform.scale(scale: 2.5,child: CircularProgressIndicator()),
        )
            : provider.postsListLength > 0
            ? ListView.builder(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          itemBuilder: (_, index) {
            Post post = provider.getPostByIndex(index);
            return ListTile(
              title: Text(post.title),
            );
          },
          itemCount: provider.postsListLength,
        )
            : Center(
          child: Text('There are nothing left here.'),
        ),
      ),
    );
  }
}