class LunchCoupon {
  final String code;
  final DateTime validFor;
  final String status;

  LunchCoupon({
    required this.code,
    required this.validFor,
    required this.status,
  });

  bool get isForToday {
    final now = DateTime.now();
    return validFor.day == now.day &&
        validFor.month == now.month &&
        validFor.year == now.year;
  }

  factory LunchCoupon.fromJson(Map<String, dynamic> json) {
    return LunchCoupon(
      code: json['codigo'],
      validFor: DateTime.parse(json['validoPara']),
      status: json['estado'],
    );
  }

  static List<LunchCoupon> fromJsonList(List<dynamic> json) {
    return json.map((e) => LunchCoupon.fromJson(e)).toList();
  }
}
