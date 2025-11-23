class AddAddressParams {
  final String name;
  final String address;
  final double longitude;
  final double latitude;

  AddAddressParams({
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "address": address,
      "location": {
        "type": "Point",
        "coordinates": [longitude, latitude],
      },
    };
  }
}

class UpdateAddressParams {
  final String id;
  final String name;
  final String address;
  final double longitude;
  final double latitude;

  UpdateAddressParams({
    required this.id,
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "address": address,
      "location": {
        "type": "Point",
        "coordinates": [longitude, latitude],
      },
    };
  }
}

class GetAddressListParams {
  final int page;
  final int limit;

  GetAddressListParams({this.page = 1, this.limit = 10});

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
    };
  }
}