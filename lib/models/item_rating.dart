class ItemRating {
  final int id;
  final double rating;
  final String userEmail;
  final String comment;
  final String? userImageUrl;

  ItemRating({required this.id, required this.rating, required this.userEmail, required this.comment, required this.userImageUrl});

  factory ItemRating.fromJson(Map<String, dynamic> json) {
    return ItemRating(
      id: json['id'],
      rating: json['rating'].toDouble(),
      userEmail: json['userEmail'],
      comment: json['comment'],
      userImageUrl: json['userImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'userEmail': userEmail,
      'comment': comment,
      'userImageUrl': userImageUrl,
    };
  }
}