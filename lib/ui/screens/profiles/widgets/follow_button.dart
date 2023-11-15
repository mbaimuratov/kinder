import 'package:flutter/material.dart';

class AnimatedFollowButton extends StatefulWidget {
  const AnimatedFollowButton({super.key});

  @override
  State createState() => _AnimatedFollowButtonState();
}

class _AnimatedFollowButtonState extends State<AnimatedFollowButton> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFollowing = !isFollowing;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isFollowing ? 40 : 120,
        height: 40,
        decoration: BoxDecoration(
          color: isFollowing ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFollowing ? Colors.red : Colors.red,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isFollowing
              ? Icon(Icons.person, color: Colors.white, key: UniqueKey())
              : Text(
                  'FOLLOW',
                  style: const TextStyle(color: Colors.red),
                  key: UniqueKey(),
                ),
        ),
      ),
    );
  }
}
