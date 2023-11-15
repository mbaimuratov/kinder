import 'package:kinder/data/providers/profiles_api_provider.dart';

class ProfilesApiProviderInject {
  static ProfilesApiProvider? _profilesApiProvider;

  ProfilesApiProviderInject._();

  static ProfilesApiProvider get instance {
    return _profilesApiProvider ??= ProfilesApiProviderImpl();
  }
}
