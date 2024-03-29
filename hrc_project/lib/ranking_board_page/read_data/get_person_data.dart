import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ranking_board_design/ranking_borad_design.dart';

class GetPersonData extends StatelessWidget {
  final String documentId;
  final int number;
  final bool isTime;
  BuildContext context;
  GlobalKey typeKey;
  GlobalKey userKey;

  GetPersonData({
    Key? key,
    required this.documentId,
    required this.number,
    required this.isTime,
    required this.context,
    required this.typeKey,
    required this.userKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (number == 0) {
            return ranking1st(data, number + 1, isTime, documentId, context,
                typeKey, userKey);
          } else if (number == 1) {
            return ranking2nd(
                data, number + 1, isTime, documentId, context, userKey);
          } else if (number == 2) {
            return ranking3rd(
                data, number + 1, isTime, documentId, context, userKey);
          }
          return rankingDesign(
              data, number + 1, isTime, documentId, context, userKey);
        }

        return const SizedBox.shrink();
      }),
    );
  }
}
