import 'package:flutter/material.dart';

class AdminOrderListModel {
  String statusCode;
  String message;
  Data data;

  AdminOrderListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AdminOrderListModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminOrderListModel(
      statusCode: json['status_code']?.toString() ?? json['statusCode']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: Data.fromJson(json['data'] is Map<String, dynamic> ? json['data'] : {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

/// Supports both:
///   - Single order detail response: data = { ...order fields... }
///   - Order list response:           data = { all_orders: [...], pending_orders: [...], ... }
class Data {
  // Single-order detail fields (new API)
  Order? order;

  // List-based fields (existing order-list API)
  List<Order> allOrders;
  List<Order> pendingOrders;
  List<Order> assignedOrders;
  List<Order> outForDeliveryOrders;
  List<Order> deliveredOrders;
  List<Order> cancelledOrders;

  Data({
    this.order,
    required this.allOrders,
    required this.pendingOrders,
    required this.assignedOrders,
    required this.outForDeliveryOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    // Detect single-order response by presence of 'id' / 'ordernumber' at root
    final isSingleOrder = json.containsKey('ordernumber') || json.containsKey('id');

    return Data(
      order: isSingleOrder ? Order.fromJson(json) : null,

      allOrders: (json['all_orders'] as List? ?? [])
          .where((e) => e is Map<String, dynamic>)
          .map((e) => Order.fromJson(e))
          .toList(),

      pendingOrders: (json['pending_orders'] as List? ?? [])
          .where((e) => e is Map<String, dynamic>)
          .map((e) => Order.fromJson(e))
          .toList(),

      assignedOrders: (json['assigned_orders'] as List? ?? [])
          .where((e) => e is Map<String, dynamic>)
          .map((e) => Order.fromJson(e))
          .toList(),

      outForDeliveryOrders:
          (json['out_for_delivery_orders'] as List? ?? [])
              .where((e) => e is Map<String, dynamic>)
              .map((e) => Order.fromJson(e))
              .toList(),

      deliveredOrders:
          (json['delivered_orders'] as List? ?? [])
              .where((e) => e is Map<String, dynamic>)
              .map((e) => Order.fromJson(e))
              .toList(),

      cancelledOrders:
          (json['cancelled_orders'] as List? ?? [])
              .where((e) => e is Map<String, dynamic>)
              .map((e) => Order.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    if (order != null) {
      return order!.toJson();
    }
    return {
      'all_orders': allOrders.map((e) => e.toJson()).toList(),
      'pending_orders': pendingOrders.map((e) => e.toJson()).toList(),
      'assigned_orders': assignedOrders.map((e) => e.toJson()).toList(),
      'out_for_delivery_orders': outForDeliveryOrders.map((e) => e.toJson()).toList(),
      'delivered_orders': deliveredOrders.map((e) => e.toJson()).toList(),
      'cancelled_orders': cancelledOrders.map((e) => e.toJson()).toList(),
    };
  }
}

class Order {
  // paymentmode: e.g. "Online", "COD", "Cash", "Card", "Wallet", "UPI", "0", "1", "2", "3"
  String paymentmode;
  int id;
  int customerid;
  String ordernumber;
  int waterbottleid;
  String price;
  String bottleprice;         // base bottle price
  String floorprice;          // floor delivery charge
  String quickdeliverycharge; // quick delivery surcharge
  int quantity;
  DateTime deliverydate;
  String deliverytime;
  int addressid;
  int assignedto;
  String paymentstatus;
  int status;
  int isSchedule;             // is_schedule
  int quickDelivery;          // quick_delivery
  int custFloornumber;        // cust_floornumber
  int custIsLiftAvailable;    // cust_is_lift_available
  DateTime cdate;
  DateTime modifiedDate;
  String customerName;
  String deliveryPartnerName;
  String statusText;
  String waterbottleName;
  int deliveryPartnerId;
  CustomerDetails customerDetails;
  DeliveryDetails deliveryDetails;

  // Bottle detail fields
  String bottleWeight;
  String bottleOriginalprice;
  String bottleDiscountprice;
  int totalbottleQuantity;
  String bottleDescription;

  Order({
    required this.id,
    required this.customerid,
    required this.ordernumber,
    required this.waterbottleid,
    required this.price,
    required this.bottleprice,
    required this.floorprice,
    required this.quickdeliverycharge,
    required this.quantity,
    required this.deliverydate,
    required this.deliverytime,
    required this.addressid,
    required this.assignedto,
    required this.paymentstatus,
    required this.paymentmode,
    required this.status,
    required this.isSchedule,
    required this.quickDelivery,
    required this.custFloornumber,
    required this.custIsLiftAvailable,
    required this.cdate,
    required this.modifiedDate,
    required this.customerName,
    required this.deliveryPartnerName,
    required this.statusText,
    required this.deliveryPartnerId,
    required this.customerDetails,
    required this.deliveryDetails,
    required this.waterbottleName,
    required this.bottleWeight,
    required this.bottleOriginalprice,
    required this.bottleDiscountprice,
    required this.totalbottleQuantity,
    required this.bottleDescription,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: int.tryParse((json['id'] ?? '0').toString()) ?? 0,
      customerid: int.tryParse((json['customerid'] ?? json['customer_id'] ?? '0').toString()) ?? 0,
      ordernumber: (json['ordernumber'] ?? json['order_number'] ?? '').toString(),
      waterbottleName: (json['waterbottle_name'] ??
              json['waterbottel_name'] ??
              json['waterbottleName'] ??
              json['waterbottelName'] ??
              json['waterbottlename'] ??
              json['waterbottelname'] ??
              json['bottle_name'] ??
              json['bottel_name'] ??
              json['bottleName'] ??
              json['bottelName'] ??
              json['name'] ??
              '')
          .toString(),
      waterbottleid: int.tryParse((json['waterbottleid'] ?? json['waterbottle_id'] ?? json['waterbottelid'] ?? json['waterbottel_id'] ?? '0').toString()) ?? 0,
      price: (json['price'] ?? '0').toString(),
      bottleprice: (json['bottleprice'] ?? json['bottle_price'] ?? json['bottlePrice'] ?? '0').toString(),
      floorprice: (json['floorprice'] ?? json['floor_price'] ?? json['floorPrice'] ?? json['floorcharges'] ?? json['floor_charges'] ?? json['floorCharges'] ?? '0').toString(),
      quickdeliverycharge: (json['quickdeliverycharge'] ??
              json['quick_delivery_charge'] ??
              json['quickDeliveryCharge'] ??
              json['quick_delivery_charges'] ??
              json['quickDeliveryCharges'] ??
              json['quickdeliverycharges'] ??
              json['fastdeliverycharges'] ??
              json['fast_delivery_charges'] ??
              json['fastDeliveryCharges'] ??
              json['fastdeliverycharge'] ??
              json['fast_delivery_charge'] ??
              json['fastDeliveryCharge'] ??
              '0')
          .toString(),
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      deliverydate: DateTime.tryParse(
            json['deliverydate']?.toString() ?? json['delivery_date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      deliverytime: (json['deliverytime'] ?? json['delivery_time'] ?? '').toString(),
      addressid: int.tryParse((json['addressid'] ?? json['address_id'] ?? '0').toString()) ?? 0,
      assignedto: int.tryParse((json['assignedto'] ?? json['assigned_to'] ?? '0').toString()) ?? 0,
      paymentstatus: (json['paymentstatus'] ?? json['payment_status'] ?? '').toString(),
      paymentmode: (json['paymentmode'] ?? json['payment_mode'] ?? '').toString(),
      status: int.tryParse((json['status'] ?? '0').toString()) ?? 0,
      isSchedule: int.tryParse((json['is_schedule'] ?? json['isSchedule'] ?? json['isschedule'] ?? '').toString()) ?? (json['is_schedule'] == true ? 1 : 0),
      quickDelivery: (int.tryParse((json['quick_delivery'] ?? json['quickDelivery'] ?? json['quickdelivery'] ?? '').toString()) ?? (json['quick_delivery'] == true ? 1 : 0)) == 1 ||
              ((double.tryParse((json['quickdeliverycharge'] ??
                          json['quick_delivery_charge'] ??
                          json['quickDeliveryCharge'] ??
                          json['quick_delivery_charges'] ??
                          json['quickDeliveryCharges'] ??
                          json['quickdeliverycharges'] ??
                          json['fastdeliverycharges'] ??
                          json['fast_delivery_charges'] ??
                          json['fastDeliveryCharges'] ??
                          json['fastdeliverycharge'] ??
                          json['fast_delivery_charge'] ??
                          json['fastDeliveryCharge'] ??
                          '0')
                      .toString()) ??
                  0) >
              0)
          ? 1
          : 0,
      custFloornumber: int.tryParse((json['cust_floornumber'] ??
              json['custFloornumber'] ??
              json['floor'] ??
              json['floornumber'] ??
              (json['customer_details'] is Map && json['customer_details']['address'] is Map ? json['customer_details']['address']['floornumber'] : '') ??
              '')
          .toString()) ?? 0,
      custIsLiftAvailable: int.tryParse((json['cust_is_lift_available'] ??
              json['custIsLiftAvailable'] ??
              json['is_lift_available'] ??
              json['isLiftAvailable'] ??
              (json['customer_details'] is Map && json['customer_details']['address'] is Map ? json['customer_details']['address']['is_lift_available'] : '') ??
              '')
          .toString()) ??
          (json['cust_is_lift_available'] == true || json['is_lift_available'] == true ? 1 : 0),
      cdate: DateTime.tryParse(
            (json['cdate'] ?? json['created_at'] ?? json['orderdate'] ?? json['order_date'] ?? '').toString(),
          ) ??
          DateTime.now(),
      modifiedDate: DateTime.tryParse(
            (json['modified_date'] ?? json['modifiedDate'] ?? json['updated_at'] ?? '').toString(),
          ) ??
          DateTime.now(),
      customerName: (json['customer_name'] ?? json['customerName'] ?? (json['customer_details'] is Map ? json['customer_details']['fullname'] : '') ?? '').toString(),
      deliveryPartnerName: (json['delivery_partner_name'] ??
              json['deliveryPartnerName'] ??
              json['deliverypartner_name'] ??
              json['deliverypartnername'] ??
              json['delivery_boy_name'] ??
              json['deliveryboy_name'] ??
              json['deliveryboyname'] ??
              json['delivery_partner'] ??
              json['assigned_to_name'] ??
              json['assignedto_name'] ??
              (json['delivery_details'] is Map
                  ? (json['delivery_details']['delivery_partner_name'] ??
                      json['delivery_details']['deliveryPartnerName'] ??
                      json['delivery_details']['fullname'] ??
                      json['delivery_details']['name'])
                  : '') ??
              '')
          .toString(),
      statusText: (json['status_text'] ?? json['statusText'] ?? '').toString(),
      deliveryPartnerId: int.tryParse((json['delivery_partner_id'] ??
              json['deliveryPartnerId'] ??
              json['assignedto'] ??
              json['assigned_to'] ??
              (json['delivery_details'] is Map
                  ? (json['delivery_details']['delivery_partner_id'] ??
                      json['delivery_details']['id'])
                  : '') ??
              '0')
          .toString()) ?? 0,
      customerDetails: json['customer_details'] is Map<String, dynamic>
          ? CustomerDetails.fromJson(json['customer_details'])
          : (json['customer_details'] is Map
              ? CustomerDetails.fromJson(Map<String, dynamic>.from(json['customer_details']))
              : CustomerDetails(
                  id: int.tryParse((json['customerid'] ?? json['customer_id'] ?? '0').toString()) ?? 0,
                  fullname: (json['customer_name'] ?? json['customerName'] ?? '').toString(),
                  mobile: (json['customer_mobile'] ?? json['customermobile'] ?? json['mobile'] ?? '').toString(),
                  email: (json['customer_email'] ?? json['customeremail'] ?? json['email'] ?? '').toString(),
                  photo: (json['customer_photo'] ?? json['customerphoto'] ?? json['photo'] ?? '').toString(),
                  status: 1,
                  cdate: DateTime.now(),
                  role: 1,
                  address: Address.empty(),
                  planbottlequantity: 0,
                )),
      deliveryDetails: json['delivery_details'] is Map<String, dynamic>
          ? DeliveryDetails.fromJson(json['delivery_details'])
          : (json['delivery_details'] is Map
              ? DeliveryDetails.fromJson(Map<String, dynamic>.from(json['delivery_details']))
              : DeliveryDetails(
                  deliveryPartnerId: int.tryParse((json['delivery_partner_id'] ??
                          json['deliveryPartnerId'] ??
                          json['assignedto'] ??
                          json['assigned_to'] ??
                          '0')
                      .toString()) ?? 0,
                  deliveryPartnerName: (json['delivery_partner_name'] ??
                          json['deliveryPartnerName'] ??
                          json['deliverypartner_name'] ??
                          json['deliveryboy_name'] ??
                          json['delivery_boy_name'] ??
                          json['delivery_partner'] ??
                          '')
                      .toString(),
                  mobileNo: (json['delivery_partner_mobile'] ??
                          json['deliveryPartnerMobile'] ??
                          json['delivery_mobile'] ??
                          json['deliverymobile'] ??
                          '')
                      .toString(),
                  email: (json['delivery_partner_email'] ?? json['deliveryPartnerEmail'] ?? '').toString(),
                  photo: (json['delivery_partner_photo'] ?? json['deliveryPartnerPhoto'] ?? '').toString(),
                  status: 1,
                  cdate: DateTime.now(),
                  role: 2,
                )),
      bottleWeight: (json['bottle_weight'] ?? json['bottel_weight'] ?? json['bottleWeight'] ?? json['bottelWeight'] ?? json['bottleweight'] ?? json['bottelweight'] ?? json['weight'] ?? '').toString(),
      bottleOriginalprice: (json['bottle_originalprice'] ?? json['bottel_originalprice'] ?? json['bottleOriginalprice'] ?? json['bottelOriginalprice'] ?? json['originalprice'] ?? '').toString(),
      bottleDiscountprice: (json['bottle_discountprice'] ?? json['bottel_discountprice'] ?? json['bottleDiscountprice'] ?? json['bottelDiscountprice'] ?? json['discountprice'] ?? json['bottleprice'] ?? json['bottle_price'] ?? json['bottlePrice'] ?? '').toString(),
      totalbottleQuantity: int.tryParse((json['totalbottle_quantity'] ?? json['totalbottel_quantity'] ?? json['totalbottleQuantity'] ?? json['totalbottelQuantity'] ?? json['totalbottlequantity'] ?? json['totalbottelquantity'] ?? '0').toString()) ?? 0,
      bottleDescription: (json['bottle_description'] ?? json['bottel_description'] ?? json['bottleDescription'] ?? json['bottelDescription'] ?? json['bottledescription'] ?? json['botteldescription'] ?? json['description'] ?? json['waterbottle_description'] ?? json['waterbottel_description'] ?? json['waterbottle_desc'] ?? json['waterbottel_desc'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerid': customerid,
      'ordernumber': ordernumber,
      'waterbottleid': waterbottleid,
      'price': price,
      'bottleprice': bottleprice,
      'floorprice': floorprice,
      'quickdeliverycharge': quickdeliverycharge,
      'quantity': quantity,
      'deliverydate': deliverydate.toIso8601String(),
      'deliverytime': deliverytime,
      'addressid': addressid,
      'assignedto': assignedto,
      'paymentmode': paymentmode,
      'paymentstatus': paymentstatus,
      'status': status,
      'is_schedule': isSchedule,
      'quick_delivery': quickDelivery,
      'cust_floornumber': custFloornumber,
      'cust_is_lift_available': custIsLiftAvailable,
      'cdate': cdate.toIso8601String(),
      'modified_date': modifiedDate.toIso8601String(),
      'customer_name': customerName,
      'delivery_partner_name': deliveryPartnerName,
      'status_text': statusText,
      'delivery_partner_id': deliveryPartnerId,
      'customer_details': customerDetails.toJson(),
      'delivery_details': deliveryDetails.toJson(),
      'waterbottle_name': waterbottleName,
      'bottle_weight': bottleWeight,
      'bottle_originalprice': bottleOriginalprice,
      'bottle_discountprice': bottleDiscountprice,
      'totalbottle_quantity': totalbottleQuantity,
      'bottle_description': bottleDescription,
    };
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PAYMENT MODE HELPERS (Color, Label, Icon)
  // ══════════════════════════════════════════════════════════════════════════

  String get formattedPaymentMode {
    final mode = paymentmode.trim().toLowerCase();
    if (mode == '0' || mode == 'cod' || mode == 'cash' || mode == 'cash on delivery') return 'COD';
    if (mode == '1' || mode == 'online') return 'Online';
    if (mode == '2' || mode == 'card' || mode == 'debit card' || mode == 'credit card') return 'Card';
    if (mode == '3' || mode == 'wallet') return 'Wallet';
    if (mode == 'upi') return 'UPI';
    if (mode == 'subscribe' || mode == 'subscribed' || mode == 'subscription') return 'Subscription';
    if (paymentmode.trim().isEmpty) return 'N/A';
    return paymentmode;
  }

  Color get paymentModeColor {
    final mode = paymentmode.trim().toLowerCase();
    if (mode == '0' || mode == 'cod' || mode == 'cash' || mode == 'cash on delivery') {
      return const Color(0xffE65100); // Deep Orange
    }
    if (mode == '1' || mode == 'online') {
      return const Color(0xff1565C0); // Vibrant Blue
    }
    if (mode == '2' || mode == 'card' || mode == 'debit card' || mode == 'credit card') {
      return const Color(0xff00838F); // Cyan/Teal
    }
    if (mode == '3' || mode == 'wallet') {
      return const Color(0xff6A1B9A); // Purple
    }
    if (mode == 'upi') {
      return const Color(0xff0277BD); // Light Blue / UPI
    }
    if (mode == 'subscribe' || mode == 'subscribed' || mode == 'subscription') {
      return const Color(0xff4527A0); // Deep Purple
    }
    return const Color(0xff455A64); // Blue Grey
  }

  Color get paymentModeBgColor {
    final mode = paymentmode.trim().toLowerCase();
    if (mode == '0' || mode == 'cod' || mode == 'cash' || mode == 'cash on delivery') {
      return const Color(0xffFFF3E0);
    }
    if (mode == '1' || mode == 'online') {
      return const Color(0xffE3F2FD);
    }
    if (mode == '2' || mode == 'card' || mode == 'debit card' || mode == 'credit card') {
      return const Color(0xffE0F7FA);
    }
    if (mode == '3' || mode == 'wallet') {
      return const Color(0xffF3E5F5);
    }
    if (mode == 'upi') {
      return const Color(0xffE1F5FE);
    }
    if (mode == 'subscribe' || mode == 'subscribed' || mode == 'subscription') {
      return const Color(0xffEDE7F6);
    }
    return const Color(0xffECEFF1);
  }

  IconData get paymentModeIcon {
    final mode = paymentmode.trim().toLowerCase();
    if (mode == '0' || mode == 'cod' || mode == 'cash' || mode == 'cash on delivery') {
      return Icons.payments_outlined;
    }
    if (mode == '1' || mode == 'online') {
      return Icons.language_rounded;
    }
    if (mode == '2' || mode == 'card' || mode == 'debit card' || mode == 'credit card') {
      return Icons.credit_card_rounded;
    }
    if (mode == '3' || mode == 'wallet') {
      return Icons.account_balance_wallet_rounded;
    }
    if (mode == 'upi') {
      return Icons.qr_code_2_rounded;
    }
    if (mode == 'subscribe' || mode == 'subscribed' || mode == 'subscription') {
      return Icons.card_membership_rounded;
    }
    return Icons.payment_rounded;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PAYMENT STATUS HELPERS (Color, Label, Icon)
  // ══════════════════════════════════════════════════════════════════════════

  String get formattedPaymentStatus {
    final status = paymentstatus.trim().toLowerCase();
    if ((status == '1' || status == 'paid' || status == 'success' || status == 'completed') && paymentmode == "COD") {
      return 'Success';
    }
    if ((status == '1' || status == 'paid' || status == 'success' || status == 'completed') && paymentmode == "COD") {
      return 'Paid';
    }
    if (status == '0' || status == 'pending' || status == 'unpaid' || status == 'processing') {
      return 'Pending';
    }
    if (status == '2' || status == 'failed' || status == 'declined') {
      return 'Failed';
    }
    if (status == 'cancelled' || status == 'canceled') {
      return 'Cancelled';
    }
    if (status == 'refunded' || status == 'refund') {
      return 'Refunded';
    }
    if (paymentstatus.trim().isEmpty) return 'Pending';
    return paymentstatus;
  }

  Color get paymentStatusColor {
    final status = paymentstatus.trim().toLowerCase();
    if (status == '1' || status == 'paid' || status == 'success' || status == 'completed') {
      return const Color(0xff2E7D32); // Forest Green
    }
    if (status == '0' || status == 'pending' || status == 'unpaid' || status == 'processing') {
      return const Color(0xffE65100); // Amber / Orange
    }
    if (status == '2' || status == 'failed' || status == 'declined' || status == 'cancelled' || status == 'canceled') {
      return const Color(0xffC62828); // Vibrant Red
    }
    if (status == 'refunded' || status == 'refund') {
      return const Color(0xff00838F); // Teal
    }
    return const Color(0xff455A64); // Slate Grey
  }

  Color get paymentStatusBgColor {
    final status = paymentstatus.trim().toLowerCase();
    if (status == '1' || status == 'paid' || status == 'success' || status == 'completed') {
      return const Color(0xffE8F5E9);
    }
    if (status == '0' || status == 'pending' || status == 'unpaid' || status == 'processing') {
      return const Color(0xffFFF3E0);
    }
    if (status == '2' || status == 'failed' || status == 'declined' || status == 'cancelled' || status == 'canceled') {
      return const Color(0xffFFEBEE);
    }
    if (status == 'refunded' || status == 'refund') {
      return const Color(0xffE0F7FA);
    }
    return const Color(0xffECEFF1);
  }

  IconData get paymentStatusIcon {
    final status = paymentstatus.trim().toLowerCase();
    if (status == '1' || status == 'paid' || status == 'success' || status == 'completed') {
      return Icons.check_circle_rounded;
    }
    if (status == '0' || status == 'pending' || status == 'unpaid' || status == 'processing') {
      return Icons.schedule_rounded;
    }
    if (status == '2' || status == 'failed' || status == 'declined') {
      return Icons.error_rounded;
    }
    if (status == 'cancelled' || status == 'canceled') {
      return Icons.cancel_rounded;
    }
    if (status == 'refunded' || status == 'refund') {
      return Icons.replay_rounded;
    }
    return Icons.info_rounded;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ORDER STATUS HELPERS (State, Color, Background Color)
  // ══════════════════════════════════════════════════════════════════════════

  bool get isDelivered {
    final s = statusText.trim().toLowerCase();
    if (s.contains('deliver') || s.contains('complete')) return true;
    if (s.contains('cancel') || s.contains('fail') || s.contains('reject')) return false;
    if (status == 3 || status == 4) return true;
    return false;
  }

  bool get isCancelled {
    final s = statusText.trim().toLowerCase();
    final p = paymentstatus.trim().toLowerCase();
    if (s.contains('cancel') || s.contains('fail') || s.contains('reject')) return true;
    if (p == 'cancelled' || p == 'canceled') return true;
    if (status == 5) return true;
    return false;
  }

  bool get isActive {
    return !isDelivered && !isCancelled;
  }

  String get displayStatusText {
    if (statusText.trim().isNotEmpty) {
      return statusText.trim();
    }
    if (isDelivered) return 'Delivered';
    if (isCancelled) return 'Cancelled';
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Assigned';
      case 2:
        return 'Out for Delivery';
      case 3:
      case 4:
        return 'Delivered';
      case 5:
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  Color get statusColor {
    if (isDelivered) {
      return const Color(0xff2E7D32); // Green
    }
    if (isCancelled) {
      return const Color(0xffC62828); // Red
    }
    final sText = statusText.trim().toLowerCase();
    if (status == 2 || sText.contains('pickup') || sText.contains('delivery') || sText.contains('out')) {
      return const Color(0xff1565C0); // Blue
    }
    if (status == 1 || sText == 'received' || sText == 'assigned' || sText == 'accepted') {
      return const Color(0xff00838F); // Cyan / Teal
    }
    if (status == 0 || sText == 'pending') {
      return const Color(0xffE65100); // Orange
    }
    return const Color(0xff455A64); // Slate Grey
  }

  Color get statusBgColor {
    if (isDelivered) {
      return const Color(0xffE8F5E9);
    }
    if (isCancelled) {
      return const Color(0xffFFEBEE);
    }
    final sText = statusText.trim().toLowerCase();
    if (status == 2 || sText.contains('pickup') || sText.contains('delivery') || sText.contains('out')) {
      return const Color(0xffE3F2FD);
    }
    if (status == 1 || sText == 'received' || sText == 'assigned' || sText == 'accepted') {
      return const Color(0xffE0F7FA);
    }
    if (status == 0 || sText == 'pending') {
      return const Color(0xffFFF3E0);
    }
    return const Color(0xffECEFF1);
  }
}

class CustomerDetails {
  int id;
  String fullname;
  String mobile;
  String email;
  String photo;
  int planbottlequantity;
  int status;
  DateTime cdate;
  int role;
  Address address;

  CustomerDetails({
    required this.id,
    required this.fullname,
    required this.mobile,
    required this.email,
    required this.photo,
    required this.planbottlequantity,
    required this.status,
    required this.cdate,
    required this.role,
    required this.address,
  });

  factory CustomerDetails.empty() {
    return CustomerDetails(
      id: 0,
      fullname: '',
      mobile: '',
      email: '',
      photo: '',
      planbottlequantity: 0,
      status: 0,
      cdate: DateTime.now(),
      role: 0,
      address: Address.empty(),
    );
  }

  factory CustomerDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerDetails(
      id: int.tryParse((json['id'] ?? '0').toString()) ?? 0,
      fullname: (json['fullname'] ?? json['full_name'] ?? json['name'] ?? '').toString(),
      mobile: (json['mobile'] ?? json['mobile_no'] ?? json['phone'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      photo: (json['photo'] ?? json['image'] ?? '').toString(),
      planbottlequantity: int.tryParse((json['planbottlequantity'] ?? json['plan_bottle_quantity'] ?? '0').toString()) ?? 0,
      status: int.tryParse((json['status'] ?? '0').toString()) ?? 0,
      cdate: DateTime.tryParse(
            (json['cdate'] ?? json['created_at'] ?? '').toString(),
          ) ??
          DateTime.now(),
      role: int.tryParse((json['role'] ?? '0').toString()) ?? 0,
      address: json['address'] is Map<String, dynamic>
          ? Address.fromJson(json['address'])
          : Address.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'mobile': mobile,
      'email': email,
      'photo': photo,
      'planbottlequantity': planbottlequantity,
      'status': status,
      'cdate': cdate.toIso8601String(),
      'role': role,
      'address': address.toJson(),
    };
  }
}

class Address {
  String fulladdress;
  int floornumber;
  String housenumber;
  String flatnumber;
  String societyname;
  int galinumber;
  String houseFlatFloorNo;
  String societyGaliBlockNo;
  int localityid;
  String sectornumber;
  int sectorid;
  String landmark;
  int stateid;
  int districtid;
  int subdivisionid;
  String subdivisionname;
  String city;
  String state;
  String pincode;
  int isDefaultAddress;
  String photo;
  String imagepath;

  Address({
    required this.fulladdress,
    required this.floornumber,
    required this.housenumber,
    required this.flatnumber,
    required this.societyname,
    required this.galinumber,
    required this.houseFlatFloorNo,
    required this.societyGaliBlockNo,
    required this.localityid,
    required this.sectornumber,
    required this.sectorid,
    required this.landmark,
    required this.stateid,
    required this.districtid,
    required this.subdivisionid,
    required this.subdivisionname,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isDefaultAddress,
    this.photo = '',
    this.imagepath = '',
  });

  factory Address.empty() {
    return Address(
      fulladdress: '',
      floornumber: 0,
      housenumber: '',
      flatnumber: '',
      societyname: '',
      galinumber: 0,
      houseFlatFloorNo: '',
      societyGaliBlockNo: '',
      localityid: 0,
      sectornumber: '',
      sectorid: 0,
      landmark: '',
      stateid: 0,
      districtid: 0,
      subdivisionid: 0,
      subdivisionname: '',
      city: '',
      state: '',
      pincode: '',
      isDefaultAddress: 0,
      photo: '',
      imagepath: '',
    );
  }

  factory Address.fromJson(
    Map<String, dynamic> json,
  ) {
    return Address(
      fulladdress: (json['fulladdress'] ?? json['full_address'] ?? json['address'] ?? '').toString(),
      floornumber: int.tryParse((json['floornumber'] ?? '0').toString()) ?? 0,
      housenumber: (json['housenumber'] ?? '').toString(),
      flatnumber: (json['flatnumber'] ?? '').toString(),
      societyname: (json['societyname'] ?? '').toString(),
      galinumber: int.tryParse((json['galinumber'] ?? '0').toString()) ?? 0,
      houseFlatFloorNo: (json['house_flat_floor_no'] ?? json['houseFlatFloorNo'] ?? '').toString(),
      societyGaliBlockNo: (json['society_gali_block_no'] ?? json['societyGaliBlockNo'] ?? '').toString(),
      localityid: int.tryParse((json['localityid'] ?? '0').toString()) ?? 0,
      sectornumber: (json['sectornumber'] ?? '').toString(),
      sectorid: int.tryParse((json['sectorid'] ?? '0').toString()) ?? 0,
      landmark: (json['landmark'] ?? '').toString(),
      stateid: int.tryParse((json['stateid'] ?? '0').toString()) ?? 0,
      districtid: int.tryParse((json['districtid'] ?? '0').toString()) ?? 0,
      subdivisionid: int.tryParse((json['subdivisionid'] ?? '0').toString()) ?? 0,
      subdivisionname: (json['subdivisionname'] ?? json['subdivision_name'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      pincode: (json['pincode'] ?? '').toString(),
      isDefaultAddress: int.tryParse((json['is_default_address'] ?? json['isDefaultAddress'] ?? '0').toString()) ?? (json['is_default_address'] == true ? 1 : 0),
      photo: (json['photo'] ?? json['image'] ?? json['house_photo'] ?? json['address_photo'] ?? json['address_image'] ?? '').toString(),
      imagepath: (json['imagepath'] ?? json['image_path'] ?? json['imagePath'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fulladdress': fulladdress,
      'floornumber': floornumber,
      'housenumber': housenumber,
      'flatnumber': flatnumber,
      'societyname': societyname,
      'galinumber': galinumber,
      'house_flat_floor_no': houseFlatFloorNo,
      'society_gali_block_no': societyGaliBlockNo,
      'localityid': localityid,
      'sectornumber': sectornumber,
      'sectorid': sectorid,
      'landmark': landmark,
      'stateid': stateid,
      'districtid': districtid,
      'subdivisionid': subdivisionid,
      'subdivisionname': subdivisionname,
      'city': city,
      'state': state,
      'pincode': pincode,
      'is_default_address': isDefaultAddress,
      'photo': photo,
      'imagepath': imagepath,
    };
  }
}

class DeliveryDetails {
  int deliveryPartnerId;
  String deliveryPartnerName;
  String mobileNo;
  String email;
  String photo;
  int status;
  DateTime cdate;
  int role;

  DeliveryDetails({
    required this.deliveryPartnerId,
    required this.deliveryPartnerName,
    required this.mobileNo,
    required this.email,
    required this.photo,
    required this.status,
    required this.cdate,
    required this.role,
  });

  factory DeliveryDetails.empty() {
    return DeliveryDetails(
      deliveryPartnerId: 0,
      deliveryPartnerName: '',
      mobileNo: '',
      email: '',
      photo: '',
      status: 0,
      cdate: DateTime.now(),
      role: 0,
    );
  }

  factory DeliveryDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return DeliveryDetails(
      deliveryPartnerId: int.tryParse((json['delivery_partner_id'] ?? json['deliveryPartnerId'] ?? '0').toString()) ?? 0,
      deliveryPartnerName: (json['delivery_partner_name'] ?? json['deliveryPartnerName'] ?? json['name'] ?? '').toString(),
      mobileNo: (json['mobile_no'] ?? json['mobileNo'] ?? json['mobile'] ?? json['phone'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      photo: (json['photo'] ?? json['image'] ?? '').toString(),
      status: int.tryParse((json['status'] ?? '0').toString()) ?? 0,
      cdate: DateTime.tryParse(
            (json['cdate'] ?? json['created_at'] ?? '').toString(),
          ) ??
          DateTime.now(),
      role: int.tryParse((json['role'] ?? '0').toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delivery_partner_id': deliveryPartnerId,
      'delivery_partner_name': deliveryPartnerName,
      'mobile_no': mobileNo,
      'email': email,
      'photo': photo,
      'status': status,
      'cdate': cdate.toIso8601String(),
      'role': role,
    };
  }
}