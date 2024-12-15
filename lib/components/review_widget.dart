import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/components/stars_widget.dart';
import 'package:impeccablehome_helper/model/review_model.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;

  const ReviewWidget({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User avatar
            CircleAvatar(
              radius: 26,
              backgroundImage: review.profilePic.isNotEmpty
                  ? NetworkImage(review.profilePic)
                  : null,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 20),
            // User details and review content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User name and stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(child: Container(),),
                      StarsWidget(ratings: review.ratings.toInt()),
                      SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Review content
                  Text(
                    review.reviewContent,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  // Review pictures row
                  if (review.reviewPics.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: review.reviewPics.map((picUrl) {
                        return Image.network(
                          picUrl,
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
