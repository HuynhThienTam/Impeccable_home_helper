import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impeccablehome_helper/model/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection name
  final String _reviewsCollection = 'reviews';

  /// Function to upload a review to Firestore
  Future<void> uploadReview(ReviewModel review) async {
    try {
      await _firestore.collection(_reviewsCollection).add(review.toMap());
      print('Review uploaded successfully!');
    } catch (e) {
      print('Failed to upload review: $e');
      throw e; // Optionally rethrow the error
    }
  }

  /// Function to fetch reviews by helperId
  Future<List<ReviewModel>> getReviewsByHelperId(String helperId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_reviewsCollection)
          .where('helperId', isEqualTo: helperId)
          .get();

      return snapshot.docs.map((doc) {
        return ReviewModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Failed to fetch reviews: $e');
      throw e; // Optionally rethrow the error
    }
  }
}
