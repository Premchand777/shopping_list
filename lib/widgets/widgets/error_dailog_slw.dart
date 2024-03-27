import 'package:flutter/material.dart';

class ErrorDailogSLW extends StatelessWidget {
  const ErrorDailogSLW({
    super.key,
    required this.message,
    required this.onPressed,
  });

  final String message;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      icon: Icon(
        Icons.error_rounded,
        color: Theme.of(context).colorScheme.onError,
        size: 36.0,
      ),
      title: Text(
        'Error',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onError,
            ),
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onError,
            ),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      shadowColor: const Color.fromARGB(255, 32, 49, 57),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.onError,
            ),
          ),
          onPressed: onPressed,
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
          ),
        ),
      ],
    );
  }
}
