class Creator {
  final int? rowNumber;
  final String creatorName;
  final String platform;
  final String niche;
  final String followerCount;
  final String engagementRate;
  final String address;
  final String phoneNumber;
  final String outreachStatus;
  final String firstMessageSent;
  final String lastFollowUp;
  final String collaborationType;
  final String whatTheyAskedFor;
  final String finalAgreedTerms;
  final String productSent;
  final String addPermission;
  final bool isApproved;
  final String postingDate;
  final String contentLink;
  final String result;
  final String notes;

  Creator({
    this.rowNumber,
    required this.creatorName,
    this.platform = '',
    this.niche = '',
    this.followerCount = '',
    this.engagementRate = '',
    this.address = '',
    this.phoneNumber = '',
    this.outreachStatus = 'Message Sent',
    this.firstMessageSent = '',
    this.lastFollowUp = '',
    this.collaborationType = '',
    this.whatTheyAskedFor = '',
    this.finalAgreedTerms = '',
    this.productSent = '',
    this.addPermission = '',
    this.isApproved = false,
    this.postingDate = '',
    this.contentLink = '',
    this.result = '',
    this.notes = '',
  });

  /// FIXED: Handles both String and int/double types
  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      rowNumber: _parseToInt(json['rowNumber']),
      creatorName: _parseToString(json['creatorName']),
      platform: _parseToString(json['platform']),
      niche: _parseToString(json['niche']),
      followerCount: _parseToString(json['followerCount']),
      engagementRate: _parseToString(json['engagementRate']),
      address: _parseToString(json['address']),
      phoneNumber: _parseToString(json['phoneNumber']),
      outreachStatus: _parseToString(json['outreachStatus']),
      firstMessageSent: _parseToString(json['firstMessageSent']),
      lastFollowUp: _parseToString(json['lastFollowUp']),
      collaborationType: _parseToString(json['collaborationType']),
      whatTheyAskedFor: _parseToString(json['whatTheyAskedFor']),
      finalAgreedTerms: _parseToString(json['finalAgreedTerms']),
      productSent: _parseToString(json['productSent']),
      addPermission: _parseToString(json['addPermission']),
      isApproved: _parseToBool(json['isApproved']),
      postingDate: _parseToString(json['postingDate']),
      contentLink: _parseToString(json['contentLink']),
      result: _parseToString(json['result']),
      notes: _parseToString(json['notes']),
    );
  }

  /// Helper: Parse to String safely (handles int, double, null)
  static String _parseToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is int || value is double || value is num) return value.toString();
    if (value is bool) return value.toString();
    return value.toString();
  }

  /// Helper: Parse to int safely
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed;
    }
    return null;
  }

  /// Helper: Parse to bool safely
  static bool _parseToBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }
    if (value is int) return value != 0;
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      if (rowNumber != null) 'rowNumber': rowNumber,
      'creatorName': creatorName,
      'platform': platform,
      'niche': niche,
      'followerCount': followerCount,
      'engagementRate': engagementRate,
      'address': address,
      'phoneNumber': phoneNumber,
      'outreachStatus': outreachStatus,
      'firstMessageSent': firstMessageSent,
      'lastFollowUp': lastFollowUp,
      'collaborationType': collaborationType,
      'whatTheyAskedFor': whatTheyAskedFor,
      'finalAgreedTerms': finalAgreedTerms,
      'productSent': productSent,
      'addPermission': addPermission,
      'isApproved': isApproved,
      'postingDate': postingDate,
      'contentLink': contentLink,
      'result': result,
      'notes': notes,
    };
  }

  Creator copyWith({
    int? rowNumber,
    String? creatorName,
    String? platform,
    String? niche,
    String? followerCount,
    String? engagementRate,
    String? address,
    String? phoneNumber,
    String? outreachStatus,
    String? firstMessageSent,
    String? lastFollowUp,
    String? collaborationType,
    String? whatTheyAskedFor,
    String? finalAgreedTerms,
    String? productSent,
    String? addPermission,
    bool? isApproved,
    String? postingDate,
    String? contentLink,
    String? result,
    String? notes,
  }) {
    return Creator(
      rowNumber: rowNumber ?? this.rowNumber,
      creatorName: creatorName ?? this.creatorName,
      platform: platform ?? this.platform,
      niche: niche ?? this.niche,
      followerCount: followerCount ?? this.followerCount,
      engagementRate: engagementRate ?? this.engagementRate,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      outreachStatus: outreachStatus ?? this.outreachStatus,
      firstMessageSent: firstMessageSent ?? this.firstMessageSent,
      lastFollowUp: lastFollowUp ?? this.lastFollowUp,
      collaborationType: collaborationType ?? this.collaborationType,
      whatTheyAskedFor: whatTheyAskedFor ?? this.whatTheyAskedFor,
      finalAgreedTerms: finalAgreedTerms ?? this.finalAgreedTerms,
      productSent: productSent ?? this.productSent,
      addPermission: addPermission ?? this.addPermission,
      isApproved: isApproved ?? this.isApproved,
      postingDate: postingDate ?? this.postingDate,
      contentLink: contentLink ?? this.contentLink,
      result: result ?? this.result,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'Creator(rowNumber: $rowNumber, name: $creatorName, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Creator && other.rowNumber == rowNumber;
  }

  @override
  int get hashCode => rowNumber.hashCode;
}