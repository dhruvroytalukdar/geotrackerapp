import 'package:flutter/material.dart';

class ContentSection extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ContentSection({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<ContentSection> createState() => _ContentSectionState();
}

class _ContentSectionState extends State<ContentSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      widget.scaffoldKey.currentState!.openEndDrawer();
                    },
                    icon: const Icon(
                      Icons.menu_rounded,
                      size: 34,
                      //color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
