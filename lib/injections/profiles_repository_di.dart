import 'package:kinder/injections/profiles_api_provider_di.dart';
import 'package:kinder/repositories/profiles_repository.dart';

class ProfilesRepositoryInject {
  static ProfilesRepository? _profilesRepository;

  ProfilesRepositoryInject._();

  static ProfilesRepository get instance {
    return _profilesRepository ??= ProfilesRepositoryImpl(
      apiProvider: ProfilesApiProviderInject.instance,
    );
  }
}
