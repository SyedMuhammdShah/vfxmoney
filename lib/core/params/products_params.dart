class GetProductListParams {
  final int? page;
  final int? limit;
  final double? minPrice;
  final double? maxPrice;
  final String? material;
  final String? category;
  final String? suppliers;

  GetProductListParams({
    this.page,
    this.limit,
    this.minPrice,
    this.maxPrice,
    this.material,
    this.category,
    this.suppliers,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (page != null) data['page'] = page;
    if (limit != null) data['limit'] = limit;
    if (minPrice != null) data['minPrice'] = minPrice;
    if (maxPrice != null) data['maxPrice'] = maxPrice;
    if (material != null) data['material'] = material;
    if (category != null) data['category'] = category;
    if (suppliers != null) data['suppliers'] = suppliers;

    return data;
  }
}

class GetProductDetailsParams {
  final String productID;
  GetProductDetailsParams({required this.productID});
}

class GetBrandProductParams {
  final String id;
  final int page;
  GetBrandProductParams({required this.page, required this.id});
  Map<String, dynamic> toJson() {
    return {'page': page};
  }
}

class GetFavProductParams {
  final int page;
  GetFavProductParams({required this.page});
  Map<String, dynamic> toJson() {
    return {'page': page};
  }
}

class CreateOrderParams {
  final List<OrderItem> items;
  final String card;
  final String address;
  final String type;
  final String instruction;
  final num subTotal;
  final num platformFee;
  final num deliverCharges;
  final num total;

  const CreateOrderParams({
    required this.items,
    required this.card,
    required this.address,
    required this.type,
    required this.instruction,
    required this.subTotal,
    required this.platformFee,
    required this.deliverCharges,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'item': items.map((e) => e.toMap()).toList(),
      'card': card,
      'address': address,
      'type': type,
      'instruction': instruction,
      'subTotal': subTotal,
      'platformFee': platformFee,
      'deliverCharges': deliverCharges,
      'total': total,
    };
  }
}

class OrderItem {
  final String products;
  final int quantity;

  const OrderItem({required this.products, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'products': products, 'quantity': quantity};
  }
}

class GetSimilarProductParams {
  final int? page;
  final String id;

  GetSimilarProductParams({this.page, required this.id});

  Map<String, dynamic> toJson() {
    return {'page': page, 'id': id};
  }
}

class GetPriceComparisonProductParams {
  final int? page;
  final String id;

  GetPriceComparisonProductParams({this.page, required this.id});

  Map<String, dynamic> toJson() {
    return {'page': page, 'id': id};
  }
}

class UpdateFavoriteParams {
  final String id;
  final bool isFavourite;
  UpdateFavoriteParams({required this.id, required this.isFavourite});
  Map<String, dynamic> toJson() {
    return {'id': id, 'isFavourite': isFavourite};
  }
}

class GetReportedProductsParams {
  final int? page;
  final String status;

  GetReportedProductsParams({this.page, required this.status});

  Map<String, dynamic> toJson() {
    return {'page': page, 'status': status};
  }
}

class ReportOrderParams {
  final String reportedOrder;
  final String reason;

  ReportOrderParams({required this.reportedOrder, required this.reason});

  Map<String, dynamic> toJson() {
    return {'reportedOrder': reportedOrder, 'reason': reason};
  }
}
