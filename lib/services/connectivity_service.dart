import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../entity/user.dart';
import '../util/constants.dart';

class ConnectivityService extends GetxService {
  StreamSubscription? _subscription;
  Connectivity? _connectivity;
  final Rx<ConnectivityResult> currentStatus = ConnectivityResult.none.obs;
  final Rx<ConnectivityResult> _previousStatus = ConnectivityResult.none.obs;


  bool isConnected() {
    return currentStatus.value != ConnectivityResult.none;
  }

  @override
  void onReady() {
    super.onReady();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _connectivity = Connectivity();
      WidgetsFlutterBinding.ensureInitialized();
      final result = await _connectivity!.checkConnectivity();
      currentStatus.value = result;
      _subscription = _connectivity!.onConnectivityChanged
          .listen((ConnectivityResult result) async {
        currentStatus.value = result;
        if (result == ConnectivityResult.none) {
          showMsg(title: noConnection, message: downloadContentAvailable);
        }
        _previousStatus.value = result;
      });
    } catch (e) {
      debugPrint('Connectivity plugin error: $e');
      currentStatus.value = ConnectivityResult.wifi;
      return;
    }
  }

  @override
  onClose() {
    super.onClose();
    if (_subscription != null) {
      _subscription!.cancel();
    }
  }
}
