import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder/cubit/profiles/profiles_cubit.dart';
import 'package:kinder/ui/screens/profiles/widgets/follow_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PageController _pageController = PageController();
  double _bottomSheetTopPercentage = 0.7;
  double _sheetProgress = 0.0;
  int _currentPage = 0;

  bool _isAnimatingText = false;

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
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  height: photoHeight,
                  child: PageView.builder(
                    physics: const PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: profiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        profiles[index].photoUrls.first,
                        fit: BoxFit.fitWidth,
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _isAnimatingText = true;
                        Future.delayed(const Duration(milliseconds: 200), () {
                          setState(() {
                            _isAnimatingText = false;
                            _currentPage = index;
                          });
                        });
                      });
                    },
                  ),
                ),
                NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    setState(() {
                      _bottomSheetTopPercentage = 1 - notification.extent;
                      photoHeight = screenHeight * _bottomSheetTopPercentage + 50;
                      _sheetProgress = (notification.extent - 0.3) / 0.3;
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
                              opacity: _isAnimatingText ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: _buildSocialStats(
                                profiles[_currentPage].followers,
                                profiles[_currentPage].posts,
                                profiles[_currentPage].following,
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
                              child: ListView(
                                controller: scrollController,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AnimatedOpacity(
                                              opacity: _isAnimatingText ? 0.0 : 1.0,
                                              duration: const Duration(milliseconds: 200),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    profiles[_currentPage].name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    profiles[_currentPage].location,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            AnimatedFollowButton(
                                              following: profiles[_currentPage].isFollowing,
                                              onPressed: () {
                                                setState(() {
                                                  profiles[_currentPage].isFollowing = !profiles[_currentPage].isFollowing;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Opacity(
                                    opacity: _sheetProgress.clamp(0.0, 1.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        profiles[_currentPage].bio ?? '',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Opacity(
                                    opacity: _sheetProgress.clamp(0.0, 1.0),
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
                                                  child: Image.network(
                                                    profiles[_currentPage].photoUrls[index],
                                                    fit: BoxFit.fitWidth,
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
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildSocialStats(int followers, int posts, int following) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildSocialStat(followers.toString(), 'Followers'),
          _buildSocialStat(posts.toString(), 'Posts'),
          _buildSocialStat(following.toString(), 'Following'),
        ],
      ),
    );
  }

  Widget _buildSocialStat(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
