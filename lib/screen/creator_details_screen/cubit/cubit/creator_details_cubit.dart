import 'package:bloc/bloc.dart';
import 'package:creator_tracker/database/database_service.dart';
import 'package:creator_tracker/models/content_model.dart';
import 'package:creator_tracker/models/creator_model.dart';
import 'package:creator_tracker/models/deal_model.dart';
import 'package:creator_tracker/models/note_model.dart';
import 'package:creator_tracker/models/outreach_model.dart';
import 'package:creator_tracker/models/payment_model.dart';
import 'package:creator_tracker/models/product_model.dart';
import 'package:equatable/equatable.dart';

part 'creator_details_state.dart';

class CreatorFullDetail {

  final Creator creator;

  final Outreach? outreach;
  final Deal? deal;
  final ProductTracking? product;
  final Content? content;
  final Payment? payment;
  final Note? note;

  CreatorFullDetail({
    required this.creator,
    this.outreach,
    this.deal,
    this.product,
    this.content,
    this.payment,
    this.note,
  });

}

class CreatorDetailsCubit extends Cubit<CreatorDetailsState> {

  CreatorDetailsCubit() : super(CreatorDetailsInitial());

  Future<void> loadCreatorDetail(int creatorId) async {

    try {

      emit(CreatorDetailLoading());

      final db = await DatabaseService.database;

      /// ---------------- Creator ----------------

      final creatorRows = await db.query(
        "creators",
        where: "id=?",
        whereArgs: [creatorId],
      );

      if (creatorRows.isEmpty) {
        emit(CreatorDetailError("Creator not found"));
        return;
      }

      final creator = Creator.fromMap(creatorRows.first);

      /// ---------------- Outreach ----------------

      final outreachRows = await db.query(
        "outreach",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      Outreach? outreach;

      if (outreachRows.isNotEmpty) {
        outreach = Outreach.fromMap(outreachRows.first);
      }

      /// ---------------- Deal ----------------

      final dealRows = await db.query(
        "deals",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      Deal? deal;

      if (dealRows.isNotEmpty) {
        deal = Deal.fromMap(dealRows.first);
      }

      /// ---------------- Product ----------------

      final productRows = await db.query(
        "product_tracking",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      ProductTracking? product;

      if (productRows.isNotEmpty) {
        product = ProductTracking.fromMap(productRows.first);
      }

      /// ---------------- Content ----------------

      final contentRows = await db.query(
        "content",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      Content? content;

      if (contentRows.isNotEmpty) {
        content = Content.fromMap(contentRows.first);
      }

      /// ---------------- Payment ----------------

      final paymentRows = await db.query(
        "payments",
        where: "creator_id=?",
        whereArgs: [creatorId],
      );

      Payment? payment;

      if (paymentRows.isNotEmpty) {
        payment = Payment.fromMap(paymentRows.first);
      }

      /// ---------------- Note ----------------

      final noteRows = await db.query(
        "notes",
        where: "creator_id=?",
        whereArgs: [creatorId],
        orderBy: "created_at DESC",
      );

      Note? note;

      if (noteRows.isNotEmpty) {
        note = Note.fromMap(noteRows.first);
      }

      /// ---------------- Combined Model ----------------

      final data = CreatorFullDetail(
        creator: creator,
        outreach: outreach,
        deal: deal,
        product: product,
        content: content,
        payment: payment,
        note: note,
      );

      emit(CreatorDetailLoaded(data));

    } catch (e, stack) {

      print("Creator Detail Error: $e");
      print(stack);

      emit(CreatorDetailError("Failed to load creator details"));

    }

  }

}