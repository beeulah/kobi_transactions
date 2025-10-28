import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final String? message;
  const LoadingSpinner({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!, style: theme.textTheme.bodySmall),
          ]
        ],
      ),
    );
  }
}
