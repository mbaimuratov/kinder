import 'package:flutter/material.dart';

class AnimatedFollowButton extends StatefulWidget {
  const AnimatedFollowButton({
    super.key,
    this.following = false,
    this.onPressed,
  });

  final bool following;
  final Function()? onPressed;

  @override
  State createState() => _AnimatedFollowButtonState();
}

class _AnimatedFollowButtonState extends State<AnimatedFollowButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.following ? 40 : 120,
        height: 40,
        decoration: BoxDecoration(
          color: widget.following ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.following ? Colors.red : Colors.red,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.following
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
