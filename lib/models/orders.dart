import 'package:first_app/models/account.dart';

class OrderModel {
  final int id;
  final String code;
  final DateTime purchaseDate;
  final int branchId;
  final String description;
  final int status;
  final int retailerId;
  final double discount;
  final int soldById;
  final int roomId;
  final DateTime createdDate;
  final int createdBy;
  final String discountToView;
  final double total;
  final double totalPayment;
  final double totalAdditionalServices;
  final double excessCash;
  final double amountReceived;
  final double shippingCost;
  final String pos;
  final int numberOfGuests;
  final double vat;
  final double voucher;
  final List<OrderDetailModel> orderDetails;
  final AccountModel? partner; // Thông tin khách hàng nếu Includes=Partner

  OrderModel({
    required this.id,
    required this.code,
    required this.purchaseDate,
    required this.branchId,
    required this.description,
    required this.status,
    required this.retailerId,
    required this.discount,
    required this.soldById,
    required this.roomId,
    required this.createdDate,
    required this.createdBy,
    required this.discountToView,
    required this.total,
    required this.totalPayment,
    required this.totalAdditionalServices,
    required this.excessCash,
    required this.amountReceived,
    required this.shippingCost,
    required this.pos,
    required this.numberOfGuests,
    required this.vat,
    required this.voucher,
    required this.orderDetails,
    this.partner,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['Id'],
      code: json['Code'] ?? '',
      purchaseDate: DateTime.parse(json['PurchaseDate']),
      branchId: json['BranchId'] ?? 0,
      description: json['Description'] ?? '',
      status: json['Status'] ?? 0,
      retailerId: json['RetailerId'] ?? 0,
      discount: (json['Discount'] as num?)?.toDouble() ?? 0.0,
      soldById: json['SoldById'] ?? 0,
      roomId: json['RoomId'] ?? 0,
      createdDate: DateTime.parse(json['CreatedDate']),
      createdBy: json['CreatedBy'] ?? 0,
      discountToView: json['DiscountToView'] ?? '',
      total: (json['Total'] as num?)?.toDouble() ?? 0.0,
      totalPayment: (json['TotalPayment'] as num?)?.toDouble() ?? 0.0,
      totalAdditionalServices:
          (json['TotalAdditionalServices'] as num?)?.toDouble() ?? 0.0,
      excessCash: (json['ExcessCash'] as num?)?.toDouble() ?? 0.0,
      amountReceived: (json['AmountReceived'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['ShippingCost'] as num?)?.toDouble() ?? 0.0,
      pos: json['Pos'] ?? '',
      numberOfGuests: json['NumberOfGuests'] ?? 0,
      vat: (json['VAT'] as num?)?.toDouble() ?? 0.0,
      voucher: (json['Voucher'] as num?)?.toDouble() ?? 0.0,
      orderDetails:
          (json['OrderDetails'] as List<dynamic>?)
              ?.map((e) => OrderDetailModel.fromJson(e))
              .toList() ??
          [],
      partner: json['Partner'] != null
          ? AccountModel.fromJson(json['Partner'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "Code": code,
      "PurchaseDate": purchaseDate.toIso8601String(),
      "BranchId": branchId,
      "Description": description,
      "Status": status,
      "RetailerId": retailerId,
      "Discount": discount,
      "SoldById": soldById,
      "RoomId": roomId,
      "CreatedDate": createdDate.toIso8601String(),
      "CreatedBy": createdBy,
      "DiscountToView": discountToView,
      "Total": total,
      "TotalPayment": totalPayment,
      "TotalAdditionalServices": totalAdditionalServices,
      "ExcessCash": excessCash,
      "AmountReceived": amountReceived,
      "ShippingCost": shippingCost,
      "Pos": pos,
      "NumberOfGuests": numberOfGuests,
      "VAT": vat,
      "Voucher": voucher,
      "OrderDetails": orderDetails.map((e) => e.toJson()).toList(),
      "Partner": partner?.toJson(),
    };
  }
}

class OrderDetailModel {
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double total;

  OrderDetailModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      productId: json['ProductId'] ?? 0,
      productName: json['ProductName'] ?? '',
      quantity: json['Quantity'] ?? 0,
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      total: (json['Total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ProductId": productId,
      "ProductName": productName,
      "Quantity": quantity,
      "Price": price,
      "Total": total,
    };
  }
}
