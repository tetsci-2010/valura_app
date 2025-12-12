class ProductFormModel {
  final String name;
  final num total;
  final List<int> itemIds;
  final List<String> names;
  final List<num> purchaseRates;
  final List<num> landCosts;
  final List<num> costs;
  final List<num> newRates;
  final List<String?> descriptions;

  const ProductFormModel({
    required this.itemIds,
    required this.name,
    required this.total,
    required this.names,
    required this.purchaseRates,
    required this.landCosts,
    required this.costs,
    required this.newRates,
    required this.descriptions,
  });
}
