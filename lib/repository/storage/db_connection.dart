import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../objectbox.g.dart';

class DbConnection {
  Store? _store;

  final RxBool _loading = false.obs;

  DbConnection._internal();

  static final DbConnection _singleton = DbConnection._internal();

  factory DbConnection() {
    return _singleton;
  }

  static Future<void> _loadStore() async {
    _singleton._loading.value = true;
    final path = await _localPath();
    _singleton._store = await openStore(directory: path);
    _singleton._loading.value = false;
  }

  static Future<String> _localPath() async {
    final dataDirectory = await _getDataDirectory();
    if (!dataDirectory.existsSync()) {
      await dataDirectory.create();
    }
    return dataDirectory.path;
  }

  static Future<Directory> _getDataDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final baseStorage = '${directory.path}/data';
    return Directory(baseStorage);
  }

  void externalSetStore(ByteData byteStore) {
    final store = Store.fromReference(getObjectBoxModel(), byteStore);
    _singleton._store = store;
  }

  Future<Store> get store async {
    if (_singleton._store == null && !_singleton._loading.value) {
      await _loadStore();
    }
    if (_singleton._loading.value) {
      Completer<Store> c = Completer();
      _singleton._loading.listen((p0) {
        c.complete(_singleton._store);
      });
      return c.future;
    } else {
      return Future.value(_singleton._store);
    }
  }

  static Future<void> deleteDataFiles() async {
    final dataDirectory = await _getDataDirectory();
    if (dataDirectory.existsSync()) {
      await dataDirectory.delete(recursive: true);
    }
    if (_singleton._store != null) {
      if (!_singleton._store!.isClosed()) {
        _singleton._store!.close();
      }
      _singleton._store = null;
    }
  }
}
