// class Creator {
//   final int? rowNumber;
//   final String creatorName;
//   final String platform;
//   final String niche;
//   final String followerCount;
//   final String engagementRate;
//   final String address;
//   final String phoneNumber;
//   final String outreachStatus;
//   final String firstMessageSent;
//   final String lastFollowUp;
//   final String collaborationType;
//   final String whatTheyAskedFor;
//   final String finalAgreedTerms;
//   final String productSent;
//   final String addPermission;
//   final bool isApproved;
//   final String postingDate;
//   final String contentLink;
//   final String result;
//   final String notes;

//   const Creator({
//     this.rowNumber,
//     required this.creatorName,
//     this.platform = '',
//     this.niche = '',
//     this.followerCount = '',
//     this.engagementRate = '',
//     this.address = '',
//     this.phoneNumber = '',
//     this.outreachStatus = 'Message Sent',
//     this.firstMessageSent = '',
//     this.lastFollowUp = '',
//     this.collaborationType = '',
//     this.whatTheyAskedFor = '',
//     this.finalAgreedTerms = '',
//     this.productSent = '',
//     this.addPermission = '',
//     this.isApproved = false,
//     this.postingDate = '',
//     this.contentLink = '',
//     this.result = '',
//     this.notes = '',
//   });

//   // ✅ fromJson (clean + safe)
//   factory Creator.fromJson(Map<String, dynamic> json) {
//     return Creator(
//       rowNumber: _toInt(json['rowNumber']),
//       creatorName: _toStr(json['creatorName']),
//       platform: _toStr(json['platform']),
//       niche: _toStr(json['niche']),
//       followerCount: _toStr(json['followerCount']),
//       engagementRate: _toStr(json['engagementRate']),
//       address: _toStr(json['address']),
//       phoneNumber: _toStr(json['phoneNumber']),
//       outreachStatus: _toStr(json['outreachStatus']),
//       firstMessageSent: _toStr(json['firstMessageSent']),
//       lastFollowUp: _toStr(json['lastFollowUp']),
//       collaborationType: _toStr(json['collaborationType']),
//       whatTheyAskedFor: _toStr(json['whatTheyAskedFor']),
//       finalAgreedTerms: _toStr(json['finalAgreedTerms']),
//       productSent: _toStr(json['productSent']),
//       addPermission: _toStr(json['addPermission']),
//       isApproved: _toBool(json['isApproved']),
//       postingDate: _toStr(json['postingDate']),
//       contentLink: _toStr(json['contentLink']),
//       result: _toStr(json['result']),
//       notes: _toStr(json['notes']),
//     );
//   }

//   // ✅ toJson
//   Map<String, dynamic> toJson() => {
//         if (rowNumber != null) 'rowNumber': rowNumber,
//         'creatorName': creatorName,
//         'platform': platform,
//         'niche': niche,
//         'followerCount': followerCount,
//         'engagementRate': engagementRate,
//         'address': address,
//         'phoneNumber': phoneNumber,
//         'outreachStatus': outreachStatus,
//         'firstMessageSent': firstMessageSent,
//         'lastFollowUp': lastFollowUp,
//         'collaborationType': collaborationType,
//         'whatTheyAskedFor': whatTheyAskedFor,
//         'finalAgreedTerms': finalAgreedTerms,
//         'productSent': productSent,
//         'addPermission': addPermission,
//         'isApproved': isApproved,
//         'postingDate': postingDate,
//         'contentLink': contentLink,
//         'result': result,
//         'notes': notes,
//       };

//   // ✅ copyWith
//   Creator copyWith({
//     int? rowNumber,
//     String? creatorName,
//     String? platform,
//     String? niche,
//     String? followerCount,
//     String? engagementRate,
//     String? address,
//     String? phoneNumber,
//     String? outreachStatus,
//     String? firstMessageSent,
//     String? lastFollowUp,
//     String? collaborationType,
//     String? whatTheyAskedFor,
//     String? finalAgreedTerms,
//     String? productSent,
//     String? addPermission,
//     bool? isApproved,
//     String? postingDate,
//     String? contentLink,
//     String? result,
//     String? notes,
//   }) {
//     return Creator(
//       rowNumber: rowNumber ?? this.rowNumber,
//       creatorName: creatorName ?? this.creatorName,
//       platform: platform ?? this.platform,
//       niche: niche ?? this.niche,
//       followerCount: followerCount ?? this.followerCount,
//       engagementRate: engagementRate ?? this.engagementRate,
//       address: address ?? this.address,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       outreachStatus: outreachStatus ?? this.outreachStatus,
//       firstMessageSent: firstMessageSent ?? this.firstMessageSent,
//       lastFollowUp: lastFollowUp ?? this.lastFollowUp,
//       collaborationType: collaborationType ?? this.collaborationType,
//       whatTheyAskedFor: whatTheyAskedFor ?? this.whatTheyAskedFor,
//       finalAgreedTerms: finalAgreedTerms ?? this.finalAgreedTerms,
//       productSent: productSent ?? this.productSent,
//       addPermission: addPermission ?? this.addPermission,
//       isApproved: isApproved ?? this.isApproved,
//       postingDate: postingDate ?? this.postingDate,
//       contentLink: contentLink ?? this.contentLink,
//       result: result ?? this.result,
//       notes: notes ?? this.notes,
//     );
//   }

//   // ---------- helpers (minimal but safe) ----------

//   static String _toStr(dynamic v) => v?.toString() ?? '';

//   static int? _toInt(dynamic v) =>
//       v is int ? v : int.tryParse(v?.toString() ?? '');

//   static bool _toBool(dynamic v) =>
//       v is bool ? v : v?.toString().toLowerCase() == 'true';
// }