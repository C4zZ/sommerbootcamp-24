import 'package:flutter/material.dart';

class LikeAction extends StatefulWidget {
  const LikeAction({super.key});

  @override
  State<LikeAction> createState() => _LikeActionState();
}

class _LikeActionState extends State<LikeAction> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: IconButton(
          onPressed: () {
            // TODO(team): erweitere dieses Widget so, dass beim Antippen das
            //  Herz rot wird. Beim erneuten Antippen soll das Herz wieder weiß
            //  werden.
          },
          icon: const Icon(Icons.bug_report),
        ),
      ),
    );
  }
}
