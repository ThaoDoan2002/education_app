import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/forget_password/presentation/pages/reset_password.dart';

class DynamicLinkService {
  static final DynamicLinkService _instance = DynamicLinkService._internal();
  factory DynamicLinkService() => _instance;
  DynamicLinkService._internal();

  Future<void> initDynamicLinks(BuildContext context) async {
    // Lắng nghe dynamic link khi app đang mở
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleLink(dynamicLinkData.link, context);
    });

    // Lấy link khi app được mở từ dynamic link
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    if (data?.link != null) {
      _handleLink(data!.link, context);
    }
  }

  void _handleLink(Uri deepLink, BuildContext context) {
    final uid = deepLink.queryParameters['uid'];
    final token = deepLink.queryParameters['token'];

    if (uid != null && token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResetPasswordPage(uid: uid, token: token)),
      );
    }
  }
}
