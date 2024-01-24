class CryptoAsset {
  final String id;
  final String name;
  final String minSize;
  final String status;
  final String message;
  final String maxPrecision;
  final List<String> convertibleTo;
  final CryptoDetails details;
  final String defaultNetwork;
  final List<SupportedNetwork> supportedNetworks;
  var isTracked = false;

  CryptoAsset({
    required this.id,
    required this.name,
    required this.minSize,
    required this.status,
    required this.message,
    required this.maxPrecision,
    required this.convertibleTo,
    required this.details,
    required this.defaultNetwork,
    required this.supportedNetworks,
  });

  factory CryptoAsset.fromJson(Map<String, dynamic> json) {
    return CryptoAsset(
      id: json['id'],
      name: json['name'],
      minSize: json['min_size'],
      status: json['status'],
      message: json['message'],
      maxPrecision: json['max_precision'],
      convertibleTo: List<String>.from(json['convertible_to']),
      details: CryptoDetails.fromJson(json['details']),
      defaultNetwork: json['default_network'],
      supportedNetworks: List<SupportedNetwork>.from(
        (json['supported_networks'] as List<dynamic>)
            .map((network) => SupportedNetwork.fromJson(network)),
      ),
    );
  }
}

class CryptoDetails {
  final String type;
  final String? symbol;
  final int? networkConfirmations;
  final int? sortOrder;
  final String? cryptoAddressLink;
  final String? cryptoTransactionLink;
  final List<String>? pushPaymentMethods;
  final List<String>? groupTypes;
  final String? displayName;
  final int? processingTimeSeconds;
  // final double? minWithdrawalAmount;
  // final double? maxWithdrawalAmount;

  CryptoDetails({
    required this.type,
    required this.symbol,
    required this.networkConfirmations,
    required this.sortOrder,
    required this.cryptoAddressLink,
    required this.cryptoTransactionLink,
    required this.pushPaymentMethods,
    required this.groupTypes,
    required this.displayName,
    required this.processingTimeSeconds,
    // required this.minWithdrawalAmount,
    // required this.maxWithdrawalAmount,
  });

  factory CryptoDetails.fromJson(Map<String, dynamic> json) {
    return CryptoDetails(
      type: json['type'],
      symbol: json['symbol'],
      networkConfirmations: json['network_confirmations'],
      sortOrder: json['sort_order'],
      cryptoAddressLink: json['crypto_address_link'],
      cryptoTransactionLink: json['crypto_transaction_link'],
      pushPaymentMethods: List<String>.from(json['push_payment_methods']),
      groupTypes: List<String>.from(json['group_types']),
      displayName: json['display_name'],
      processingTimeSeconds: json['processing_time_seconds'],
      // minWithdrawalAmount: json['min_withdrawal_amount'],
      // maxWithdrawalAmount: json['max_withdrawal_amount'],
    );
  }
}

class SupportedNetwork {
  final String id;
  final String name;
  final String? status;
  final String? contractAddress;
  final String? cryptoAddressLink;
  final String? cryptoTransactionLink;
  // final int minWithdrawalAmount;
  // final int maxWithdrawalAmount;
  final int? networkConfirmations;

  SupportedNetwork({
    required this.id,
    required this.name,
    required this.status,
    required this.contractAddress,
    required this.cryptoAddressLink,
    required this.cryptoTransactionLink,
    // required this.minWithdrawalAmount,
    // required this.maxWithdrawalAmount,
    required this.networkConfirmations,
  });

  factory SupportedNetwork.fromJson(Map<String, dynamic> json) {
    return SupportedNetwork(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      contractAddress: json['contract_address'],
      cryptoAddressLink: json['crypto_address_link'],
      cryptoTransactionLink: json['crypto_transaction_link'],
      // minWithdrawalAmount: json['min_withdrawal_amount'],
      // maxWithdrawalAmount: json['max_withdrawal_amount'],
      networkConfirmations: json['network_confirmations'],
    );
  }
}
