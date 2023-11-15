import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder/data/models/profile.dart';
import 'package:kinder/repositories/profiles_repository.dart';

part 'profiles_state.dart';

abstract class ProfilesCubit extends Cubit<ProfilesState> {
  ProfilesCubit() : super(ProfilesInitial());

  Future<void> fetchProfiles();
}

class ProfileCubitImpl extends ProfilesCubit {
  final ProfilesRepository profileRepository;

  ProfileCubitImpl({
    required this.profileRepository,
  });

  @override
  Future<void> fetchProfiles() async {
    try {
      emit(ProfilesLoading());
      final profile = await profileRepository.fetchProfiles();
      emit(ProfilesLoaded(profile));
    } catch (e) {
      emit(ProfilesError(e.toString()));
    }
  }
}
