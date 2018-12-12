import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_github_app_flutter/common/dao/UserDao.dart';
import 'package:gsy_github_app_flutter/common/redux/GSYState.dart';
import 'package:gsy_github_app_flutter/common/style/GSYStyle.dart';
import 'package:gsy_github_app_flutter/common/utils/CommonUtils.dart';
import 'package:gsy_github_app_flutter/common/utils/NavigatorUtils.dart';
import 'package:redux/redux.dart';

/**
 * 欢迎页
 * Created by guoshuyu
 * Date: 2018-07-16
 */

class WelcomePage extends StatefulWidget {
  static final String sName = "/";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;
  Timer _timer;
  var deadLine = 11;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (hadInit) {
      return;
    }
    hadInit = true;

    ///防止多次进入

    CommonUtils.initStatusBarHeight(context);
    _startDelay();
  }

  void _startDelay() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Void) {
      _timer.cancel();
      deadLine--;
      if (deadLine > 0) {
        _startDelay();
        setState(() {
          deadLine = deadLine;
        });
      } else {
        _navigation();
      }
    });
  }

  void _cancel() {
    if (_timer != null) {
      _timer.cancel();
    }
    _navigation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigation() {
    Store<GSYState> store = StoreProvider.of(context);
    UserDao.initUserInfo(store).then((res) {
      if (res != null && res.result) {
        NavigatorUtils.goHome(context);
      } else {
        NavigatorUtils.goLogin(context);
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(
      builder: (context, store) {
        return new Stack(
          children: <Widget>[
            new Container(
              color: Color(GSYColors.white),
              child: new Center(
                child: new Image(
                    image: new AssetImage('static/images/welcome.png')),
              ),
            ),
            new Positioned(
              right: 20,
              top: 100,
              child: new Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(100, 100, 100, 100),
                  shape: BoxShape.circle
                ),
                width: 50.0,
                height: 50.0,
                child: new GestureDetector(
                  child:new Center(
                    child:new Text("$deadLine/11",style: TextStyle(fontSize: 20,color: Color.fromARGB(100, 0, 0, 0), inherit: false),)),
                  onTap: _cancel,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
