import 'package:kinder/data/providers/profiles_api_provider.dart';

abstract class ProfilesRepository<T> {
  Future<T> fetchProfiles();
}

class ProfilesRepositoryImpl implements ProfilesRepository {
  final ProfilesApiProvider apiProvider;

  ProfilesRepositoryImpl({
    required this.apiProvider,
  });

  @override
  Future fetchProfiles() async {
    return apiProvider.fetchProfiles();
  }
}
