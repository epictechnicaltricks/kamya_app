class wallet_list{

  final String wallet_id;
  final String wallet_desc;
  final String wallet_date;
  final String wallet_amount;
  final String credit_debit;
  final String user_wallet;
  //final String  status;
  late List<wallet_list> data;

  wallet_list({
    required this.wallet_id,
    required this.wallet_desc,
    required this.wallet_date,
    required this.wallet_amount,
    required this.credit_debit,
    required this.user_wallet,
   // required this.status,
  });

  factory wallet_list.fromJson(Map<String, dynamic> json) {
    return wallet_list(
      wallet_id: json['wallet_id'] as String,
      wallet_desc: json['wallet_desc'] as String,
      wallet_date: json['wallet_date'] as String,
      wallet_amount: json['wallet_amount'] as String,
      credit_debit: json['credit_debit'] as String,
      user_wallet: json['user_wallet'] as String,
    );
  }
 /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = required this.status;

    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


