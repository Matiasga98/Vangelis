import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:objectbox/objectbox.dart';


import 'db_connection.dart';

abstract class BaseStorage extends GetxService {
  Future<Store> _getStore() async {
    return DbConnection().store;
  }

  Future<Box<T>> getBox<T>() async {
    final store = await _getStore();
    if (kDebugMode) {
      debugPrint('Flutter BOX DataType:- $T');
    }
    return store.box<T>();
  }
}
