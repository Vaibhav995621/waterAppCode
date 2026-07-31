class GetWalletModel {
  String statusCode;
  String message;
  WalletData? data;

  GetWalletModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory GetWalletModel.fromJson(Map<String, dynamic> json) {
    return GetWalletModel(
      statusCode: json["status_code"]?.toString() ?? "",
      message: json["message"]?.toString() ?? "",
      data: json["data"] != null && json["data"] is Map<String, dynamic>
          ? WalletData.fromJson(json["data"])
          : null,
    );
  }
}

class WalletData {
  dynamic customerId;
  double currentWalletAmount;
  double totalSpendAmount;
  double totalAddAmount;
  List<WalletTransactionItem> transactions;

  WalletData({
    required this.customerId,
    required this.currentWalletAmount,
    required this.totalSpendAmount,
    required this.totalAddAmount,
    required this.transactions,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    double amount = 0.0;
    if (json["currentwalletamount"] != null) {
      amount = double.tryParse(json["currentwalletamount"].toString()) ?? 0.0;
    }

    double totalSpend = 0.0;
    if (json["totalspendamount"] != null) {
      totalSpend = double.tryParse(json["totalspendamount"].toString()) ?? 0.0;
    }

    double totalAdd = 0.0;
    if (json["totaladdamount"] != null) {
      totalAdd = double.tryParse(json["totaladdamount"].toString()) ?? 0.0;
    }

    List<WalletTransactionItem> txList = [];
    if (json["transactions"] != null && json["transactions"] is List) {
      txList = (json["transactions"] as List)
          .map((x) => WalletTransactionItem.fromJson(x))
          .toList();
    }

    return WalletData(
      customerId: json["customer_id"] ?? json["customerid"],
      currentWalletAmount: amount,
      totalSpendAmount: totalSpend,
      totalAddAmount: totalAdd,
      transactions: txList,
    );
  }
}

/// Maps directly to each object inside the "transactions" array from the API:
/// {
///   "id": 5,
///   "userid": 6,
///   "totalamount": 500,
///   "orderamount": 0,
///   "remainamount": 500,
///   "cdate": "2026-07-28 17:16:48"
/// }
class WalletTransactionItem {
  /// Transaction record ID from the server
  int id;

  /// The user/customer ID this transaction belongs to
  int userId;

  /// Total amount involved in this transaction
  double totalAmount;

  /// Amount spent on an order (debit). 0 means no order was paid.
  double orderAmount;

  /// Remaining / credited amount after the order deduction
  double remainAmount;

  /// Raw date string from the API e.g. "2026-07-28 17:16:48"
  String cdate;

  // ── Computed/display helpers ─────────────────────────────────────────────

  /// Display title derived from transaction type
  String title;

  /// Short subtitle (e.g. transaction ref, order id)
  String subtitle;

  /// The display amount (orderAmount if debit, remainAmount if credit)
  double amount;

  /// Parsed DateTime for formatting
  DateTime date;

  /// true = money added (credit), false = money spent (debit)
  bool isCredit;

  WalletTransactionItem({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.orderAmount,
    required this.remainAmount,
    required this.cdate,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isCredit,
  });

  factory WalletTransactionItem.fromJson(Map<String, dynamic> json) {
    // ── Raw API fields ──────────────────────────────────────────────────────
    final int id = int.tryParse(json["id"]?.toString() ?? "") ?? 0;
    final int userId = int.tryParse(
            (json["userid"] ?? json["user_id"])?.toString() ?? "") ??
        0;
    final double totalAmount =
        double.tryParse(json["totalamount"]?.toString() ?? "") ?? 0.0;
    final double orderAmount =
        double.tryParse(json["orderamount"]?.toString() ?? "") ?? 0.0;
    final double remainAmount =
        double.tryParse(json["remainamount"]?.toString() ?? "") ?? 0.0;
    final String cdate =
        json["cdate"]?.toString() ?? json["date"]?.toString() ?? "";

    // ── Determine credit / debit ────────────────────────────────────────────
    // If orderamount > 0  → money was deducted for an order  (debit / red)
    // Otherwise           → money was added to wallet        (credit / green)
    bool isCredit;
    double displayAmount;

    if (json.containsKey("orderamount") || json.containsKey("remainamount")) {
      if (orderAmount > 0) {
        isCredit = false;
        displayAmount = orderAmount;
      } else {
        isCredit = true;
        displayAmount = remainAmount > 0 ? remainAmount : totalAmount;
      }
    } else {
      // Fallback for other API shapes
      displayAmount =
          double.tryParse(json["amount"]?.toString() ?? "") ?? totalAmount;
      if (json["is_credit"] != null) {
        isCredit =
            json["is_credit"] == true || json["is_credit"].toString() == "1";
      } else if (json["type"] != null) {
        isCredit = json["type"].toString().toLowerCase() == "credit";
      } else {
        isCredit = true;
      }
    }

    // ── Build display title / subtitle ─────────────────────────────────────
    final String title = json["title"]?.toString() ??
        (isCredit ? "Money Added" : "Order Payment");
    final String subtitle = json["subtitle"]?.toString() ??
        (id > 0 ? "Txn #$id" : "");

    // ── Parse date ─────────────────────────────────────────────────────────
    final DateTime parsedDate = DateTime.tryParse(cdate) ?? DateTime.now();

    return WalletTransactionItem(
      id: id,
      userId: userId,
      totalAmount: totalAmount,
      orderAmount: orderAmount,
      remainAmount: remainAmount,
      cdate: cdate,
      title: title,
      subtitle: subtitle,
      amount: displayAmount,
      date: parsedDate,
      isCredit: isCredit,
    );
  }
}

class UpdateWalletModel {
  String statusCode;
  String message;
  UpdateWalletData? data;

  UpdateWalletModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory UpdateWalletModel.fromJson(Map<String, dynamic> json) {
    return UpdateWalletModel(
      statusCode: json["status_code"]?.toString() ?? "",
      message: json["message"]?.toString() ?? "",
      data: json["data"] != null && json["data"] is Map<String, dynamic>
          ? UpdateWalletData.fromJson(json["data"])
          : null,
    );
  }
}

class UpdateWalletData {
  dynamic customerId;
  double previousAmount;
  double addedAmount;
  double totalWalletAmount;

  UpdateWalletData({
    required this.customerId,
    required this.previousAmount,
    required this.addedAmount,
    required this.totalWalletAmount,
  });

  factory UpdateWalletData.fromJson(Map<String, dynamic> json) {
    return UpdateWalletData(
      customerId: json["customerid"] ?? json["customer_id"],
      previousAmount:
          double.tryParse(json["previous_amount"]?.toString() ?? "") ?? 0.0,
      addedAmount:
          double.tryParse(json["added_amount"]?.toString() ?? "") ?? 0.0,
      totalWalletAmount:
          double.tryParse(json["total_walletamount"]?.toString() ?? "") ?? 0.0,
    );
  }
}
