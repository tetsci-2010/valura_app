enum Sort {
  ascending,
  descending;

  String get getName {
    switch (this) {
      case Sort.ascending:
        return 'ASC';
      case Sort.descending:
        return 'DESC';
    }
  }
}
