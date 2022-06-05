import 'package:flutter/material.dart';

class TopComponent extends StatefulWidget {
  final String? error;
  const TopComponent({Key? key, required this.error}) : super(key: key);

  @override
  State<TopComponent> createState() => _TopComponentState();
}

class _TopComponentState extends State<TopComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "LogIn",
          style: TextStyle(
            fontSize: 38.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
        if (widget.error != null && widget.error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red[100],
                border: Border.all(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.warning,
                      color: Colors.orange,
                    ),
                    Text(
                      widget.error!,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
