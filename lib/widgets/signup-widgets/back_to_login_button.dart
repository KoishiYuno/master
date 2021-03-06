import 'package:flutter/material.dart';

class BackToLoginButton extends StatelessWidget {
  const BackToLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        'Already Have An Account? Sign Up',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
