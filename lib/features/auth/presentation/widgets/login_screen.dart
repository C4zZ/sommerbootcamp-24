import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../app_theme.dart';
import '../../shared.dart';

/// Login Screen Widget
class LoginScreen extends ConsumerStatefulWidget {
  /// constructor
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget buildAlertDialog(BuildContext context) {
      const title = 'Anmeldung fehlgeschlagen';
      const content = 'Dein Benutzername und/oder Passwort sind nicht korrekt.';
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: const Text(title),
          content: const Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      }

      return AlertDialog(
        title: const Text(title),
        content: const Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Stack(
              children: [
                if (Orientation.portrait == orientation)
                  SizedBox(
                    height: constraint.maxHeight * 0.25,
                    width: constraint.maxWidth,
                    child: Image.asset(
                      'assets/images/login_header_image.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: Orientation.portrait == orientation
                        ? constraint.maxHeight * 0.8
                        : constraint.maxHeight,
                    width: constraint.maxWidth,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Sommerbootcamp '24",
                            style: TextStyle(
                              fontFamily: AppTheme.pacificoFontName,
                              fontSize: 24,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Melde dich an um fortzufahren...',
                              style: textTheme.bodySmall,
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: SizedBox(
                              width: constraint.maxWidth * 0.85,
                              height: constraint.maxHeight * 0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      hintText: 'eMail',
                                      helperText: '',
                                      prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                    validator:
                                        ValidationBuilder(localeName: 'de')
                                            .required()
                                            .email()
                                            .build(),
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      hintText: 'Passwort',
                                      helperText: '',
                                      prefixIcon:
                                          const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          // TODO(team): Implementiere eine
                                          //  Funktion die das Passwort im
                                          //  Klartext zur Kontrolle anzeigt

                                          // Option A
                                          // setState(() {
                                          //   _obscurePassword =
                                          //       _obscurePassword;
                                          // });

                                          // Option B
                                          // setStates(() {
                                          //   _obscurePassword =
                                          //       !_obscurePassword;
                                          // });

                                          // Option D
                                          //   _obscurePassword = true

                                          // Option D
                                          // setState(() {
                                          //   _obscurePassword =
                                          //       !_obscurePassword;
                                          // });

                                          // Option E
                                          //   _obscurePassword =
                                          //       !_obscurePassword;
                                        },
                                        icon: const Icon(
                                          Icons.remove_red_eye_outlined,
                                        ),
                                      ),
                                    ),
                                    obscureText: _obscurePassword,
                                    validator:
                                        ValidationBuilder(localeName: 'de')
                                            .required()
                                            .build(),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {

                                      try {
                                        // TODO(team): Validiere Email und
                                        //  Passwort

                                        // TODO(team): Implementiere die
                                        //  Nutzeranmeldung

                                      } catch (e) {
                                        unawaited(
                                          showDialog(
                                            context: context,
                                            builder: buildAlertDialog,
                                          ),
                                        );
                                      }
                                    },
                                    minWidth: double.infinity,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    textColor: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    child: const Text('Login'),
                                  ),
                                  const Text('Passwort vergessen')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
