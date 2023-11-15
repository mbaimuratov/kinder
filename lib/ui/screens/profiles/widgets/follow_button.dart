import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    this.following = false,
    this.onPressed,
  });

  final bool following;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: following ? 40 : 120,
        height: 40,
        decoration: BoxDecoration(
          color: following ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: following ? Colors.red : Colors.red,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: following
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
