mixin UpdatableEntity {
  DateTime lastUpdatedAt = DateTime.now();

  void setLastUpdated() {
    lastUpdatedAt = DateTime.now();
  }

  DateTime getLastUpdated() {
    return lastUpdatedAt;
  }
}
