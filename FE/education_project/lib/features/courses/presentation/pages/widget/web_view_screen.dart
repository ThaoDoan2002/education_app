import 'package:education_project/features/home/presentation/provider/get_own_course_by_cate_provider.dart';
import 'package:education_project/features/home/presentation/provider/get_courses_by_cate_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends ConsumerStatefulWidget {
  final String checkoutUrl;
  final String catId;

  const WebViewScreen({
    super.key,
    required this.checkoutUrl,
    required this.catId
  });

  @override
  ConsumerState<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            print('Trang đã load xong: $url');

            if (url.contains('success')) {
              final cateId = int.tryParse(widget.catId);
              if (cateId != null) {
                ref.invalidate(coursesByCateProvider(cateId));
              }
              ref.invalidate(coursesOwnByCateProvider);
              Navigator.of(context).pop(); // Quay lại sau khi load xong trang thành công
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Thanh toán',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }
}