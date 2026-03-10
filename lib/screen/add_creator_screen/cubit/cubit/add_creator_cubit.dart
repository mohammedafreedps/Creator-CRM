import 'package:bloc/bloc.dart';
import 'package:creator_tracker/database/database_service.dart';
import 'package:creator_tracker/models/creator_draft_model.dart';
import 'package:equatable/equatable.dart';

part 'add_creator_state.dart';

class AddCreatorCubit extends Cubit<AddCreatorState> {
  AddCreatorCubit() : super(AddCreatorInitial());
  Future<void> saveCreator(CreatorDraft draft) async {
    try {
      if (draft.name == null || draft.name!.isEmpty) {
        emit(CreatorSaveError("Creator name is required"));
        return;
      }

      emit(CreatorSaveLoading());

      final db = await DatabaseService.database;

      await db.transaction((txn) async {
        final creatorId = await txn.insert("creators", {
          "name": draft.name,
          "platform": draft.platform,
          "niche": draft.niche,
          "followers": draft.followers,
          "engagement_rate": draft.engagementRate,
          "phone": draft.phone,
          "email": draft.email,
          "address": draft.address,
          "location": draft.location,
          "rating": draft.rating,
          "is_favorite": draft.isFavorite == true ? 1 : 0,
          "is_blacklisted": draft.isBlacklisted == true ? 1 : 0,
          "created_at": DateTime.now().toIso8601String(),
        });

        // -------- Outreach --------

        if (_hasOutreachData(draft)) {
          await txn.insert("outreach", {
            "creator_id": creatorId,
            "status": draft.outreachStatus,
            "first_message_date": draft.firstMessageDate?.toIso8601String(),
            "last_followup_date": draft.lastFollowupDate?.toIso8601String(),
            "next_followup_date": draft.nextFollowupDate?.toIso8601String(),
            "communication_channel": draft.communicationChannel,
            "followup_count": draft.followupCount,
          });
        }

        // -------- Deals --------

        if (_hasDealData(draft)) {
          await txn.insert("deals", {
            "creator_id": creatorId,
            "collaboration_type": draft.collaborationType,
            "asked_price": draft.askedPrice,
            "final_price": draft.finalPrice,
            "deliverables": draft.deliverables,
            "status": draft.dealStatus,
          });
        }

        // -------- Product Tracking --------

        if (_hasProductData(draft)) {
          await txn.insert("product_tracking", {
            "creator_id": creatorId,
            "product_name": draft.productName,
            "status": draft.productStatus,
            "courier": draft.courier,
            "tracking_number": draft.trackingNumber,
            "dispatch_date": draft.dispatchDate?.toIso8601String(),
            "delivery_date": draft.deliveryDate?.toIso8601String(),
          });
        }

        // -------- Content --------

        if (_hasContentData(draft)) {
          await txn.insert("content", {
            "creator_id": creatorId,
            "content_received": draft.contentReceived == true ? 1 : 0,
            "content_approved": draft.contentApproved == true ? 1 : 0,
            "posting_date": draft.postingDate?.toIso8601String(),
            "content_link": draft.contentLink,
            "ad_permission": draft.adPermission == true ? 1 : 0,
          });
        }

        // -------- Payments --------

        if (_hasPaymentData(draft)) {
          await txn.insert("payments", {
            "creator_id": creatorId,
            "amount": draft.amount,
            "status": draft.paymentStatus,
            "payment_date": draft.paymentDate?.toIso8601String(),
            "payment_method": draft.paymentMethod,
            "invoice_number": draft.invoiceNumber,
          });
        }

        // -------- Notes --------

        if (draft.note != null && draft.note!.isNotEmpty) {
          await txn.insert("notes", {
            "creator_id": creatorId,
            "note": draft.note,
            "created_at": DateTime.now().toIso8601String(),
          });
        }

        emit(CreatorSaveSuccess(creatorId));
      });
    } catch (e) {
      emit(CreatorSaveError(e.toString()));
    }
  }

  // ---------------- Validators ----------------

  bool _hasOutreachData(CreatorDraft draft) {
    return draft.outreachStatus != null ||
        draft.firstMessageDate != null ||
        draft.lastFollowupDate != null ||
        draft.nextFollowupDate != null ||
        draft.communicationChannel != null;
  }

  bool _hasDealData(CreatorDraft draft) {
    return draft.askedPrice != null ||
        draft.finalPrice != null ||
        draft.deliverables != null ||
        draft.collaborationType != null;
  }

  bool _hasProductData(CreatorDraft draft) {
    return draft.productName != null ||
        draft.trackingNumber != null ||
        draft.courier != null;
  }

  bool _hasContentData(CreatorDraft draft) {
    return draft.contentReceived != null ||
        draft.contentApproved != null ||
        draft.postingDate != null ||
        draft.contentLink != null;
  }

  bool _hasPaymentData(CreatorDraft draft) {
    return draft.amount != null ||
        draft.paymentStatus != null ||
        draft.paymentMethod != null;
  }

  Future<void> updateCreator(CreatorDraft draft) async {

  try {

    if (draft.id == null) {
      emit(CreatorSaveError("Creator ID missing"));
      return;
    }

    emit(CreatorSaveLoading());

    final db = await DatabaseService.database;

    await db.transaction((txn) async {

      // ---------------- UPDATE CREATOR ----------------

      await txn.update(
        "creators",
        {
          "name": draft.name,
          "platform": draft.platform,
          "niche": draft.niche,
          "followers": draft.followers,
          "engagement_rate": draft.engagementRate,
          "phone": draft.phone,
          "email": draft.email,
          "address": draft.address,
          "location": draft.location,
          "rating": draft.rating,
          "is_favorite": draft.isFavorite == true ? 1 : 0,
          "is_blacklisted": draft.isBlacklisted == true ? 1 : 0,
        },
        where: "id=?",
        whereArgs: [draft.id],
      );

      // ---------------- OUTREACH ----------------

      if (_hasOutreachData(draft)) {

        final existing = await txn.query(
          "outreach",
          where: "creator_id=?",
          whereArgs: [draft.id],
        );

        final data = {
          "creator_id": draft.id,
          "status": draft.outreachStatus,
          "first_message_date": draft.firstMessageDate?.toIso8601String(),
          "last_followup_date": draft.lastFollowupDate?.toIso8601String(),
          "next_followup_date": draft.nextFollowupDate?.toIso8601String(),
          "communication_channel": draft.communicationChannel,
          "followup_count": draft.followupCount,
        };

        if (existing.isEmpty) {
          await txn.insert("outreach", data);
        } else {
          await txn.update(
            "outreach",
            data,
            where: "creator_id=?",
            whereArgs: [draft.id],
          );
        }
      }

      // ---------------- DEALS ----------------

      if (_hasDealData(draft)) {

        final existing = await txn.query(
          "deals",
          where: "creator_id=?",
          whereArgs: [draft.id],
        );

        final data = {
          "creator_id": draft.id,
          "collaboration_type": draft.collaborationType,
          "asked_price": draft.askedPrice,
          "final_price": draft.finalPrice,
          "deliverables": draft.deliverables,
          "status": draft.dealStatus,
        };

        if (existing.isEmpty) {
          await txn.insert("deals", data);
        } else {
          await txn.update(
            "deals",
            data,
            where: "creator_id=?",
            whereArgs: [draft.id],
          );
        }
      }

      // ---------------- PRODUCT TRACKING ----------------

      if (_hasProductData(draft)) {

        final existing = await txn.query(
          "product_tracking",
          where: "creator_id=?",
          whereArgs: [draft.id],
        );

        final data = {
          "creator_id": draft.id,
          "product_name": draft.productName,
          "status": draft.productStatus,
          "courier": draft.courier,
          "tracking_number": draft.trackingNumber,
          "dispatch_date": draft.dispatchDate?.toIso8601String(),
          "delivery_date": draft.deliveryDate?.toIso8601String(),
        };

        if (existing.isEmpty) {
          await txn.insert("product_tracking", data);
        } else {
          await txn.update(
            "product_tracking",
            data,
            where: "creator_id=?",
            whereArgs: [draft.id],
          );
        }
      }

      // ---------------- CONTENT ----------------

      if (_hasContentData(draft)) {

        final existing = await txn.query(
          "content",
          where: "creator_id=?",
          whereArgs: [draft.id],
        );

        final data = {
          "creator_id": draft.id,
          "content_received": draft.contentReceived == true ? 1 : 0,
          "content_approved": draft.contentApproved == true ? 1 : 0,
          "posting_date": draft.postingDate?.toIso8601String(),
          "content_link": draft.contentLink,
          "ad_permission": draft.adPermission == true ? 1 : 0,
        };

        if (existing.isEmpty) {
          await txn.insert("content", data);
        } else {
          await txn.update(
            "content",
            data,
            where: "creator_id=?",
            whereArgs: [draft.id],
          );
        }
      }

      // ---------------- PAYMENTS ----------------

      if (_hasPaymentData(draft)) {

        final existing = await txn.query(
          "payments",
          where: "creator_id=?",
          whereArgs: [draft.id],
        );

        final data = {
          "creator_id": draft.id,
          "amount": draft.amount,
          "status": draft.paymentStatus,
          "payment_date": draft.paymentDate?.toIso8601String(),
          "payment_method": draft.paymentMethod,
          "invoice_number": draft.invoiceNumber,
        };

        if (existing.isEmpty) {
          await txn.insert("payments", data);
        } else {
          await txn.update(
            "payments",
            data,
            where: "creator_id=?",
            whereArgs: [draft.id],
          );
        }
      }

      // ---------------- NOTES ----------------

      if (draft.note != null && draft.note!.isNotEmpty) {

        final existing = await txn.query(
          "notes",
          where: "creator_id=?",
          whereArgs: [draft.id],
        );

        final data = {
          "creator_id": draft.id,
          "note": draft.note,
          "created_at": DateTime.now().toIso8601String(),
        };

        if (existing.isEmpty) {
          await txn.insert("notes", data);
        } else {
          await txn.update(
            "notes",
            data,
            where: "creator_id=?",
            whereArgs: [draft.id],
          );
        }
      }

      emit(CreatorUpdatedSuccess(draft.id!));
    });

  } catch (e) {

    emit(CreatorSaveError("Update failed: ${e.toString()}"));

  }
}
}
