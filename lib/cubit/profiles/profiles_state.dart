part of 'profiles_cubit.dart';

abstract class ProfilesState {}

class ProfilesInitial extends ProfilesState {}

class ProfilesLoading extends ProfilesState {}

class ProfilesLoaded extends ProfilesState {
  final List<Profile> profiles;
  ProfilesLoaded(this.profiles);
}

class ProfilesError extends ProfilesState {
  final String message;
  ProfilesError(this.message);
}
