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
  List<WalletTransactionItem> transactions;

  WalletData({
    required this.customerId,
    required this.currentWalletAmount,
    required this.transactions,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    double amount = 0.0;
    if (json["currentwalletamount"] != null) {
      amount = double.tryParse(json["currentwalletamount"].toString()) ?? 0.0;
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
      transactions: txList,
    );
  }
}

class WalletTransactionItem {
  String title;
  String subtitle;
  double amount;
  String date;
  bool isCredit;

  WalletTransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isCredit,
  });

  factory WalletTransactionItem.fromJson(Map<String, dynamic> json) {
    double amt = 0.0;
    if (json["amount"] != null) {
      amt = double.tryParse(json["amount"].toString()) ?? 0.0;
    } else if (json["totalamount"] != null) {
      amt = double.tryParse(json["totalamount"].toString()) ?? 0.0;
    }

    bool credit = true;
    if (json["is_credit"] != null) {
      credit = json["is_credit"] == true || json["is_credit"].toString() == "1";
    } else if (json["type"] != null) {
      credit = json["type"].toString().toLowerCase() == "credit";
    }

    return WalletTransactionItem(
      title: json["title"]?.toString() ?? (credit ? "Added Money" : "Order Payment"),
      subtitle: json["subtitle"]?.toString() ?? (json["trans_id"] != null ? "Tx: ${json['trans_id']}" : ""),
      amount: amt,
      date: json["date"]?.toString() ?? json["trans_date"]?.toString() ?? "",
      isCredit: credit,
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
      previousAmount: double.tryParse(json["previous_amount"]?.toString() ?? "") ?? 0.0,
      addedAmount: double.tryParse(json["added_amount"]?.toString() ?? "") ?? 0.0,
      totalWalletAmount: double.tryParse(json["total_walletamount"]?.toString() ?? "") ?? 0.0,
    );
  }
}
