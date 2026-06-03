import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({super.key});

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  var _mode = 'login';

  bool get _isSignUp => _mode == 'signup';

  void _showPrototypeMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18),
          const Center(child: BrandMark()),
          const SizedBox(height: 18),
          Text(
            'MealCrunchy',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Votre guide nutritionnel personnalise par l\'IA',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 26),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'login', label: Text('Connexion')),
                    ButtonSegment(value: 'signup', label: Text('S\'inscrire')),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (selection) {
                    setState(() => _mode = selection.single);
                  },
                ),
                const SizedBox(height: 22),
                if (_isSignUp) ...[
                  Text(
                    'Nom complet',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_rounded),
                      labelText: 'Nom',
                      hintText: 'Alex Rivers',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Adresse e-mail',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                    labelText: 'Email',
                    hintText: 'hello@example.com',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Mot de passe',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    suffixIcon: Icon(Icons.visibility_off_rounded),
                    labelText: 'Mot de passe',
                    hintText: 'Mot de passe',
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _showPrototypeMessage(
                        'La reinitialisation du mot de passe n\'est pas encore connectee.',
                      );
                    },
                    child: const Text('Mot de passe oublie ?'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.onboardingGoals),
                  child: Text(_isSignUp ? 'Creer un compte' : 'Se connecter'),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ou',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _SocialButton(
                        label: 'Google',
                        onPressed: () {
                          _showPrototypeMessage(
                            'La connexion Google n\'est pas encore connectee.',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SocialButton(
                        label: 'Apple',
                        onPressed: () {
                          _showPrototypeMessage(
                            'La connexion Apple n\'est pas encore connectee.',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SocialButton(
                        label: 'Facebook',
                        onPressed: () {
                          _showPrototypeMessage(
                            'La connexion Facebook n\'est pas encore connectee.',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isSignUp
                    ? 'Vous avez deja un compte ?'
                    : 'Nouveau sur MealCrunchy ?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _mode = _isSignUp ? 'login' : 'signup');
                },
                child: Text(_isSignUp ? 'Se connecter' : 'Creer un compte'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
