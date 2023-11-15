import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder/cubit/profiles/profiles_cubit.dart';
import 'package:kinder/data/models/profile.dart';
import 'package:kinder/ui/screens/profiles/widgets/follow_button.dart';
import 'package:kinder/ui/screens/profiles/widgets/profile_statistics.dart';
import 'package:kinder/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PageController _pageController = PageController();

  double _bottomSheetTopPercentage = 0.7;
  double _additionalInfoFade = 0.0;
  double _textOpacity = 1.0;
  double _textOffset = 0.0;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<ProfilesCubit>(context).fetchProfiles();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double photoHeight = screenHeight * _bottomSheetTopPercentage + 50;

    return BlocBuilder<ProfilesCubit, ProfilesState>(
      builder: (context, state) {
        if (state is ProfilesLoaded) {
          final profiles = state.profiles;
          return Scaffold(
            body: Stack(
              children: [
                AnimatedContainer(
                  duration: kProfilePhotoAnimationDuration,
                  curve: Curves.easeInOut,
                  height: photoHeight,
                  child: _buildPhotosPageView(profiles),
                ),
                NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    setState(() {
                      _bottomSheetTopPercentage = 1 - notification.extent;
                      photoHeight = screenHeight * _bottomSheetTopPercentage + 50;
                      _additionalInfoFade = (notification.extent - 0.3) / 0.3;
                    });
                    return true;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    minChildSize: 0.3,
                    maxChildSize: 0.6,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: AnimatedOpacity(
                              curve: Curves.easeInOut,
                              opacity: _textOpacity,
                              duration: kTextAnimationDuration,
                              child: AnimatedContainer(
                                duration: kTextAnimationDuration,
                                transform: Matrix4.translationValues(0, _textOffset, 0),
                                child: _buildSocialStats(
                                  profiles[_currentPage].followers,
                                  profiles[_currentPage].posts,
                                  profiles[_currentPage].following,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              child: AnimatedOpacity(
                                curve: Curves.easeInOut,
                                opacity: _textOpacity,
                                duration: kTextAnimationDuration,
                                child: AnimatedContainer(
                                  duration: kTextAnimationDuration,
                                  transform: Matrix4.translationValues(0, _textOffset, 0),
                                  child: ListView(
                                    controller: scrollController,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildProfileNameAndLocation(
                                              profiles[_currentPage].name,
                                              profiles[_currentPage].location,
                                            ),
                                            FollowButton(
                                              following: profiles[_currentPage].isFollowing,
                                              onPressed: () {
                                                setState(() {
                                                  profiles[_currentPage].isFollowing = !profiles[_currentPage].isFollowing;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (profiles[_currentPage].bio?.isNotEmpty ?? false)
                                        Opacity(
                                          opacity: _additionalInfoFade.clamp(0.0, 1.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Text(
                                              profiles[_currentPage].bio!,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 20),
                                      Opacity(
                                        opacity: _additionalInfoFade.clamp(0.0, 1.0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Photos',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                height: 100,
                                                child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: profiles[_currentPage].photoUrls.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Padding(
                                                      padding: const EdgeInsets.only(right: 10),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: Image.network(
                                                          profiles[_currentPage].photoUrls[index],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  right: 10,
                  child: IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 10,
                  child: IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.person, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          );
        }

        if (state is ProfilesLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text('Error'),
          ),
        );
      },
    );
  }

  void _animateText() {
    // Start the text fading out and moving down
    setState(() {
      _textOpacity = 0.0;
      _textOffset = 20.0; // Adjust this value as needed for the downward movement
    });

    // Delay the end of the animation to match the duration of page change
    Future.delayed(kButtonAnimationDuration, () {
      setState(() {
        // Reset the text to its original position with full opacity
        _textOpacity = 1.0;
        _textOffset = 0.0;
      });
    });
  }

  Widget _buildSocialStats(int followers, int posts, int following) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileStatisticsWidget(count: followers, label: 'Followers'),
          ProfileStatisticsWidget(count: posts, label: 'Posts'),
          ProfileStatisticsWidget(count: following, label: 'Following'),
        ],
      ),
    );
  }

  Widget _buildPhotosPageView(List<Profile> profiles) {
    return PageView.builder(
      physics: const PageScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: profiles.length,
      itemBuilder: (BuildContext context, int index) {
        return Image.network(
          profiles[index].photoUrls.first,
          fit: BoxFit.fitWidth,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
      onPageChanged: (index) {
        _currentPage = index;
        _animateText();
      },
    );
  }

  Widget _buildProfileNameAndLocation(String name, String location) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          location,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
