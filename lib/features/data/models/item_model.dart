class ItemModel {
  final String name;
  final num cost;
  final num landCost;
  final num newRate;
  final String? description;

  const ItemModel({
    required this.name,
    required this.cost,
    required this.landCost,
    required this.newRate,
    this.description,
  });
}
