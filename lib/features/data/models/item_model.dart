class ItemModel {
  final int id;
  final int itemId;
  final String name;
  final num purchaseRate;
  final num unitCost;
  final num landCost;
  final num newRate;
  final String? description;

  const ItemModel({
    required this.id,
    required this.itemId,
    required this.name,
    required this.purchaseRate,
    required this.unitCost,
    required this.landCost,
    required this.newRate,
    this.description,
  });

  ItemModel copyWith({
    int? id,
    int? itemId,
    String? name,
    num? purchaseRate,
    num? unitCost,
    num? landCost,
    num? newRate,
    String? description,
  }) {
    return ItemModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      purchaseRate: purchaseRate ?? this.purchaseRate,
      unitCost: unitCost ?? this.unitCost,
      landCost: landCost ?? this.landCost,
      newRate: newRate ?? this.newRate,
      description: description ?? this.description,
    );
  }

  factory ItemModel.fromDB(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      itemId: json['item_id'],
      name: json['name'],
      purchaseRate: json['purchase_rate'],
      unitCost: json['unit_cost'],
      landCost: json['land_cost'],
      newRate: json['new_rate'],
      description: json['description'],
    );
  }
}
