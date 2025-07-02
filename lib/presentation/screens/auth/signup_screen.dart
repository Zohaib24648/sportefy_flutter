//lib/presentation/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../../data/model/signup_request.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/oauth_button.dart';
import '../../widgets/primary_button.dart';

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
      final signupRequest = SignupRequest(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        agreedToTerms: _agreedToTerms,
      );

      context.read<AuthBloc>().add(
        SignUpRequested(signupRequest: signupRequest),
      );
    }
  }

  void _handleOAuthSignIn(OAuthProvider provider) {
    context.read<AuthBloc>().add(OAuthSignInRequested(provider: provider));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Navigate to home screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sign up successful!')),
            );
          } else if (state is AuthFailure) {
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
                    maxWidth: ResponsiveHelper.isDesktop(context)
                        ? 400
                        : double.infinity,
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
                          _buildDivider(context),
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
                              20,
                            ),
                          ),
                          _buildTermsCheckbox(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              32,
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
        Text(AppStrings.signUp, style: AppStyles.heading(context)),
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 16)),
        Text(AppStrings.signUpDescription, style: AppStyles.bodyText(context)),
      ],
    );
  }

  Widget _buildSocialLoginSection(BuildContext context) {
    if (ResponsiveHelper.getResponsiveWidth(context) < 350) {
      return Column(
        children: [
          OAuthButton(
            icon: Icons.apple,
            label: AppStrings.appleId,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.apple),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 8)),
          OAuthButton(
            icon: Icons.g_mobiledata,
            label: AppStrings.google,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.google),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 8)),
          OAuthButton(
            icon: Icons.facebook,
            label: AppStrings.facebook,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.facebook),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OAuthButton(
            icon: Icons.apple,
            label: AppStrings.appleId,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.apple),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 10)),
        Expanded(
          child: OAuthButton(
            icon: Icons.g_mobiledata,
            label: AppStrings.google,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.google),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 10)),
        Expanded(
          child: OAuthButton(
            icon: Icons.facebook,
            label: AppStrings.facebook,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.facebook),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.dividerColor, thickness: 2),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsiveSpacing(context, 16),
          ),
          child: Text(
            AppStrings.or,
            style: TextStyle(
              color: const Color(0xFF262626),
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.dividerColor, thickness: 1),
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
          prefixIcon: Icon(
            Icons.person,
            color: const Color.fromARGB(128, 234, 0, 0),
          ),
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
              color: AppColors.iconColor,
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
              color: AppColors.iconColor,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: ResponsiveHelper.isMobile(context) ? 0.9 : 1.0,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) {
              setState(() {
                _agreedToTerms = value ?? false;
              });
            },
            activeColor: AppColors.primaryColor,
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
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      12,
                    ),
                    fontFamily: 'Lexend',
                    height: 1.83,
                  ),
                  children: [
                    TextSpan(
                      text: AppStrings.agreeToTerms,
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.termsOfService,
                      style: AppStyles.linkText(context).copyWith(fontSize: 12),
                    ),
                    TextSpan(
                      text: AppStrings.and,
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.privacyPolicy,
                      style: AppStyles.linkText(context).copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
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
      child: GestureDetector(
        onTap: () {
          // Navigate to sign in screen
          Navigator.of(context).pushReplacementNamed('/signin');
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              fontFamily: 'Lexend',
              height: 1.57,
            ),
            children: [
              const TextSpan(
                text: AppStrings.haveAccount,
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: AppStrings.signIn,
                style: AppStyles.linkText(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
