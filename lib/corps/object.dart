class Objects {
  String? street;
  String? city;
  String? zip;
  String? country;
  String? garden;
  String? parking;
  String? objecttype;
  String? objectId;
  List<Tenants>? tenants;
  List<Units>? units;

  Objects({
    this.street,
    this.city,
    this.zip,
    this.country,
    this.garden,
    this.parking,
    this.objecttype,
    this.objectId,
    this.tenants,
    this.units,
  });

  factory Objects.fromJson(Map<String, dynamic> json) {
    return Objects(
      street: json['street'],
      city: json['city'],
      zip: json['zip'],
      country: json['country'],
      garden: json['garden'],
      parking: json['parking'],
      objecttype: json['objecttype'],
      objectId: json['objectId'],
      tenants: json['tenants'] != null
          ? (json['tenants'] as List).map((e) => Tenants.fromJson(e)).toList()
          : [],
      units: json['units'] != null
          ? (json['units'] as List).map((e) => Units.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'zip': zip,
      'country': country,
      'garden': garden,
      'parking': parking,
      'objecttype': objecttype,
      'objectId': objectId,
      'tenants': tenants?.map((e) => e.toJson()).toList(),
      'units': units?.map((e) => e.toJson()).toList(),
    };
  }
}

class Units {
  String? unitId;
  String? unit;
  String? level;

  Units({this.unitId, this.unit, this.level});

  factory Units.fromJson(Map<String, dynamic> json) {
    return Units(
      unitId: json['unitId'],
      unit: json['unit'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unitId': unitId,
      'unit': unit,
      'level': level,
    };
  }
}

class Tenants {
  String? tenantId;
  String? name;
  String? surname;
  String? level;
  String? birthday;
  String? nationality;
  String? married;
  String? pets;
  String? rent;

  Tenants({
    this.tenantId,
    this.name,
    this.surname,
    this.level,
    this.birthday,
    this.nationality,
    this.married,
    this.pets,
    this.rent,
  });

  factory Tenants.fromJson(Map<String, dynamic> json) {
    return Tenants(
      tenantId: json['tenantId'],
      name: json['name'],
      surname: json['surname'],
      level: json['level'],
      birthday: json['birthday'],
      nationality: json['nationality'],
      married: json['married'],
      pets: json['pets'],
      rent: json['rent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'name': name,
      'surname': surname,
      'level': level,
      'birthday': birthday,
      'nationality': nationality,
      'married': married,
      'pets': pets,
      'rent': rent,
    };
  }
}

