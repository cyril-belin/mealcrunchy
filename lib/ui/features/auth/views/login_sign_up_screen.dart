import 'package:flutter/material.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/auth/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({super.key});

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  var _mode = 'login';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _localErrorMessage;
  var _passwordVisible = false;

  bool get _isSignUp => _mode == 'signup';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthViewModel viewModel) async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final displayName = _nameController.text.trim();

    setState(() => _localErrorMessage = null);

    if (_isSignUp) {
      await viewModel.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
    } else {
      await viewModel.signIn(email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final errorMessage = _localErrorMessage ?? authViewModel.errorMessage;

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
            'Votre guide nutritionnel personnalisé par l\'IA',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 26),
          SoftCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'login', label: Text('Connexion')),
                      ButtonSegment(
                        value: 'signup',
                        label: Text('S\'inscrire'),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (selection) {
                      setState(() {
                        _mode = selection.single;
                        _localErrorMessage = null;
                        _passwordVisible = false;
                      });
                    },
                  ),
                  const SizedBox(height: 22),
                  if (_isSignUp) ...[
                    Text(
                      'Nom complet',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: const ValueKey('auth-name-field'),
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: _validateRequired,
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
                  TextFormField(
                    key: const ValueKey('auth-email-field'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: _validateEmail,
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
                  TextFormField(
                    key: const ValueKey('auth-password-field'),
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    textInputAction: TextInputAction.done,
                    autofillHints: _isSignUp
                        ? const [AutofillHints.newPassword]
                        : const [AutofillHints.password],
                    validator: _validateRequired,
                    onFieldSubmitted: (_) =>
                        authViewModel.isLoading ? null : _submit(authViewModel),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        key: const ValueKey('auth-password-visibility-button'),
                        tooltip: _passwordVisible
                            ? 'Masquer le mot de passe'
                            : 'Afficher le mot de passe',
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                        ),
                        onPressed: () {
                          setState(() => _passwordVisible = !_passwordVisible);
                        },
                      ),
                      labelText: 'Mot de passe',
                      hintText: 'Mot de passe',
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Text(
                        errorMessage,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  ElevatedButton(
                    key: const ValueKey('auth-submit-button'),
                    onPressed: authViewModel.isLoading
                        ? null
                        : () => _submit(authViewModel),
                    child: authViewModel.isLoading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isSignUp ? 'Créer un compte' : 'Se connecter'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isSignUp
                    ? 'Vous avez déjà un compte ?'
                    : 'Nouveau sur MealCrunchy ?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _mode = _isSignUp ? 'login' : 'signup';
                    _localErrorMessage = null;
                    _passwordVisible = false;
                  });
                },
                child: Text(_isSignUp ? 'Se connecter' : 'Créer un compte'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Champ requis.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final requiredError = _validateRequired(value);
    if (requiredError != null) {
      return requiredError;
    }
    final email = value!.trim();
    if (!email.contains('@') || email.startsWith('@') || email.endsWith('@')) {
      return 'Adresse e-mail invalide.';
    }
    return null;
  }
}
