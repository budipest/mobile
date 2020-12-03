import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../../core/models/Toilet.dart';
import '../../core/models/Vote.dart';
import '../../core/providers/ToiletModel.dart';
import 'Button.dart';

class RatingBar extends StatelessWidget {
  const RatingBar(this.toilet);
  final Toilet toilet;

  int calculateVote(int myVote, bool isUpvote) {
    // returns vote value
    // 1 is an upvote
    // 0 counts as a withdrawn, neutral vote
    // -1 is a downvote

    switch (myVote) {
      // i had an upvote
      case 1:
        return isUpvote ? 0 : -1;
      // i had a downvote
      case -1:
        return isUpvote ? 1 : 0;
      // i didn't have a vote
      default:
        return isUpvote ? 1 : -1;
    }
  }

  void castVote(BuildContext context, int currentVote, bool isUpvote) {
    int vote = calculateVote(currentVote, isUpvote);

    Provider.of<ToiletModel>(context, listen: false).voteToilet(vote);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToiletModel>(context);

    int upvotes = 0;
    int downvotes = 0;
    int myVote = 0;

    toilet.votes.forEach((Vote vote) {
      if (vote.userId == provider.userId) {
        myVote = vote.value;
      }

      switch (vote.value) {
        case 1:
          upvotes++;
          break;
        case -1:
          downvotes++;
          break;
      }
    });

    return Row(
      children: <Widget>[
        Text(
          FlutterI18n.translate(context, "rate"),
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Button(
            upvotes.toString(),
            () => castVote(context, myVote, true),
            icon: Icons.thumb_up,
            backgroundColor: myVote == 1 ? Colors.black : Colors.grey[600],
            foregroundColor: Colors.white,
            isMini: true,
          ),
        ),
        Button(
          downvotes.toString(),
          () => castVote(context, myVote, false),
          icon: Icons.thumb_down,
          backgroundColor: myVote == -1 ? Colors.black : Colors.grey[600],
          foregroundColor: Colors.white,
          isMini: true,
        ),
      ],
    );
  }
}
