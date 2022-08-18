import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vangelis/repository/storage/db_connection.dart';


import '../config/config.dart';
import '../mixins/updatable_entity.dart';
import '../services/connectivity_service.dart';

abstract class BaseRepository extends GetxService {
  final ConnectivityService _connectivityService = Get.find();
  final Configuration _configuration = Get.find();

  void setupExternalStorage(ByteData store) {
    DbConnection().externalSetStore(store);
  }

  bool _isConnected() {
    return _connectivityService.isConnected();
  }

  bool shouldGetFromApi<T extends UpdatableEntity>(T? entity, [bool forceApi = false]) {
    return forceApi ||
        ((entity == null ||
                DateTime.now().difference(entity.getLastUpdated()).inMinutes >
                    _configuration.getMaxUpdateTime()) &&
            _isConnected());
  }

  bool shouldGetListFromApi<T extends List<UpdatableEntity>>(T? entityList,
      [bool forceApi = false]) {
    return forceApi ||
        ((entityList == null ||
                entityList.isEmpty ||
                entityList.any((element) =>
                    DateTime.now().difference(element.getLastUpdated()).inMinutes >
                    _configuration.getMaxUpdateTime())) &&
            _isConnected());
  }
}
