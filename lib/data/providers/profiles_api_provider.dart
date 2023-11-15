import 'dart:math';

import 'package:kinder/data/models/profile.dart';

abstract class ProfilesApiProvider {
  Future<List<Profile>> fetchProfiles();
}

class ProfilesApiProviderImpl implements ProfilesApiProvider {
  @override
  Future<List<Profile>> fetchProfiles() async {
    await Future.delayed(const Duration(seconds: 2));

    final names = [
      "Peter Parker",
      "Tony Stark",
      "Steve Rogers",
    ];

    final locations = [
      "New York, USA",
      "London, UK",
      "Washington D.C., USA",
    ];

    final bioList = [
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
      "Donec euismod, nisl sed aliquet vulputate, elit arcu aliquam nunc, vitae ultricies eros nisl vitae nunc",
      "Nisl sed aliquet vulputate, elit arcu aliquam nunc, vitae ultricies eros nisl vitae nunc. Donec euismod, nisl sed aliquet vulputate, elit arcu aliquam nunc, vitae ultricies eros nisl vitae nunc.",
    ];

    return List.generate(3, (index) {
      return Profile(
        name: names[index],
        location: locations[index],
        followers: 1000 + Random.secure().nextInt(1000),
        posts: 100 + Random.secure().nextInt(100),
        following: 1000 + Random.secure().nextInt(1000),
        photoUrls: List.generate(5, (photoIndex) => 'https://picsum.photos/500/900?image=${index * 5 + photoIndex}'),
        isFollowing: false,
        bio: bioList[index],
      );
    });
  }
}
