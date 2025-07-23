//lib/presentation/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportefy/presentation/widgets/common/or_divider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../../bloc/auth/auth_bloc.dart';
import '../../../data/model/signup_request.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/oauth_button.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/clickable_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      final signupRequest = SignUpRequest(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        agreedToTerms: _agreedToTerms,
      );

      context.read<AuthBloc>().add(
        SignUpRequested(signUpRequest: signupRequest),
      );
    }
  }

  void _handleOAuthSignIn(OAuthProvider provider) {
    context.read<AuthBloc>().add(OAuthSignInRequested(provider: provider));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Success!')),
            );
            Navigator.of(context).pushReplacementNamed('/signin');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getHorizontalPadding(context),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: double.infinity,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              24,
                            ),
                          ),
                          _buildSocialLoginSection(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              24,
                            ),
                          ),
                          OrDivider(),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              24,
                            ),
                          ),
                          _buildFormFields(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              8,
                            ),
                          ),
                          _buildTermsCheckbox(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              8,
                            ),
                          ),
                          _buildCreateAccountButton(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              24,
                            ),
                          ),
                          _buildSignInLink(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.signUp, style: AppTextStyles.h1),
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 8)),
        Text(AppStrings.signUpDescription, style: AppTextStyles.body),
      ],
    );
  }

  Widget _buildSocialLoginSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OAuthButton(
            icon: Image.asset('assets/logos/apple.png', width: 24, height: 24),
            label: AppStrings.appleId,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.apple),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 10)),
        Expanded(
          child: OAuthButton(
            icon: Image.asset('assets/logos/google.png', width: 24, height: 24),
            label: AppStrings.google,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.google),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 10)),
        Expanded(
          child: OAuthButton(
            icon: Image.asset(
              'assets/logos/facebook.png',
              width: 24,
              height: 24,
            ),
            label: AppStrings.facebook,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.facebook),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          hintText: AppStrings.name,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        CustomTextField(
          controller: _emailController,
          hintText: AppStrings.emailOrPhone,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        CustomTextField(
          controller: _passwordController,
          hintText: AppStrings.password,
          obscureText: _obscurePassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.grey1,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        CustomTextField(
          controller: _confirmPasswordController,
          hintText: AppStrings.confirmPassword,
          obscureText: _obscureConfirmPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.grey1,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) {
              setState(() {
                _agreedToTerms = value ?? false;
              });
            },
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _agreedToTerms = !_agreedToTerms;
              });
            },
            child: Wrap(
              children: [
                Text(
                  AppStrings.agreeToTerms,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                ClickableText(
                  text: AppStrings.termsOfService,
                  url: 'https://sportefy.com/terms',
                  fontSize: 12,
                  color: AppColors.primary,
                ),
                Text(
                  AppStrings.and,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                ClickableText(
                  text: AppStrings.privacyPolicy,
                  url: 'https://sportefy.com/privacy',
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return PrimaryButton(
          text: AppStrings.createAccount,
          onPressed: _agreedToTerms ? _handleSignUp : null,
          isLoading: state is AuthLoading,
        );
      },
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.haveAccount,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              fontFamily: 'Lexend',
              color: AppColors.grey1,
              fontWeight: FontWeight.w400,
            ),
          ),
          ClickableText(
            text: AppStrings.signIn,
            routeName: '/signin',
            color: AppColors.primary,
            fontSize: 14,
            isBold: false,
          ),
        ],
      ),
    );
  }
}
