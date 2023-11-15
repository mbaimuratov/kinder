class Profile {
  final String name;
  final String location;
  final int followers;
  final int posts;
  final int following;
  final List<String> photoUrls;
  bool isFollowing;
  final String? bio;

  Profile({
    required this.name,
    required this.location,
    required this.followers,
    required this.posts,
    required this.following,
    required this.photoUrls,
    this.isFollowing = false,
    this.bio,
  });

  void toggleFollowStatus() {
    isFollowing = !isFollowing;
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      location: json['location'],
      followers: json['followers'],
      posts: json['posts'],
      following: json['following'],
      photoUrls: List<String>.from(json['photoUrls']),
      isFollowing: json['isFollowing'] ?? false,
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'location': location,
        'followers': followers,
        'posts': posts,
        'following': following,
        'photoUrls': photoUrls,
        'isFollowing': isFollowing,
        'bio': bio,
      };
}
