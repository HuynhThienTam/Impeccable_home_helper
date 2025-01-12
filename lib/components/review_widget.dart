import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/components/stars_widget.dart';
import 'package:impeccablehome_helper/model/review_model.dart';
import 'package:impeccablehome_helper/model/user_model.dart';
import 'package:impeccablehome_helper/resources/user_services.dart';

class ReviewWidget extends StatefulWidget {
  final ReviewModel review;

  const ReviewWidget({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  bool isLoading = true; // State to track loading
  final UserService userService = UserService();
  UserModel? user;
  @override
  void initState() {
    super.initState();
    _fetchUser(); // Fetch user details when the widget is initialized
  }
  Future<void> _fetchUser() async {
    try {
      final fetchedUser = await userService.fetchUserDetails(widget.review.userId);

      if (fetchedUser != null) {
        setState(() {
          user = fetchedUser;
        });
      }
    } catch (e) {
      // Handle errors (optional)
      print('Error fetching helper: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading once data is fetched
      });
    }
  }
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
            isLoading? CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage("https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI="),
              backgroundColor: Colors.grey[300],
            ):CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(user!.profilePic),
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
                      isLoading?Container():Text(
                         user!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(child: Container(),),
                      StarsWidget(ratings: widget.review.ratings.toInt()),
                      SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Review content
                  Text(
                    widget.review.reviewContent,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  // Review pictures row
                  if (widget.review.reviewPics.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: widget.review.reviewPics.map((picUrl) {
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
